
const envlocal = __dirname + '/../../../.env.local'
require('dotenv').config({ quiet: true, path: [envlocal] })

const { test, describe, afterEach } = require('node:test')
const assert = require('node:assert')


const { SolardemoSDK } = require('../../..')

const {
  envOverride,
  liveClientOptions,
  liveDelay,
} = require('../../utility')


describe('MoonDirect', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('SOLARDEMO_TEST_LIVE'))

  test('direct-exists', async () => {
    const sdk = new SolardemoSDK({
      // Concrete base: a live construction must satisfy any server
      // variables a templated base URL declares; overriding base with a
      // literal (as the direct flow tests do) sidesteps the requirement.
      base: 'http://localhost:8080',
      system: { fetch: async () => ({}) }
    })
    assert('function' === typeof sdk.direct)
    assert('function' === typeof sdk.prepare)
  })


  test('direct-load-moon', async () => {
    const setup = directSetup({ id: 'direct01' })
    const { client, calls } = setup

    const params = {}
    if (setup.live) {
      const listResult = await client.direct({
        path: 'api/planet/{planet_id}/moon',
        method: 'GET',
        params: {
        planet_id: setup.idmap['planet01'],
        },
      })
      assert(listResult.ok === true)
      const listData = listResult.data
      if (!Array.isArray(listData) || listData.length === 0) {
        return // skip: no entities to load in live mode
      }
      params.id = listData[0].id
      params.planet_id = setup.idmap['planet01']
    } else {
      params.id = 'direct01'
      params.planet_id = 'direct02'
    }

    const result = await client.direct({
      path: 'api/planet/{planet_id}/moon/{id}',
      method: 'GET',
      params,
    })

    assert(result.ok === true)
    assert(result.status === 200)
    assert(null != result.data)

    if (!setup.live) {
      assert(result.data.id === 'direct01')
      assert(calls.length === 1)
      assert(calls[0].init.method === 'GET')
      assert(calls[0].url.includes('direct01'))
      assert(calls[0].url.includes('direct02'))
    }
  })

  test('direct-list-moon', async () => {
    const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }])
    const { client, calls } = setup

    const params = {}
    if (setup.live) {
      params.planet_id = setup.idmap['planet01']
    } else {
      params.planet_id = 'direct01'
    }

    const result = await client.direct({
      path: 'api/planet/{planet_id}/moon',
      method: 'GET',
      params,
    })

    assert(result.ok === true)
    assert(result.status === 200)
    assert(Array.isArray(result.data))

    if (!setup.live) {
      assert(result.data.length === 2)
      assert(calls.length === 1)
      assert(calls[0].init.method === 'GET')
      assert(calls[0].url.includes('direct01'))
    }
  })

})



function directSetup(mockres) {
  const calls = []

  const env = envOverride({
    'SOLARDEMO_TEST_MOON_ENTID': {},
    'SOLARDEMO_TEST_LIVE': 'FALSE',
  })

  const live = 'TRUE' === env.SOLARDEMO_TEST_LIVE

  if (live) {
    // Merged so the generated fields win: sdk-test-control.json's
    // test.client.options adds to the live client, it does not redirect it.
    const client = new SolardemoSDK(
      Object.assign({}, liveClientOptions(), {
      }))

    let idmap = env['SOLARDEMO_TEST_MOON_ENTID']
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

  const client = new SolardemoSDK({
    base: 'http://localhost:8080',
    system: { fetch: mockFetch },
  })

  return { client, calls, live, idmap: {} }
}
  
