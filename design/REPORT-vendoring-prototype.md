# REPORT: Vendoring prototype — omni, struct, sekreto (ts only)

Branch: `claude/vendor-omni-struct-sekreto-prototype`. This branch is a
PROTOTYPE: it manually refactors the generated `ts/` target to vendor the
latest [voxgig/omni](https://github.com/voxgig/omni) (0.1.2, test specs),
[voxgig/struct](https://github.com/voxgig/struct) (0.3.2, utils) and
[voxgig/sekreto](https://github.com/voxgig/sekreto) (0.1.2, secret access),
in order to surface the architecture issues and refactorings a real
sdkgen-level adoption needs. It is meant to be mined, not merged: the
`Generate and check for drift` CI job is red on this branch **by
construction** (see finding 1).

All three upstream libraries are MIT, zero-runtime-dependency by design,
and their TypeScript sources compile unchanged under this SDK's strict
CommonJS build. The `ts` suite is green throughout: 207 tests, 206 pass,
1 pre-existing skip. Zero-dep status after the prototype: no runtime
deps (unchanged), and `dotenv` — the last non-tooling devDependency —
is gone, replaced by the vendored sekreto `.env` parser.

## What the prototype builds

- `ts/src/utility/sekreto/` — @voxgig/sekreto 0.1.2 verbatim (Sekreto,
  Providers, Sigv4, trimmed barrel), re-exported publicly as `sekreto`.
- `ts/src/feature/secrets/SecretsFeature.ts` — apikey/sekreto layering
  (finding 4), configured via `options.feature.secrets`.
- `ts/test/vendor/omni/` — @voxgig/omni 0.1.2 (Util, Runner, barrel,
  compat shim) with three marked PATCH deviations (finding 2), fronted
  by a `ts/test/omni.ts` resolver; the hand-vendored `ts/test/runner.ts`
  is deleted. `ts/test/omni.test.ts` pins the runner's failure paths.
- `ts/src/utility/StructUtility.ts` — refreshed 0.0.10 → 0.3.2
  (finding 3). No call-site changes were needed.

Every vendored file carries a uniform provenance header: source repo,
commit, upstream path, license, and a do-not-edit-resync-instead notice.

## Findings

### 1. "Add is overwrite" is empirical, and it is the central constraint

Running `.sdk`'s `npm run generate` over this branch REVERTED every
manual edit to generated files — `Config.ts`, `SolardemoSDK.ts`, the
entity test files, `test/utility.ts`, `PrimaryUtility.test.ts` — and
RECREATED the deleted `test/runner.ts` from the ts target's template.
New files (the vendored trees, the secrets feature, new tests) survive,
because jostraca only writes what it generates.

Consequences:

- The drift gate is red on this branch by construction, and that is the
  gate working as designed. A manual refactor of generated output cannot
  coexist with regeneration; the sdkgen doctrine (fix the
  template/component, never the output) is enforced mechanically.
- The graduation path is therefore fixed: every change under `ts/src`
  and `ts/test` here must land as sdkgen template files
  (`ts/project/.sdk/tm/ts/`) or component changes
  (`ts/project/.sdk/src/cmp/`), after which `add-target ts` + `generate`
  reproduces this branch's content and the gate goes green.
- Vendored-library refresh IS the existing mechanism: struct 0.0.10 and
  the runner precursor arrived via exactly those templates. "Vendor
  newer versions" means "refresh the template copies", once per
  language.

### 2. Upstream omni bugs, exposed by corpus-driven live contexts

omni's own consumers (fib, sekreto) feed it pure-JSON specs. This SDK's
corpus drives LIVE `Context` objects through entries (`ctx` entries and
`match` blocks against them), and a live Context is cyclic
(`sdk._rootctx.client === sdk`). Three defects surfaced, each patched in
the vendored copy with a marked `PATCH` comment, each needing an
upstream omni fix (plus spec entries pinning them):

- `Runner.match()` clones the match base before reading it. The clone
  gains nothing (match only reads via getpath) and blows the stack on
  any cyclic base. Fix: read the base directly.
- `Util.jsonstr()` has no cycle guard, so BUILDING THE FAILURE MESSAGE
  for a ctx entry also blows the stack (the entry carries the live ctx
  as bookkeeping). Fix: `'[Circular]'` marker, as the original struct
  runner had.
- `errify()`/`errmessage()` collapse non-Error throwables to
  `String(err)` = `'[object Object]'`. The shared corpus throws
  error-shaped plain maps (this SDK's `makeError` rethrows the
  fixture's `ctrl.err` verbatim), and the original runner matched
  `err.message` regardless of class. Fix: read `.message`/spread the
  map when present.

Two compat-shim gaps, handled in `ts/test/omni.ts` rather than patched:

- The `structprovider` wrapper forwards `utility()`/`tester()` but not
  `options()`, `_features`, `_rootctx`, `_mode` — all of which corpus
  subjects and pipeline utilities reach through `ctx.client`. The
  resolver builds the provider by PROTOTYPE DELEGATION over the live
  SDK instance instead. Upstream's compat could adopt the same shape.
  One residue: delegation cannot forward ASSIGNMENT (the featureHook
  test assigns `client._features`), so `PrimaryUtility.test.ts` unwraps
  `run.client.sdk` — under the old runner `run.client` WAS the SDK.
- The compat's caller-directory spec-path heuristic resolves one level
  too deep for this layout (its own header documents this exact
  failure); the resolver absolutizes the path against its own compiled
  location.

### 3. struct 0.0.10 → 0.3.2: suite-green is not semantics-free

The swap needed zero call-site changes (0.3.2's exports are a strict
superset) and the full corpus passes on both versions — verified
empirically before swapping. But real behavior changed where the corpus
cannot see it: fixture nulls travel as `'__NULL__'` STRINGS, so
real-JSON-null semantics are untested by the corpus, and live API
traffic will see all of these:

- getprop/getelem/getpath treat a stored JSON null as "no value": the
  `alt` default now fires on null, and `Result.body`, GraphQL
  `data: null`, and null entity fields read as `undefined` where 0.0.10
  returned `null`.
- inject/transform DELETE an output key whose backtick reference
  resolves to null (0.0.10 emitted `key: null`) — visible through
  `transform.req`/`transform.res` point specs.
- validate's list-form `` ['`$CHILD`', tm] `` validates the first
  element now (0.0.10 skipped it, and corrupted output on longer
  lists). Map-form — what `makeOptions` uses — is unchanged.
- `escre` throws on non-string input instead of coercing.
- `walk`'s callback path array is pooled and mutated across visits;
  callbacks that retain it must clone it.

Needed: corpus entries that PIN the null semantics (upstream 0.3.2's
own corpus additions — condense, regex, sentinels, select.nullkey —
should also flow into `.sdk/test/`), and a decision recorded in the
model about whether SDK results normalize null vs undefined at the
`Result` boundary. Separately, the go target's vendored struct has
drifted from upstream go in BOTH directions (~672 diff lines: upstream
gained the NOVAL sentinel; the vendored copy gained net/url) and
carries no version stamp — resolve before any go parity work.

### 4. apikey × sekreto: layering by first-hit, bridging by hook

The design that survived contact:

- The `apikey` OPTION keeps its exact old meaning and always wins,
  because `SecretsFeature.init` places it FIRST in the provider chain —
  a `memory` store named `options` — followed by the configured
  providers. Explicit-beats-lookup is sekreto's own first-hit rule, not
  special-case logic, and the explicit value stays addressable
  (`getfrom('options', 'apikey')`) and redactable like any other store.
- The sync/async bridge: sekreto resolution is async (providers do IO);
  the auth header is built by the synchronous `prepareAuth` inside
  `makeSpec`. Entity ops already `await featureHook('PreSpec')` before
  `makeSpec`, so the feature resolves there — once, shared by
  concurrent ops — and writes the value into the live options where
  `prepareAuth` already looks. `prepareAuth` is untouched; behavior
  with the feature inactive is bit-identical.
- Feature `init` is called synchronously from the constructor, so init
  BUILDS the chain and never looks anything up. This is a general
  constraint worth documenting for feature authors: async work belongs
  in hooks.
- `SolardemoSDK.prepare()` bypasses the feature hook pipeline entirely
  (pre-existing: no retry/cache there either), so it awaits
  `client._secrets.resolve()` explicitly. Architecture question for
  sdkgen: should `prepare()`/`direct()`/`graphql()` run a reduced hook
  pipeline instead of accreting per-feature special cases?
- A provider ERROR fails the op; only a MISS falls through — sekreto's
  miss-vs-error invariant means a broken vault can never silently
  produce an unauthenticated request.
- The secret name defaults to `apikey` and is configurable
  (`feature.secrets.name`), for APIs whose credential is not
  apikey-shaped.

Not built, worth building: `clean()` is currently an identity function
(its redaction body is commented out), while `sdk.secrets().redact()`
tracks every resolved value even with caching off. Routing
`done()`/`makeError` output through sekreto redaction would give the
SDK real secret-hygiene for logs with ~no new code.

### 5. Registration is generated, so features need model backing

`SecretsFeature` had to be wired into generated code by hand in three
places: the `FEATURE_CLASS` registry and `config.feature` metadata in
`Config.ts`, and the `_secrets`/`secrets()` additions in
`SolardemoSDK.ts`. For graduation, sdkgen's model needs a
`feature.secrets` block (like `feature.test`) so the Feature/Config
components emit all three, and the secrets feature class + vendored
sekreto become template files per language. sekreto ships ports for the
major SDK languages (go, py, java, rb, php, rust...), so per-language
parity follows the struct precedent.

### 6. Browser-safety is now a vendoring axis

The SDK previously touched only `node:util` (inspect). Vendored sekreto
brings TOP-LEVEL imports of `node:child_process`, `node:fs`,
`node:path` (Providers.ts) and `node:crypto` (Sigv4.ts) into the
module graph the moment the SDK is imported, browser bundlers included.
`Sekreto.ts` itself is pure JS. If browser targets matter, the
template-level fix is to split providers into per-kind modules loaded
lazily by `makeprovider`, keeping env/memory (and fetch-based
providers, modulo Buffer) importable anywhere. Worth raising upstream
in sekreto rather than diverging in templates.

### 7. Corpus versioning: adopt the OMNI block deliberately

`.sdk/test/test.json` has no `OMNI` version block, so omni runs it in
lenient v0 mode — typo'd assertion fields pass silently. Upgrading to
`{"OMNI": {"version": 1}}` buys strict entry validation but requires:
renaming/dropping the non-standard `mark` field carried by 23 entries,
and `empty: true` on the six deliberately-pending sections. The corpus
is shared with go (which still runs the old runner port), so the
upgrade must move all targets together — a good forcing function for
vendoring omni's go runner at the same time.

### 8. Vendoring conventions worth standardizing

- Uniform provenance headers (source repo + commit + upstream path +
  license + resync notice) made the three trees auditable; the old
  copies had only a bare version stamp, and the go struct copy has
  none. sdkgen's `doctor` could verify stamps and warn on drift.
- Version stamps must move TOGETHER: the runner, StructUtility, and the
  struct corpus test all carried `0.0.10` stamps and all had to change
  in step. A single vendored-versions manifest per target would make
  the pairing explicit.
- Local deviations from vendored code, when unavoidable, need loud
  in-file `PATCH` markers plus an upstream issue — this branch carries
  three, all in omni (finding 2), all bugs rather than preferences.

## Graduation checklist (sdkgen work, in dependency order)

1. Upstream the three omni Runner/Util fixes (+ compat delegation);
   add omni spec entries pinning cyclic-ctx and map-shaped errors.
2. Refresh struct templates to 0.3.2 across languages; pull upstream's
   new corpus sections into the shared corpus; resolve the go vendored
   drift; add null-semantics corpus entries.
3. Replace per-target runner templates with vendored omni ports +
   per-target resolver (this branch's `ts/test/omni.ts` shape).
4. Add sekreto vendoring templates + SecretsFeature component + model
   `feature.secrets` block; emit registry/metadata/accessor from
   components (finding 5).
5. Decide the `prepare()` hook-pipeline question (finding 4) once, in
   sdkgen, not per SDK.
6. Wire `clean()` to sekreto redaction (finding 4), with corpus
   entries.
7. Adopt the OMNI v1 block corpus-wide (finding 7).
