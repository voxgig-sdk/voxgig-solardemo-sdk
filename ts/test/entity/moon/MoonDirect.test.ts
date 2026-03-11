
import { test, describe } from 'node:test'
import assert from 'node:assert'


import { SolardemoSDK } from '../../..'


describe('MoonDirect', async () => {

  test('direct-exists', async () => {
    const sdk = new SolardemoSDK({
      system: { fetch: async () => ({}) }
    })
    assert('function' === typeof sdk.direct)
    assert('function' === typeof sdk.prepare)
  })


  test('direct-load-moon', async () => {
    const setup = directSetup({ id: 'direct01' })
    const { client, calls } = setup

    const result: any = await client.direct({
      path: 'api/planet/{planet_id}/moon/{id}',
      method: 'GET',
      params: { id: 'direct01', planet_id: 'direct02' },
    })

    assert(result.ok === true)
    assert(result.status === 200)
    assert(null != result.data)
    assert(result.data.id === 'direct01')

    assert(calls.length === 1)
    assert(calls[0].init.method === 'GET')
    assert(calls[0].url.includes('direct01'))
    assert(calls[0].url.includes('direct02'))
  })

  test('direct-list-moon', async () => {
    const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }])
    const { client, calls } = setup

    const result: any = await client.direct({
      path: 'api/planet/{planet_id}/moon',
      method: 'GET',
      params: { planet_id: 'direct01' },
    })

    assert(result.ok === true)
    assert(result.status === 200)
    assert(Array.isArray(result.data))
    assert(result.data.length === 2)

    assert(calls.length === 1)
    assert(calls[0].init.method === 'GET')
    assert(calls[0].url.includes('direct01'))
  })

})



function directSetup(mockres?: any) {
  const calls: any[] = []

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

  return { client, calls }
}
  
