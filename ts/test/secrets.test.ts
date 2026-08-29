// Behavioural tests for the secrets feature (vendored @voxgig/sekreto).
//
// The contract under test: the `apikey` OPTION keeps its exact old meaning
// and always wins, because SecretsFeature places it FIRST in the provider
// chain (a `memory` store named `options`) — explicit-beats-lookup falls
// out of sekreto's first-hit rule. With the feature inactive, nothing
// changes at all. With it active and the option unset, the chain (env,
// dotenv, a custom provider, a vault) supplies the credential instead.

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe, beforeEach } from 'node:test'
import assert from 'node:assert'

import { SolardemoSDK } from '..'


// prepare() returns the fetchdef the transport would receive — the closest
// observable point to the wire for header assertions, and it awaits secrets
// resolution itself (it bypasses the feature hook pipeline).
async function prepared(sdkopts: any): Promise<any> {
  const sdk = SolardemoSDK.test({}, sdkopts)
  const fetchdef = await sdk.prepare({ path: '/planet' })
  assert.ok(!(fetchdef instanceof Error), String(fetchdef))
  return { sdk, fetchdef }
}


describe('secrets', () => {

  beforeEach(() => {
    delete process.env.SOLARDEMO_TEST_SECRETS_APIKEY
  })


  test('inactive: apikey option behaves exactly as before', async () => {
    const { sdk, fetchdef } = await prepared({ apikey: 'OPTKEY01' })
    assert.equal(fetchdef.headers['authorization'], 'OPTKEY01')
    assert.equal(sdk.secrets(), undefined)
  })


  test('inactive: no apikey means no authorization header', async () => {
    const { fetchdef } = await prepared({})
    assert.equal(fetchdef.headers['authorization'], undefined)
  })


  test('active: apikey option still wins over the chain', async () => {
    process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY01'
    const { sdk, fetchdef } = await prepared({
      apikey: 'OPTKEY01',
      feature: {
        secrets: {
          active: true,
          providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
        },
      },
    })
    assert.equal(fetchdef.headers['authorization'], 'OPTKEY01')

    // The explicit option is a real store: directed reads name it.
    assert.equal(await sdk.secrets().getfrom('options', 'apikey'), 'OPTKEY01')
  })


  test('active: unset apikey resolves from the env provider', async () => {
    process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY01'
    const { sdk, fetchdef } = await prepared({
      auth: { prefix: 'Bearer' },
      feature: {
        secrets: {
          active: true,
          providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
        },
      },
    })
    assert.equal(fetchdef.headers['authorization'], 'Bearer ENVKEY01')

    // The resolved value lands in the live options, where the sync
    // prepareAuth path reads it.
    assert.equal(sdk.options().apikey, 'ENVKEY01')
  })


  test('active: custom provider objects are accepted verbatim', async () => {
    const asked: string[] = []
    const { fetchdef } = await prepared({
      feature: {
        secrets: {
          active: true,
          providers: [{
            lookup(name: string) { asked.push(name); return 'CUSTOM01' },
            describe() { return 'custom:test' },
          }],
        },
      },
    })
    assert.equal(fetchdef.headers['authorization'], 'CUSTOM01')
    assert.deepEqual(asked, ['apikey'])
  })


  test('active: a miss everywhere leaves the header off', async () => {
    const { sdk, fetchdef } = await prepared({
      feature: {
        secrets: {
          active: true,
          providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
        },
      },
    })
    assert.equal(fetchdef.headers['authorization'], undefined)
    assert.equal(sdk.options().apikey, '')
  })


  test('active: a provider ERROR fails the request, never falls through', async () => {
    const sdk = SolardemoSDK.test({}, {
      feature: {
        secrets: {
          active: true,
          providers: [{
            lookup(_name: string): string { throw new Error('vault unreachable') },
            describe() { return 'broken:test' },
          }],
        },
      },
    })
    await assert.rejects(
      () => sdk.prepare({ path: '/planet' }),
      /vault unreachable/)
  })


  test('active: secret name is configurable', async () => {
    process.env.SOLARDEMO_TEST_SECRETS_API_TOKEN = 'TOKKEY01'
    try {
      const { fetchdef } = await prepared({
        feature: {
          secrets: {
            active: true,
            name: 'api.token',
            providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
          },
        },
      })
      assert.equal(fetchdef.headers['authorization'], 'TOKKEY01')
    }
    finally {
      delete process.env.SOLARDEMO_TEST_SECRETS_API_TOKEN
    }
  })


  test('active: sekreto is live for arbitrary secrets and redaction', async () => {
    const { sdk } = await prepared({
      feature: {
        secrets: {
          active: true,
          providers: [{
            kind: 'memory',
            values: { DB_PASSWORD: 'dbpass01' },
          }],
        },
      },
    })
    const secrets = sdk.secrets()
    assert.equal(await secrets.get('db.password'), 'dbpass01')
    assert.equal(
      secrets.redact('the password is dbpass01, keep it safe'),
      'the password is [redacted], keep it safe')
  })


  test('active: entity ops resolve via the PreSpec hook', async () => {
    process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY02'

    const entityDataFile = Path.resolve(__dirname,
      '../../.sdk/test/entity/moon/MoonTestData.json')
    const entityData = JSON.parse(
      Fs.readFileSync(entityDataFile).toString('utf8'))

    const sdk = SolardemoSDK.test({ entity: entityData.existing }, {
      feature: {
        secrets: {
          active: true,
          providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
        },
      },
    })

    // Before any op, nothing is resolved.
    assert.equal(sdk.options().apikey, '')

    const moons = await sdk.Moon().list()
    assert.ok(Array.isArray(moons))

    // The op's awaited featureHook('PreSpec') resolved the chain.
    assert.equal(sdk.options().apikey, 'ENVKEY02')
  })

})
