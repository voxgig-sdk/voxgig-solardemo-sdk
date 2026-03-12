"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const node_test_1 = require("node:test");
const node_assert_1 = require("node:assert");
const runner_1 = require("../runner");
const index_1 = require("./index");
(0, node_test_1.describe)('PrimaryUtility', async () => {
    let spec;
    let runset;
    let runsetflags;
    let client;
    let utility;
    let struct;
    // Ensure ctx has options derived from client when needed.
    function fixctx(ctx) {
        if (ctx && ctx.client && null == ctx.options) {
            ctx.options = ctx.client.options();
        }
    }
    (0, node_test_1.before)(async () => {
        const runner = await (0, runner_1.makeRunner)(index_1.TEST_JSON_FILE, await index_1.SDK.test());
        const run = await runner('primary');
        spec = run.spec;
        runset = run.runset;
        runsetflags = run.runsetflags;
        client = run.client;
        utility = client.utility();
        struct = utility.struct;
    });
    (0, node_test_1.test)('exists', () => {
        const fns = [
            'clean', 'done', 'makeError', 'featureAdd', 'featureHook', 'featureInit',
            'fetcher', 'makeFetchDef', 'makeContext', 'makeOptions', 'makeRequest',
            'makeResponse', 'makeResult', 'makeTarget', 'makeSpec', 'makeUrl',
            'param', 'prepareAuth', 'prepareBody', 'prepareHeaders', 'prepareMethod',
            'prepareParams', 'preparePath', 'prepareQuery', 'resultBasic',
            'resultBody', 'resultHeaders', 'transformRequest', 'transformResponse',
        ];
        for (const fn of fns) {
            (0, node_assert_1.equal)('function', typeof utility[fn], fn + ' should be a function');
        }
    });
    (0, node_test_1.test)('clean-basic', async () => {
        const ctx = makeFullCtx();
        const val = { key: 'secret123', name: 'test' };
        const cleaned = utility.clean(ctx, val);
        (0, node_assert_1.ok)(null != cleaned);
    });
    (0, node_test_1.test)('done-basic', async () => {
        await runset(spec.done.basic, (ctx) => {
            fixctx(ctx);
            return utility.done(ctx);
        });
    });
    (0, node_test_1.test)('makeError-basic', async () => {
        await runset(spec.makeError.basic, (...args) => {
            const ctx = args[0];
            fixctx(ctx);
            return utility.makeError(...args);
        });
    });
    (0, node_test_1.test)('makeError-no-throw', () => {
        const ctx = makeFullCtx();
        ctx.ctrl.throw = false;
        ctx.result = { ok: false, resdata: { id: 'safe01' } };
        const out = utility.makeError(ctx, ctx.error('test_code', 'test message'));
        (0, node_assert_1.deepStrictEqual)(out, { id: 'safe01' });
    });
    (0, node_test_1.test)('featureAdd-basic', () => {
        const ctx = makeCtx();
        const startLen = client._features.length;
        const feature = {
            version: '0.0.1',
            name: 'testfeat',
            active: true,
            init: () => { },
        };
        utility.featureAdd(ctx, feature);
        (0, node_assert_1.equal)(client._features.length, startLen + 1);
        (0, node_assert_1.equal)(client._features[client._features.length - 1].name, 'testfeat');
    });
    (0, node_test_1.test)('featureHook-basic', () => {
        const ctx = makeCtx();
        let called = false;
        client._features = [{
                name: 'hookfeat',
                TestHook: () => { called = true; },
            }];
        utility.featureHook(ctx, 'TestHook');
        (0, node_assert_1.equal)(called, true);
    });
    (0, node_test_1.test)('featureInit-basic', () => {
        const ctx = makeCtx();
        let initCalled = false;
        const feature = {
            name: 'initfeat',
            active: true,
            init: () => { initCalled = true; },
        };
        ctx.options.feature.initfeat = { active: true };
        utility.featureInit(ctx, feature);
        (0, node_assert_1.equal)(initCalled, true);
    });
    (0, node_test_1.test)('featureInit-inactive', () => {
        const ctx = makeCtx();
        let initCalled = false;
        const feature = {
            name: 'nofeat',
            active: false,
            init: () => { initCalled = true; },
        };
        ctx.options.feature.nofeat = { active: false };
        utility.featureInit(ctx, feature);
        (0, node_assert_1.equal)(initCalled, false);
    });
    (0, node_test_1.test)('fetcher-live', async () => {
        const calls = [];
        const liveClient = new index_1.SDK({
            system: {
                fetch: async (url, init) => {
                    calls.push({ url, init });
                    return { status: 200, statusText: 'OK' };
                }
            }
        });
        const liveUtility = liveClient.utility();
        const ctx = liveUtility.makeContext({
            opname: 'load',
            client: liveClient,
            utility: liveUtility,
        }, liveClient._rootctx);
        const fetchdef = { method: 'GET', headers: {} };
        const response = await liveUtility.fetcher(ctx, 'http://example.com/test', fetchdef);
        (0, node_assert_1.ok)(!(response instanceof Error));
        (0, node_assert_1.equal)(calls.length, 1);
        (0, node_assert_1.equal)(calls[0].url, 'http://example.com/test');
    });
    (0, node_test_1.test)('fetcher-blocked-test-mode', async () => {
        const blockedClient = new index_1.SDK({
            system: { fetch: async () => ({}) }
        });
        blockedClient._mode = 'test';
        const blockedUtility = blockedClient.utility();
        const ctx = blockedUtility.makeContext({
            opname: 'load',
            client: blockedClient,
            utility: blockedUtility,
        }, blockedClient._rootctx);
        const fetchdef = { method: 'GET', headers: {} };
        const result = await blockedUtility.fetcher(ctx, 'http://example.com/test', fetchdef);
        (0, node_assert_1.ok)(result instanceof Error);
        (0, node_assert_1.ok)(result.message.includes('blocked'));
    });
    (0, node_test_1.test)('makeContext-basic', async () => {
        await runset(spec.makeContext.basic, utility.makeContext);
    });
    (0, node_test_1.test)('makeFetchDef-basic', () => {
        const ctx = makeFullCtx();
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
        };
        const fetchdef = utility.makeFetchDef(ctx);
        (0, node_assert_1.ok)(!(fetchdef instanceof Error), 'should not be error');
        (0, node_assert_1.equal)(fetchdef.method, 'GET');
        (0, node_assert_1.ok)(fetchdef.url.includes('/api/items/item01'));
        (0, node_assert_1.equal)(fetchdef.headers['content-type'], 'application/json');
        (0, node_assert_1.ok)(null == fetchdef.body);
    });
    (0, node_test_1.test)('makeFetchDef-with-body', () => {
        const ctx = makeFullCtx();
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
        };
        const fetchdef = utility.makeFetchDef(ctx);
        (0, node_assert_1.ok)(!(fetchdef instanceof Error));
        (0, node_assert_1.equal)(fetchdef.method, 'POST');
        (0, node_assert_1.deepStrictEqual)(JSON.parse(fetchdef.body), { name: 'test' });
    });
    (0, node_test_1.test)('makeOptions-basic', async () => {
        await runset(spec.makeOptions.basic, (vin) => {
            const ctx = utility.makeContext({ options: vin.options, config: vin.config });
            ctx.client = client;
            ctx.utility = utility;
            return utility.makeOptions(ctx);
        });
    });
    (0, node_test_1.test)('makeRequest-basic', async () => {
        const mockFetch = async (url, init) => ({
            status: 200,
            statusText: 'OK',
            headers: { forEach: (cb) => { cb('application/json', 'content-type', {}); } },
            json: async () => ({ id: 'res01' }),
            body: 'present',
        });
        const reqClient = new index_1.SDK({
            system: { fetch: mockFetch }
        });
        await runset(spec.makeRequest.basic, async (ctx) => {
            ctx.client = reqClient;
            ctx.utility = reqClient._utility || utility;
            ctx.options = reqClient.options();
            return utility.makeRequest(ctx);
        });
    });
    (0, node_test_1.test)('makeResponse-basic', async () => {
        await runset(spec.makeResponse.basic, async (ctx) => {
            fixctx(ctx);
            // Add json() and forEach to response for proper TS handling
            if (ctx.response && !ctx.response.json) {
                const body = ctx.response.body;
                ctx.response.json = async () => body;
            }
            if (ctx.response?.headers && !ctx.response.headers.forEach) {
                const h = ctx.response.headers;
                ctx.response.headers = {
                    forEach: (cb) => Object.entries(h).forEach(([k, v]) => cb(v, k.toLowerCase()))
                };
            }
            return utility.makeResponse(ctx);
        });
    });
    (0, node_test_1.test)('makeResult-basic', () => {
        const ctx = makeFullCtx();
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
        };
        ctx.result = { ok: true, status: 200, statusText: 'OK', headers: {},
            resdata: { id: 'item01', name: 'Test' } };
        const result = utility.makeResult(ctx);
        (0, node_assert_1.ok)(!(result instanceof Error));
        (0, node_assert_1.equal)(result.status, 200);
    });
    (0, node_test_1.test)('makeResult-no-spec', () => {
        const ctx = makeFullCtx();
        ctx.spec = undefined;
        ctx.result = { ok: true, status: 200, statusText: 'OK', headers: {} };
        const result = utility.makeResult(ctx);
        (0, node_assert_1.ok)(result instanceof Error);
    });
    (0, node_test_1.test)('makeResult-no-result', () => {
        const ctx = makeFullCtx();
        ctx.spec = { step: 'start' };
        ctx.result = undefined;
        const result = utility.makeResult(ctx);
        (0, node_assert_1.ok)(result instanceof Error);
    });
    (0, node_test_1.test)('makeSpec-basic', async () => {
        const sdkopts = spec.makeSpec?.DEF?.setup?.a || {};
        const specClient = index_1.SDK.test({}, sdkopts);
        await runset(spec.makeSpec.basic, (ctx) => {
            ctx.client = specClient;
            ctx.options = specClient.options();
            return utility.makeSpec(ctx);
        });
    });
    (0, node_test_1.test)('makeTarget-basic', () => {
        const ctx = makeCtx();
        const target = {
            parts: ['items', '{id}'],
            args: { params: [] },
            params: [],
            alias: {},
            select: {},
            active: true,
            transform: { req: undefined, res: undefined },
        };
        ctx.op.targets = [target];
        const result = utility.makeTarget(ctx);
        (0, node_assert_1.ok)(!(result instanceof Error));
        (0, node_assert_1.equal)(ctx.target, target);
    });
    (0, node_test_1.test)('makeUrl-basic', async () => {
        await runset(spec.makeUrl.basic, utility.makeUrl);
    });
    (0, node_test_1.test)('operator-basic', async () => {
        await runset(spec.operator.basic, (opmap) => ({
            entity: opmap.entity || '_',
            name: opmap.name || '_',
            input: opmap.input || '_',
            targets: opmap.targets || [],
        }));
    });
    (0, node_test_1.test)('param-basic', async () => {
        await runset(spec.param.basic, utility.param);
    });
    (0, node_test_1.test)('prepareAuth-basic', async () => {
        const sdkopts = spec.prepareAuth?.DEF?.setup?.a || {};
        const authClient = index_1.SDK.test({}, sdkopts);
        await runset(spec.prepareAuth.basic, (ctx) => {
            ctx.client = authClient;
            fixctx(ctx);
            return utility.prepareAuth(ctx);
        });
    });
    (0, node_test_1.test)('prepareBody-basic', async () => {
        await runset(spec.prepareBody.basic, (ctx) => {
            fixctx(ctx);
            return utility.prepareBody(ctx);
        });
    });
    (0, node_test_1.test)('prepareHeaders-basic', async () => {
        await runset(spec.prepareHeaders.basic, utility.prepareHeaders);
    });
    (0, node_test_1.test)('prepareMethod-basic', async () => {
        await runset(spec.prepareMethod.basic, utility.prepareMethod);
    });
    (0, node_test_1.test)('prepareParams-basic', async () => {
        await runset(spec.prepareParams.basic, utility.prepareParams);
    });
    (0, node_test_1.test)('preparePath-basic', () => {
        const ctx = makeFullCtx();
        ctx.target = {
            parts: ['api', 'planet', '{id}'],
            args: { params: [] },
            params: [],
            alias: {},
            select: {},
            active: true,
            transform: { req: undefined, res: undefined },
        };
        const path = utility.preparePath(ctx);
        (0, node_assert_1.equal)(path, 'api/planet/{id}');
    });
    (0, node_test_1.test)('preparePath-single', () => {
        const ctx = makeFullCtx();
        ctx.target = {
            parts: ['items'],
            args: { params: [] },
            params: [],
            alias: {},
            select: {},
            active: true,
            transform: { req: undefined, res: undefined },
        };
        const path = utility.preparePath(ctx);
        (0, node_assert_1.equal)(path, 'items');
    });
    (0, node_test_1.test)('prepareQuery-basic', async () => {
        await runset(spec.prepareQuery.basic, utility.prepareQuery);
    });
    (0, node_test_1.test)('resultBasic-basic', async () => {
        await runset(spec.resultBasic.basic, (ctx) => {
            fixctx(ctx);
            const result = utility.resultBasic(ctx);
            // Break circular reference: SolardemoError stores ctx which stores result
            if (result?.err?.ctx) {
                delete result.err.ctx;
            }
            return result;
        });
    });
    (0, node_test_1.test)('resultBody-basic', async () => {
        await runset(spec.resultBody.basic, async (ctx) => {
            if (ctx.response && !ctx.response.json) {
                const body = ctx.response.body;
                ctx.response.json = async () => body;
            }
            return utility.resultBody(ctx);
        });
    });
    (0, node_test_1.test)('resultHeaders-basic', async () => {
        await runset(spec.resultHeaders.basic, (ctx) => {
            // Convert plain headers map to forEach-based (browser Response API)
            if (ctx.response?.headers && !ctx.response.headers.forEach) {
                const h = ctx.response.headers;
                ctx.response.headers = {
                    forEach: (cb) => Object.entries(h).forEach(([k, v]) => cb(v, k.toLowerCase()))
                };
            }
            return utility.resultHeaders(ctx);
        });
    });
    (0, node_test_1.test)('transformRequest-basic', async () => {
        await runset(spec.transformRequest.basic, utility.transformRequest);
    });
    (0, node_test_1.test)('transformResponse-basic', async () => {
        await runset(spec.transformResponse.basic, utility.transformResponse);
    });
    // Helper functions for manual tests
    function makeCtx(overrides) {
        return utility.makeContext({
            opname: 'load',
            ...overrides,
        }, client._rootctx);
    }
    function makeFullCtx(overrides) {
        const ctx = makeCtx(overrides);
        ctx.target = {
            parts: ['items', '{id}'],
            args: { params: [{ name: 'id', reqd: true }] },
            params: ['id'],
            alias: {},
            select: {},
            active: true,
            relations: [],
            transform: { req: undefined, res: undefined },
        };
        ctx.match = { id: 'item01' };
        ctx.reqmatch = { id: 'item01' };
        return ctx;
    }
});
//# sourceMappingURL=PrimaryUtility.test.js.map