// Behavioural tests for the project-owned secrets extension
// (ts/src/ext/secrets), driven through `options.extend` — the same seam a
// consumer would use.
//
// The contract under test: the `apikey` OPTION keeps its exact old meaning
// and always wins when set, because SecretsFeature places it FIRST in the
// provider chain — explicit-beats-lookup falls out of sekreto's first-hit
// rule. Without the feature nothing changes at all. With it and the option
// unset, the chain supplies the credential instead. A provider ERROR fails
// the operation rather than silently sending an unauthenticated request,
// and on the direct path it still comes back as a value, never a throw.

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe, beforeEach } from 'node:test'
import assert from 'node:assert'

import { SolardemoSDK } from '..'

// Imported the way a consumer does — from the built package, not from
// src: the test tree's rootDir is `test/`, and this mirrors the documented
// `@voxgig-sdk/solardemo/dist/ext/secrets` entry point.
const { SecretsFeature } = require('../dist/ext/secrets')


const PREFIX = 'SOLARDEMO_TEST_SECRETS_'


// Build a test client with the secrets feature attached via extend.
function makeSdk(secretopts: any, sdkopts?: any) {
  const opts: any = { ...(sdkopts || {}) }

  if (null != secretopts) {
    opts.feature = { ...(opts.feature || {}), secrets: secretopts }
    opts.extend = [new SecretsFeature()]
  }

  return SolardemoSDK.test({}, opts)
}


// prepare() returns the fetchdef the transport would receive. It runs NO
// feature hooks, so anything asserted here is proof the transport wrap
// (not the PreSpec hook) did the work.
async function preparedVia(sdk: any): Promise<any> {
  const captured: any = {}
  const utility: any = (sdk as any)._utility
  const inner = utility.fetcher

  utility.fetcher = async (ctx: any, url: string, fetchdef: any) => {
    captured.fetchdef = fetchdef
    return inner(ctx, url, fetchdef)
  }

  const res = await sdk.direct({ path: '/api/planet' })
  return { res, fetchdef: captured.fetchdef }
}


describe('secrets', () => {

  beforeEach(() => {
    delete process.env[PREFIX + 'APIKEY']
    delete process.env[PREFIX + 'API_TOKEN']
  })


  test('feature absent: apikey option behaves exactly as before', async () => {
    const sdk = makeSdk(null, { apikey: 'OPTKEY01' })
    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'OPTKEY01')
    assert.equal((sdk as any)._secrets, undefined)
  })


  test('feature absent: no apikey means no authorization header', async () => {
    const sdk = makeSdk(null, {})
    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], undefined)
  })


  test('inactive feature instance changes nothing', async () => {
    const sdk = makeSdk({ active: false, providers: [{ kind: 'env', prefix: PREFIX }] },
      { apikey: 'OPTKEY01' })
    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'OPTKEY01')
  })


  test('active: apikey option still wins over the chain', async () => {
    process.env[PREFIX + 'APIKEY'] = 'ENVKEY01'
    const sdk = makeSdk(
      { active: true, providers: [{ kind: 'env', prefix: PREFIX }] },
      { apikey: 'OPTKEY01' })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'OPTKEY01')

    // The explicit option is a real store: directed reads name it.
    const secrets: any = (sdk as any)._secrets.secrets()
    assert.equal(await secrets.getfrom('options', 'apikey'), 'OPTKEY01')
  })


  test('active: unset apikey resolves from the env provider, with prefix', async () => {
    process.env[PREFIX + 'APIKEY'] = 'ENVKEY01'
    const sdk = makeSdk(
      { active: true, providers: [{ kind: 'env', prefix: PREFIX }] },
      { auth: { prefix: 'Bearer' } })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'Bearer ENVKEY01')
    assert.equal(sdk.options().apikey, 'ENVKEY01')
  })


  test('active: an explicitly empty apikey defers to the chain', async () => {
    process.env[PREFIX + 'APIKEY'] = 'ENVKEY01'
    const sdk = makeSdk(
      { active: true, providers: [{ kind: 'env', prefix: PREFIX }] },
      { apikey: '' })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'ENVKEY01')
  })


  // How suppression actually works HERE. prepareAuth has a null-auth
  // branch, but this SDK's generated optspec always supplies
  // `auth: { prefix: '' }`, so `auth: null` is rejected by validate and
  // that branch is unreachable — it only fires for SDKs whose optspec
  // omits `auth`. With the feature active, the deliberate way to send no
  // credential is to give it nothing to find.
  test('active: auth null is rejected by this SDK optspec', () => {
    assert.throws(
      () => makeSdk({ active: true, providers: [] }, { auth: null }),
      /auth to be map/)
  })


  test('active: no providers and no apikey sends no credential', async () => {
    process.env[PREFIX + 'APIKEY'] = 'ENVKEY01'
    const sdk = makeSdk({ active: true, providers: [] })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], undefined)
  })


  test('active: custom provider objects are accepted verbatim', async () => {
    const asked: string[] = []
    const sdk = makeSdk({
      active: true,
      providers: [{
        lookup(name: string) { asked.push(name); return 'CUSTOM01' },
        describe() { return 'custom:test' },
      }],
    })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'CUSTOM01')
    assert.deepEqual(asked, ['apikey'])
  })


  test('active: a miss everywhere leaves the header off', async () => {
    const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] })
    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], undefined)
    assert.equal(sdk.options().apikey, '')
  })


  // The direct path must keep its contract: a value, never a throw.
  test('active: a provider ERROR fails direct() as a value, not a throw', async () => {
    const sdk = makeSdk({
      active: true,
      providers: [{
        lookup(_name: string): string { throw new Error('vault unreachable') },
        describe() { return 'broken:test' },
      }],
    })

    const res: any = await sdk.direct({ path: '/api/planet' })
    assert.equal(res.ok, false)
    assert.match(String(res.err), /vault unreachable/)
  })


  test('active: secret name is configurable', async () => {
    process.env[PREFIX + 'API_TOKEN'] = 'TOKKEY01'
    const sdk = makeSdk({
      active: true,
      name: 'api.token',
      providers: [{ kind: 'env', prefix: PREFIX }],
    })

    const { fetchdef } = await preparedVia(sdk)
    assert.equal(fetchdef.headers['authorization'], 'TOKKEY01')
  })


  test('active: sekreto is live for arbitrary secrets and redaction', async () => {
    const sdk = makeSdk({
      active: true,
      providers: [{ kind: 'memory', values: { DB_PASSWORD: 'dbpass01' } }],
    })

    const secrets: any = (sdk as any)._secrets.secrets()
    assert.equal(await secrets.get('db.password'), 'dbpass01')
    assert.equal(
      secrets.redact('the password is dbpass01, keep it safe'),
      'the password is [redacted], keep it safe')
  })


  // Entity ops resolve at PreSpec, before the spec (and so the header) is
  // built — earlier than the transport wrap, which is why both exist.
  test('active: entity ops resolve via the PreSpec hook', async () => {
    process.env[PREFIX + 'APIKEY'] = 'ENVKEY02'

    const entityDataFile = Path.resolve(__dirname,
      '../../.sdk/test/entity/moon/MoonTestData.json')
    const entityData = JSON.parse(
      Fs.readFileSync(entityDataFile).toString('utf8'))

    const sdk = makeSdk(
      { active: true, providers: [{ kind: 'env', prefix: PREFIX }] },
      { entity: entityData.existing })

    assert.equal(sdk.options().apikey, '')

    const moons = await sdk.Moon().list()
    assert.ok(Array.isArray(moons))

    assert.equal(sdk.options().apikey, 'ENVKEY02')
  })

})
