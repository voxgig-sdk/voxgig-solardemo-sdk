
const envlocal = __dirname + '/../../../.env.local'
require('dotenv').config({ quiet: true, path: [envlocal] })

import { test, describe } from 'node:test'
import assert from 'node:assert'


import { SolardemoSDK } from '../../..'

import {
  envOverride,
} from '../../utility'


describe('PlanetDirect', async () => {

  test('direct-exists', async () => {
    const sdk = new SolardemoSDK({
      system: { fetch: async () => ({}) }
    })
    assert('function' === typeof sdk.direct)
    assert('function' === typeof sdk.prepare)
  })


  test('direct-load-planet', async () => {
    const setup = directSetup({ id: 'direct01' })
    const { client, calls } = setup

    const params: any = {}
    if (setup.live) {
      const listResult: any = await client.direct({
        path: 'api/planet',
        method: 'GET',
        params: {

        },
      })
      assert(listResult.ok === true)
      const listData = listResult.data
      if (!Array.isArray(listData) || listData.length === 0) {
        return // skip: no entities to load in live mode
      }
      params.id = listData[0].id

    } else {
      params.id = 'direct01'
    }

    const result: any = await client.direct({
      path: 'api/planet/{id}',
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
    }
  })

  test('direct-list-planet', async () => {
    const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }])
    const { client, calls } = setup

    const params: any = {}

    const result: any = await client.direct({
      path: 'api/planet',
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
    }
  })

})



function directSetup(mockres?: any) {
  const calls: any[] = []

  const env = envOverride({
    'SOLARDEMO_TEST_PLANET_ENTID': {},
    'SOLARDEMO_TEST_LIVE': 'FALSE',
    'SOLARDEMO_APIKEY': 'NONE',
  })

  const live = 'TRUE' === env.SOLARDEMO_TEST_LIVE

  if (live) {
    const client = new SolardemoSDK({
      apikey: env.SOLARDEMO_APIKEY,
    })

    let idmap: any = env['SOLARDEMO_TEST_PLANET_ENTID']
    if ('string' === typeof idmap && idmap.startsWith('{')) {
      idmap = JSON.parse(idmap)
    }

    return { client, calls, live, idmap }
  }

  const mockFetch = async (url: string, init: any) => {
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

  return { client, calls, live, idmap: {} as any }
}
  
