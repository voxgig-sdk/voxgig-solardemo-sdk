
import { test, describe, before } from 'node:test'
import { equal, deepStrictEqual, ok } from 'node:assert'
import assert from 'node:assert'

import {
  makeRunner,
} from '../runner'

import {
  SDK,
  TEST_JSON_FILE
} from './index'


describe('PrimaryUtility', async () => {

  let spec: any
  let runset: any
  let runsetflags: any
  let client: any
  let utility: any
  let struct: any


  // Ensure ctx has options derived from client when needed.
  function fixctx(ctx: any) {
    if (ctx && ctx.client && null == ctx.options) {
      ctx.options = ctx.client.options()
    }
  }


  before(async () => {
    const runner = await makeRunner(TEST_JSON_FILE, await SDK.test())
    const run = await runner('primary')

    spec = run.spec
    runset = run.runset
    runsetflags = run.runsetflags
    client = run.client
    utility = client.utility()
    struct = utility.struct
  })


  test('exists', () => {
    const fns = [
      'clean', 'done', 'makeError', 'featureAdd', 'featureHook', 'featureInit',
      'fetcher', 'makeFetchDef', 'makeContext', 'makeOptions', 'makeRequest',
      'makeResponse', 'makeResult', 'makeTarget', 'makeSpec', 'makeUrl',
      'param', 'prepareAuth', 'prepareBody', 'prepareHeaders', 'prepareMethod',
      'prepareParams', 'preparePath', 'prepareQuery', 'resultBasic',
      'resultBody', 'resultHeaders', 'transformRequest', 'transformResponse',
    ]

    for (const fn of fns) {
      equal('function', typeof utility[fn], fn + ' should be a function')
    }
  })


  test('clean-basic', async () => {
    const ctx = makeFullCtx()
    const val = { key: 'secret123', name: 'test' }
    const cleaned = utility.clean(ctx, val)
    ok(null != cleaned)
  })


  test('done-basic', async () => {
    await runset(spec.done.basic, (ctx: any) => {
      fixctx(ctx)
      return utility.done(ctx)
    })
  })


  test('makeError-basic', async () => {
    await runset(spec.makeError.basic, (...args: any[]) => {
      const ctx = args[0]
      fixctx(ctx)
      return utility.makeError(...args)
    })
  })


  test('makeError-no-throw', () => {
    const ctx = makeFullCtx()
    ctx.ctrl.throw = false
    ctx.result = { ok: false, resdata: { id: 'safe01' } } as any

    const out = utility.makeError(ctx, ctx.error('test_code', 'test message'))
    deepStrictEqual(out, { id: 'safe01' })
  })


  test('featureAdd-basic', () => {
    const ctx = makeCtx()
    const startLen = client._features.length

    const feature = {
      version: '0.0.1',
      name: 'testfeat',
      active: true,
      init: () => { },
    }

    utility.featureAdd(ctx, feature)
    equal(client._features.length, startLen + 1)
    equal(client._features[client._features.length - 1].name, 'testfeat')
  })


  test('featureHook-basic', () => {
    const ctx = makeCtx()

    let called = false
    client._features = [{
      name: 'hookfeat',
      TestHook: () => { called = true },
    }]

    utility.featureHook(ctx, 'TestHook')
    equal(called, true)
  })


  test('featureInit-basic', () => {
    const ctx = makeCtx()

    let initCalled = false
    const feature: any = {
      name: 'initfeat',
      active: true,
      init: () => { initCalled = true },
    }

    ctx.options.feature.initfeat = { active: true }

    utility.featureInit(ctx, feature)
    equal(initCalled, true)
  })


  test('featureInit-inactive', () => {
    const ctx = makeCtx()

    let initCalled = false
    const feature: any = {
      name: 'nofeat',
      active: false,
      init: () => { initCalled = true },
    }

    ctx.options.feature.nofeat = { active: false }

    utility.featureInit(ctx, feature)
    equal(initCalled, false)
  })


  test('fetcher-live', async () => {
    const calls: any[] = []
    const liveClient = new (SDK as any)({
      system: {
        fetch: async (url: string, init: any) => {
          calls.push({ url, init })
          return { status: 200, statusText: 'OK' }
        }
      }
    })
    const liveUtility = liveClient.utility()
    const ctx = liveUtility.makeContext({
      opname: 'load',
      client: liveClient,
      utility: liveUtility,
    }, liveClient._rootctx)

    const fetchdef = { method: 'GET', headers: {} }
    const response = await liveUtility.fetcher(ctx, 'http://example.com/test', fetchdef)
    ok(!(response instanceof Error))
    equal(calls.length, 1)
    equal(calls[0].url, 'http://example.com/test')
  })


  test('fetcher-blocked-test-mode', async () => {
    const blockedClient = new (SDK as any)({
      system: { fetch: async () => ({}) }
    })
    blockedClient._mode = 'test'

    const blockedUtility = blockedClient.utility()
    const ctx = blockedUtility.makeContext({
      opname: 'load',
      client: blockedClient,
      utility: blockedUtility,
    }, blockedClient._rootctx)
    const fetchdef = { method: 'GET', headers: {} }

    const result = await blockedUtility.fetcher(ctx, 'http://example.com/test', fetchdef)
    ok(result instanceof Error)
    ok(result.message.includes('blocked'))
  })


  test('makeContext-basic', async () => {
    await runset(spec.makeContext.basic, utility.makeContext)
  })


  test('makeFetchDef-basic', () => {
    const ctx = makeFullCtx()
    ctx.spec = {
      base: 'http://localhost:8080',
      prefix: '/api',
      path: 'items/{id}',
      suffix: '',
      params: { id: 'item01' },
      query: {},
      headers: { 'content-type': 'application/json' },
      method: 'GET',
      step: 'start',
      body: undefined,
    } as any

    const fetchdef = utility.makeFetchDef(ctx)
    ok(!(fetchdef instanceof Error), 'should not be error')
    equal(fetchdef.method, 'GET')
    ok(fetchdef.url.includes('/api/items/item01'))
    equal(fetchdef.headers['content-type'], 'application/json')
    ok(null == fetchdef.body)
  })


  test('makeFetchDef-with-body', () => {
    const ctx = makeFullCtx()
    ctx.spec = {
      base: 'http://localhost:8080',
      prefix: '',
      path: 'items',
      suffix: '',
      params: {},
      query: {},
      headers: {},
      method: 'POST',
      step: 'start',
      body: { name: 'test' },
    } as any

    const fetchdef = utility.makeFetchDef(ctx)
    ok(!(fetchdef instanceof Error))
    equal(fetchdef.method, 'POST')
    deepStrictEqual(JSON.parse(fetchdef.body), { name: 'test' })
  })


  test('makeOptions-basic', async () => {
    await runset(spec.makeOptions.basic, (vin: any) => {
      const ctx = utility.makeContext({ options: vin.options, config: vin.config })
      ctx.client = client
      ctx.utility = utility
      return utility.makeOptions(ctx)
    })
  })


  test('makeRequest-basic', async () => {
    const mockFetch = async (url: string, init: any) => ({
      status: 200,
      statusText: 'OK',
      headers: { forEach: (cb: any) => { cb('application/json', 'content-type', {}) } },
      json: async () => ({ id: 'res01' }),
      body: 'present',
    })
    const reqClient = new (SDK as any)({
      system: { fetch: mockFetch }
    })
    await runset(spec.makeRequest.basic, async (ctx: any) => {
      ctx.client = reqClient
      ctx.utility = reqClient._utility || utility
      ctx.options = reqClient.options()
      return utility.makeRequest(ctx)
    })
  })


  test('makeResponse-basic', async () => {
    await runset(spec.makeResponse.basic, async (ctx: any) => {
      fixctx(ctx)
      // Add json() and forEach to response for proper TS handling
      if (ctx.response && !ctx.response.json) {
        const body = ctx.response.body
        ctx.response.json = async () => body
      }
      if (ctx.response?.headers && !ctx.response.headers.forEach) {
        const h = ctx.response.headers
        ctx.response.headers = {
          forEach: (cb: any) => Object.entries(h).forEach(([k, v]) => cb(v, k.toLowerCase()))
        }
      }
      return utility.makeResponse(ctx)
    })
  })


  test('makeResult-basic', () => {
    const ctx = makeFullCtx()
    ctx.spec = {
      base: 'http://localhost:8080',
      prefix: '/api',
      path: 'items/{id}',
      suffix: '',
      params: { id: 'item01' },
      query: {},
      headers: {},
      method: 'GET',
      step: 'start',
    } as any
    ctx.result = { ok: true, status: 200, statusText: 'OK', headers: {},
      resdata: { id: 'item01', name: 'Test' } } as any

    const result = utility.makeResult(ctx)
    ok(!(result instanceof Error))
    equal((result as any).status, 200)
  })


  test('makeResult-no-spec', () => {
    const ctx = makeFullCtx()
    ctx.spec = undefined
    ctx.result = { ok: true, status: 200, statusText: 'OK', headers: {} } as any

    const result = utility.makeResult(ctx)
    ok(result instanceof Error)
  })


  test('makeResult-no-result', () => {
    const ctx = makeFullCtx()
    ctx.spec = { step: 'start' } as any
    ctx.result = undefined

    const result = utility.makeResult(ctx)
    ok(result instanceof Error)
  })


  test('makeSpec-basic', async () => {
    const sdkopts = spec.makeSpec?.DEF?.setup?.a || {}
    const specClient = SDK.test({}, sdkopts)
    await runset(spec.makeSpec.basic, (ctx: any) => {
      ctx.client = specClient
      ctx.options = specClient.options()
      return utility.makeSpec(ctx)
    })
  })


  test('makeTarget-basic', () => {
    const ctx = makeCtx()
    const target = {
      parts: ['items', '{id}'],
      args: { params: [] },
      params: [],
      alias: {},
      select: {},
      active: true,
      transform: { req: undefined, res: undefined },
    }
    ctx.op.targets = [target]

    const result = utility.makeTarget(ctx)
    ok(!(result instanceof Error))
    equal(ctx.target, target)
  })


  test('makeUrl-basic', async () => {
    await runset(spec.makeUrl.basic, utility.makeUrl)
  })


  test('operator-basic', async () => {
    await runset(spec.operator.basic, (opmap: any) => ({
      entity: opmap.entity || '_',
      name: opmap.name || '_',
      input: opmap.input || '_',
      targets: opmap.targets || [],
    }))
  })


  test('param-basic', async () => {
    await runset(spec.param.basic, utility.param)
  })


  test('prepareAuth-basic', async () => {
    const sdkopts = spec.prepareAuth?.DEF?.setup?.a || {}
    const authClient = SDK.test({}, sdkopts)
    await runset(spec.prepareAuth.basic, (ctx: any) => {
      ctx.client = authClient
      fixctx(ctx)
      return utility.prepareAuth(ctx)
    })
  })


  test('prepareBody-basic', async () => {
    await runset(spec.prepareBody.basic, (ctx: any) => {
      fixctx(ctx)
      return utility.prepareBody(ctx)
    })
  })


  test('prepareHeaders-basic', async () => {
    await runset(spec.prepareHeaders.basic, utility.prepareHeaders)
  })


  test('prepareMethod-basic', async () => {
    await runset(spec.prepareMethod.basic, utility.prepareMethod)
  })


  test('prepareParams-basic', async () => {
    await runset(spec.prepareParams.basic, utility.prepareParams)
  })


  test('preparePath-basic', () => {
    const ctx = makeFullCtx()
    ctx.target = {
      parts: ['api', 'planet', '{id}'],
      args: { params: [] },
      params: [],
      alias: {},
      select: {},
      active: true,
      transform: { req: undefined, res: undefined },
    }

    const path = utility.preparePath(ctx)
    equal(path, 'api/planet/{id}')
  })


  test('preparePath-single', () => {
    const ctx = makeFullCtx()
    ctx.target = {
      parts: ['items'],
      args: { params: [] },
      params: [],
      alias: {},
      select: {},
      active: true,
      transform: { req: undefined, res: undefined },
    }

    const path = utility.preparePath(ctx)
    equal(path, 'items')
  })


  test('prepareQuery-basic', async () => {
    await runset(spec.prepareQuery.basic, utility.prepareQuery)
  })


  test('resultBasic-basic', async () => {
    await runset(spec.resultBasic.basic, (ctx: any) => {
      fixctx(ctx)
      const result = utility.resultBasic(ctx)
      // Break circular reference: SolardemoError stores ctx which stores result
      if (result?.err?.ctx) {
        delete result.err.ctx
      }
      return result
    })
  })


  test('resultBody-basic', async () => {
    await runset(spec.resultBody.basic, async (ctx: any) => {
      if (ctx.response && !ctx.response.json) {
        const body = ctx.response.body
        ctx.response.json = async () => body
      }
      return utility.resultBody(ctx)
    })
  })


  test('resultHeaders-basic', async () => {
    await runset(spec.resultHeaders.basic, (ctx: any) => {
      // Convert plain headers map to forEach-based (browser Response API)
      if (ctx.response?.headers && !ctx.response.headers.forEach) {
        const h = ctx.response.headers
        ctx.response.headers = {
          forEach: (cb: any) => Object.entries(h).forEach(([k, v]) => cb(v, k.toLowerCase()))
        }
      }
      return utility.resultHeaders(ctx)
    })
  })


  test('transformRequest-basic', async () => {
    await runset(spec.transformRequest.basic, utility.transformRequest)
  })


  test('transformResponse-basic', async () => {
    await runset(spec.transformResponse.basic, utility.transformResponse)
  })


  // Helper functions for manual tests
  function makeCtx(overrides?: any) {
    return utility.makeContext({
      opname: 'load',
      ...overrides,
    }, client._rootctx)
  }


  function makeFullCtx(overrides?: any) {
    const ctx = makeCtx(overrides)
    ctx.target = {
      parts: ['items', '{id}'],
      args: { params: [{ name: 'id', reqd: true }] },
      params: ['id'],
      alias: {},
      select: {},
      active: true,
      relations: [],
      transform: { req: undefined, res: undefined },
    }
    ctx.match = { id: 'item01' }
    ctx.reqmatch = { id: 'item01' }
    return ctx
  }

})
