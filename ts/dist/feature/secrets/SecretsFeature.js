"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SecretsFeature = void 0;
const BaseFeature_1 = require("../base/BaseFeature");
const sekreto_1 = require("../../utility/sekreto");
// Secret access via a vendored @voxgig/sekreto provider chain.
//
// The SDK's `apikey` option keeps exactly its old meaning: an explicit
// credential given in code. This feature makes it ONE SOURCE among several
// rather than the only one: when active, the apikey is resolved through a
// sekreto chain in which the explicit option (when set) is the FIRST
// provider — a `memory` store named `options` — so an explicit value always
// wins, by sekreto's own first-hit rule rather than by special-case logic.
// When the option is unset, the remaining providers (env, dotenv, a vault)
// are asked in order, and moving a credential from code to a vault becomes
// a configuration change.
//
// Resolution is ASYNC (providers may do IO), but the auth header is built
// by the synchronous prepareAuth inside makeSpec. The bridge is the
// feature hook pipeline: every entity op awaits featureHook('PreSpec')
// before calling makeSpec, so the PreSpec hook below resolves the secret
// once and writes it into the live options where prepareAuth already
// looks. prepareAuth itself is untouched. SolardemoSDK.prepare() bypasses
// feature hooks entirely, so it awaits client._secrets.resolve() itself.
class SecretsFeature extends BaseFeature_1.BaseFeature {
    version = '0.1.0';
    name = 'secrets';
    _client;
    _sekreto;
    _secretname = 'apikey';
    _resolving;
    // Sync by contract (the constructor cannot await): build the chain only,
    // never look anything up here.
    init(ctx, fopts) {
        const client = ctx.client;
        const options = ctx.options;
        this._client = client;
        this._secretname = 'string' === typeof fopts.name &&
            '' !== fopts.name ? fopts.name : 'apikey';
        const providers = [];
        // The explicit option, when set, is the first store in the chain.
        const apikey = options.apikey;
        if ('string' === typeof apikey && '' !== apikey) {
            providers.push({
                kind: 'memory',
                name: 'options',
                values: { [(0, sekreto_1.envkey)(this._secretname)]: apikey },
            });
        }
        for (const p of (fopts.providers || [])) {
            providers.push(p);
        }
        this._sekreto = new sekreto_1.Sekreto({
            providers,
            cache: false !== fopts.cache,
        });
        // Seam for SolardemoSDK.prepare() (no feature hooks on that path) and
        // for the public secrets() accessor.
        client._secrets = this;
    }
    PreSpec(_ctx) {
        return this.resolve();
    }
    // Resolve the apikey once, before the first request. Concurrent ops share
    // the same in-flight promise. A provider ERROR (unreachable vault, bad
    // creds) rejects and fails the op — sekreto's miss-vs-error rule: never
    // fall through to an unauthenticated request because a store was broken.
    resolve() {
        if (null == this._resolving) {
            this._resolving = this._resolveonce();
        }
        return this._resolving;
    }
    async _resolveonce() {
        if (null == this._sekreto) {
            return;
        }
        const found = await this._sekreto.try(this._secretname);
        if (undefined !== found) {
            // The same live-mutation seam TestFeature uses for the transport:
            // prepareAuth reads client.options() (a clone of _options), so the
            // resolved value lands where the sync auth path already looks.
            this._client._options.apikey = found;
        }
    }
}
exports.SecretsFeature = SecretsFeature;
//# sourceMappingURL=SecretsFeature.js.map