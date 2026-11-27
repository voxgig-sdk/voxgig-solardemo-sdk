
const envlocal = __dirname + '/../../../../.env.local'
require('../../utility').loadEnvLocal(envlocal)

const { test, describe, afterEach } = require('node:test')
const assert = require('node:assert')


const { VoxgigSolardemoSDK } = require('../../..')

const {
  envOverride,
  liveClientOptions,
  liveDelay,
  skipIfMissingIds,
  liveMiss,
  liveEmpty,
  describeLive,
} = require('../../utility')


describe('MoonDirect', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when VOXGIG_SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('VOXGIG_SOLARDEMO_TEST_LIVE'))

  test('direct-exists', async () => {
    const sdk = new VoxgigSolardemoSDK({
      // Concrete base: a live construction must satisfy any server
      // variables a templated base URL declares; overriding base with a
      // literal (as the direct flow tests do) sidesteps the requirement.
      base: 'http://localhost:8080',
      system: { fetch: async () => ({}) }
    })
    assert('function' === typeof sdk.direct)
    assert('function' === typeof sdk.prepare)
  })


  test('direct-load-moon', async (t) => {
    if (liveScenariosActive()) { t.skip('Covered by live operation scenarios'); return }
    const setup = directSetup({ id: 'direct01' })
    if (skipIfMissingIds(t, setup, ["planet01"], LIVE_STRICT)) return
    const { client, calls } = setup

    const params = {}
    const query = {}
    if (setup.live) {
      const listResult = await client.direct({
        path: 'api/planet/{planet_id}/moon',
        method: 'GET',
        params: {
        planet_id: setup.idmap['planet01'],
        },
      })
      if (!listResult.ok || listResult.status < 200 || listResult.status >= 300) {
        return void liveMiss(t, LIVE_STRICT, 'Live list discovery failed: ' + describeLive(listResult))
      }
      if (!Array.isArray(listResult.data)) {
        return void liveMiss(t, LIVE_STRICT, 'Live list discovery returned no list: ' + describeLive(listResult))
      }
      if (0 === listResult.data.length) {
        return void liveEmpty(t, 'The account has no moon record to load')
      }
      const candidateId = listResult.data[0]?.id
      if (null == candidateId) {
        return void liveMiss(t, LIVE_STRICT, 'Live load blocked: discovery returned no usable identity')
      }
      params.id = candidateId
      params.planet_id = setup.idmap['planet01']
    } else {
      params.id = 'direct01'
      params.planet_id = 'direct02'
    }

    const result = await client.direct({
      path: 'api/planet/{planet_id}/moon/{id}',
      method: 'GET',
      params,
      query,
    })

    if (setup.live) {
      if (!result.ok || result.status < 200 || result.status >= 300) {
        return void liveMiss(t, LIVE_STRICT, 'Live load failed: ' + describeLive(result))
      }
      if (!(null != result.data)) {
        return void liveMiss(t, LIVE_STRICT, 'Live load returned no data: ' + describeLive(result))
      }
    } else {
      assert(result.ok === true)
      assert(result.status === 200)
      assert(null != result.data)
      assert(result.data.id === 'direct01')
      assert(calls.length === 1)
      assert(calls[0].init.method === 'GET')
      assert(calls[0].url.includes('direct01'))
      assert(calls[0].url.includes('direct02'))
    }
  })

  test('direct-list-moon', async (t) => {
    if (liveScenariosActive()) { t.skip('Covered by live operation scenarios'); return }
    const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }])
    if (skipIfMissingIds(t, setup, ["planet01"], LIVE_STRICT)) return
    const { client, calls } = setup

    const params = {}
    const query = {}
    if (setup.live) {
      params.planet_id = setup.idmap['planet01']
    } else {
      params.planet_id = 'direct01'
    }

    const result = await client.direct({
      path: 'api/planet/{planet_id}/moon',
      method: 'GET',
      params,
      query,
    })

    if (setup.live) {
      if (!result.ok || result.status < 200 || result.status >= 300) {
        return void liveMiss(t, LIVE_STRICT, 'Live list failed: ' + describeLive(result))
      }
      if (!(Array.isArray(result.data))) {
        return void liveMiss(t, LIVE_STRICT, 'Live list returned no list: ' + describeLive(result))
      }
    } else {
      assert(result.ok === true)
      assert(result.status === 200)
      assert(Array.isArray(result.data))
      assert(result.data.length === 2)
      assert(calls.length === 1)
      assert(calls[0].init.method === 'GET')
      assert(calls[0].url.includes('direct01'))
    }
  })

})



// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const LIVE_STRICT = true

function liveScenariosActive() { return false && process.env.VOXGIG_SOLARDEMO_TEST_LIVE === 'TRUE' }
function directSetup(mockres) {
  const calls = []

  const env = envOverride({
    'VOXGIG_SOLARDEMO_TEST_MOON_ENTID': {},
    'VOXGIG_SOLARDEMO_TEST_LIVE': 'FALSE',
  })

  const live = 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_LIVE

  if (live) {
    // Merged so the generated fields win: sdk-test-control.json's
    // test.client.options adds to the live client, it does not redirect it.
    const client = new VoxgigSolardemoSDK(
      Object.assign({}, liveClientOptions(), {
      }))

    let idmap = env['VOXGIG_SOLARDEMO_TEST_MOON_ENTID']
    if ('string' === typeof idmap && idmap.startsWith('{')) {
      idmap = JSON.parse(idmap)
    }

    return { client, calls, live, idmap }
  }

  const mockFetch = async (url, init) => {
    calls.push({ url, init })
    return {
      status: 200,
      statusText: 'OK',
      headers: {},
      json: async () => (null != mockres ? mockres : { id: 'direct01' }),
    }
  }

  const client = new VoxgigSolardemoSDK({
    base: 'http://localhost:8080',
    system: { fetch: mockFetch },
  })

  return { client, calls, live, idmap: {} }
}
  
