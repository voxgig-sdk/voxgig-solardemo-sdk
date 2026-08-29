// Credential resolution through a sekreto provider chain.
//
// PROJECT-OWNED, NOT GENERATED. Everything under `ts/src/ext/` is written
// by hand and untouched by `npm run generate` — which is what lets this
// live on main without fighting the drift gate. It reaches the SDK through
// `options.extend`, the supported seam for handing a generated client a
// feature INSTANCE at construction:
//
//   import { SolardemoSDK } from '@voxgig-sdk/solardemo'
//   import { SecretsFeature } from '@voxgig-sdk/solardemo/dist/ext/secrets'
//
//   const sdk = new SolardemoSDK({
//     feature: { secrets: { active: true, providers: [
//       { kind: 'env' },
//       { kind: 'dotenv', file: '.env' },
//     ] } },
//     extend: [ new SecretsFeature() ],
//   })
//
// WHY NOT A GENERATED FEATURE (yet). The natural home is an sdkgen feature
// template, so every language target gets it. That is blocked on sdkgen
// gaining a feature APPLICABILITY GATE: a feature is active or not for the
// whole model, so a feature with source for only some targets aborts
// generation for the rest (`Copy` stat-fails on the missing source) and
// dangles a Config import in every target that did generate. See
// voxgig/sdkgen docs/design/vendoring-upgrade-migration.md, Phase 3, and
// docs/design/feature-tags.md. When that lands, this moves into an sdkgen
// package as a feature template and this directory goes away.
//
// WHAT IT DOES. The `apikey` option keeps its exact meaning and always
// wins when set: init puts it FIRST in the chain as a `memory` store named
// `options`, so explicit-beats-lookup falls out of sekreto's own first-hit
// rule rather than special-case logic. With the option unset the
// configured providers — env, dotenv, a vault, or any object with
// `lookup`/`describe` — answer in order, so moving a credential from code
// into a vault becomes a configuration change.
//
// TWO ENTRY POINTS, ONE RULE. Resolution is async; the auth header is
// built by the SYNCHRONOUS prepareAuth. Entity ops await
// featureHook('PreSpec') before makeSpec, so the PreSpec hook resolves in
// time for the pipeline's own prepareAuth. But prepare(), direct() and
// graphql() run no hooks at all, so the transport wrap resolves there too
// and re-applies auth by calling prepareAuth itself — through a derived
// context whose spec carries the fetchdef headers, so the prefix rule
// (Bearer/Basic/raw) stays in exactly one place. Resolving inside the wrap
// also keeps direct() to its contract: the wrap runs inside _rawRequest's
// try, so a provider failure returns { ok: false, err } instead of
// throwing.
//
// MISS vs ERROR is sekreto's invariant and this preserves it: a store that
// does not hold the secret is a miss and the chain continues; a store that
// could not answer is an error that fails the operation. A broken vault
// never falls through to an unauthenticated request.

import type { Context, FeatureOptions } from '../../types'

import { BaseFeature } from '../../feature/base/BaseFeature'

import { Sekreto, envkey } from './sekreto'


class SecretsFeature extends BaseFeature {
  version = '0.1.0'
  name = 'secrets'
  active = true

  _client: any
  _options: any = {}
  _sekreto?: Sekreto
  _secretname = 'apikey'
  _resolving?: Promise<void>


  // Synchronous by feature contract (the constructor cannot await): build
  // the chain here, look nothing up.
  init(ctx: Context, options: FeatureOptions): void {
    this._client = ctx.client
    this._options = options || {}
    this.active = true === (options as any).active

    if (!this.active) {
      return
    }

    const opts: any = this._options

    this._secretname = 'string' === typeof opts.name && '' !== opts.name
      ? opts.name : 'apikey'

    const providers: any[] = []

    // The explicit option, when set, is the first store in the chain.
    // Empty means "not supplied": makeOptions normalizes an omitted apikey
    // to '' before features initialize, so the two are indistinguishable by
    // now and both defer to the chain. To send NO credential with the
    // feature active, give it nothing to find (no providers, or leave the
    // feature inactive) — note that `options.auth = null`, prepareAuth's
    // own suppression switch, is unreachable in this SDK: its generated
    // optspec always supplies `auth: { prefix: '' }`, so validate rejects
    // a null.
    const apikey = ctx.options.apikey
    if ('string' === typeof apikey && '' !== apikey) {
      providers.push({
        kind: 'memory',
        name: 'options',
        values: { [envkey(this._secretname)]: apikey },
      })
    }

    for (const provider of (opts.providers || [])) {
      providers.push(provider)
    }

    this._sekreto = new Sekreto({
      providers,
      cache: false !== opts.cache,
    })

    // Seam for the public accessor and for tests.
    this._client._secrets = this

    const self = this
    const utility = ctx.utility
    const inner = utility.fetcher

    utility.fetcher = async function (ctx2: any, url: string, fetchdef: any) {
      await self.resolve()

      // Re-apply auth with the resolved credential. A derived context whose
      // spec wraps the fetchdef headers lets prepareAuth do it by its own
      // rule; entity ops have already run it at spec time, where this is
      // simply idempotent.
      if (null != fetchdef && null != fetchdef.headers) {
        const authctx = utility.makeContext({ spec: { headers: fetchdef.headers } }, ctx2)
        utility.prepareAuth(authctx)
      }

      return inner(ctx2, url, fetchdef)
    }
  }


  PreSpec(_ctx: Context) {
    return this.active ? this.resolve() : undefined
  }


  // Resolve once; concurrent operations share the in-flight promise. A
  // provider ERROR rejects and fails the operation.
  resolve(): Promise<void> {
    if (null == this._resolving) {
      this._resolving = this._resolveonce()
    }
    return this._resolving
  }


  // The live Sekreto: arbitrary secrets (`await sdk.secrets().get('db.pass')`)
  // and redact(). Never a clone — provider state (caches, vault leases) has
  // to stay live to be useful.
  secrets(): Sekreto | undefined {
    return this._sekreto
  }


  private async _resolveonce(): Promise<void> {
    if (null == this._sekreto) {
      return
    }

    const found = await this._sekreto.try(this._secretname)

    if (undefined !== found) {
      // prepareAuth reads client.options(), a clone of _options, so the
      // resolved value has to land on the live options object.
      this._client._options.apikey = found
    }
  }
}


export {
  SecretsFeature
}
