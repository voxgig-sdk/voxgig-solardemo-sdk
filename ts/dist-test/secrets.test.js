"use strict";
// Behavioural tests for the secrets feature (vendored @voxgig/sekreto).
//
// The contract under test: the `apikey` OPTION keeps its exact old meaning
// and always wins, because SecretsFeature places it FIRST in the provider
// chain (a `memory` store named `options`) — explicit-beats-lookup falls
// out of sekreto's first-hit rule. With the feature inactive, nothing
// changes at all. With it active and the option unset, the chain (env,
// dotenv, a custom provider, a vault) supplies the credential instead.
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_path_1 = __importDefault(require("node:path"));
const Fs = __importStar(require("node:fs"));
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const __1 = require("..");
// prepare() returns the fetchdef the transport would receive — the closest
// observable point to the wire for header assertions, and it awaits secrets
// resolution itself (it bypasses the feature hook pipeline).
async function prepared(sdkopts) {
    const sdk = __1.SolardemoSDK.test({}, sdkopts);
    const fetchdef = await sdk.prepare({ path: '/planet' });
    node_assert_1.default.ok(!(fetchdef instanceof Error), String(fetchdef));
    return { sdk, fetchdef };
}
(0, node_test_1.describe)('secrets', () => {
    (0, node_test_1.beforeEach)(() => {
        delete process.env.SOLARDEMO_TEST_SECRETS_APIKEY;
    });
    (0, node_test_1.test)('inactive: apikey option behaves exactly as before', async () => {
        const { sdk, fetchdef } = await prepared({ apikey: 'OPTKEY01' });
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'OPTKEY01');
        node_assert_1.default.equal(sdk.secrets(), undefined);
    });
    (0, node_test_1.test)('inactive: no apikey means no authorization header', async () => {
        const { fetchdef } = await prepared({});
        node_assert_1.default.equal(fetchdef.headers['authorization'], undefined);
    });
    (0, node_test_1.test)('active: apikey option still wins over the chain', async () => {
        process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY01';
        const { sdk, fetchdef } = await prepared({
            apikey: 'OPTKEY01',
            feature: {
                secrets: {
                    active: true,
                    providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
                },
            },
        });
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'OPTKEY01');
        // The explicit option is a real store: directed reads name it.
        node_assert_1.default.equal(await sdk.secrets().getfrom('options', 'apikey'), 'OPTKEY01');
    });
    (0, node_test_1.test)('active: unset apikey resolves from the env provider', async () => {
        process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY01';
        const { sdk, fetchdef } = await prepared({
            auth: { prefix: 'Bearer' },
            feature: {
                secrets: {
                    active: true,
                    providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
                },
            },
        });
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'Bearer ENVKEY01');
        // The resolved value lands in the live options, where the sync
        // prepareAuth path reads it.
        node_assert_1.default.equal(sdk.options().apikey, 'ENVKEY01');
    });
    (0, node_test_1.test)('active: custom provider objects are accepted verbatim', async () => {
        const asked = [];
        const { fetchdef } = await prepared({
            feature: {
                secrets: {
                    active: true,
                    providers: [{
                            lookup(name) { asked.push(name); return 'CUSTOM01'; },
                            describe() { return 'custom:test'; },
                        }],
                },
            },
        });
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'CUSTOM01');
        node_assert_1.default.deepEqual(asked, ['apikey']);
    });
    (0, node_test_1.test)('active: a miss everywhere leaves the header off', async () => {
        const { sdk, fetchdef } = await prepared({
            feature: {
                secrets: {
                    active: true,
                    providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
                },
            },
        });
        node_assert_1.default.equal(fetchdef.headers['authorization'], undefined);
        node_assert_1.default.equal(sdk.options().apikey, '');
    });
    (0, node_test_1.test)('active: a provider ERROR fails the request, never falls through', async () => {
        const sdk = __1.SolardemoSDK.test({}, {
            feature: {
                secrets: {
                    active: true,
                    providers: [{
                            lookup(_name) { throw new Error('vault unreachable'); },
                            describe() { return 'broken:test'; },
                        }],
                },
            },
        });
        await node_assert_1.default.rejects(() => sdk.prepare({ path: '/planet' }), /vault unreachable/);
    });
    (0, node_test_1.test)('active: secret name is configurable', async () => {
        process.env.SOLARDEMO_TEST_SECRETS_API_TOKEN = 'TOKKEY01';
        try {
            const { fetchdef } = await prepared({
                feature: {
                    secrets: {
                        active: true,
                        name: 'api.token',
                        providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
                    },
                },
            });
            node_assert_1.default.equal(fetchdef.headers['authorization'], 'TOKKEY01');
        }
        finally {
            delete process.env.SOLARDEMO_TEST_SECRETS_API_TOKEN;
        }
    });
    (0, node_test_1.test)('active: sekreto is live for arbitrary secrets and redaction', async () => {
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
        });
        const secrets = sdk.secrets();
        node_assert_1.default.equal(await secrets.get('db.password'), 'dbpass01');
        node_assert_1.default.equal(secrets.redact('the password is dbpass01, keep it safe'), 'the password is [redacted], keep it safe');
    });
    (0, node_test_1.test)('active: entity ops resolve via the PreSpec hook', async () => {
        process.env.SOLARDEMO_TEST_SECRETS_APIKEY = 'ENVKEY02';
        const entityDataFile = node_path_1.default.resolve(__dirname, '../../.sdk/test/entity/moon/MoonTestData.json');
        const entityData = JSON.parse(Fs.readFileSync(entityDataFile).toString('utf8'));
        const sdk = __1.SolardemoSDK.test({ entity: entityData.existing }, {
            feature: {
                secrets: {
                    active: true,
                    providers: [{ kind: 'env', prefix: 'SOLARDEMO_TEST_SECRETS_' }],
                },
            },
        });
        // Before any op, nothing is resolved.
        node_assert_1.default.equal(sdk.options().apikey, '');
        const moons = await sdk.Moon().list();
        node_assert_1.default.ok(Array.isArray(moons));
        // The op's awaited featureHook('PreSpec') resolved the chain.
        node_assert_1.default.equal(sdk.options().apikey, 'ENVKEY02');
    });
});
//# sourceMappingURL=secrets.test.js.map