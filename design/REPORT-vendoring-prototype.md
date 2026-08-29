# REPORT: vendoring omni, struct and sekreto — findings and staging

Prototype work to vendor the current [voxgig/omni](https://github.com/voxgig/omni)
(shared test specs), [voxgig/struct](https://github.com/voxgig/struct)
(data utilities) and [voxgig/sekreto](https://github.com/voxgig/sekreto)
(secret access) into this SDK, keeping it dependency-free. The plan it
feeds is
[voxgig/sdkgen `docs/design/vendoring-upgrade-migration.md`](https://github.com/voxgig/sdkgen/blob/main/docs/design/vendoring-upgrade-migration.md).

**What is on main, and what is not.** The sekreto half ships here, as a
project-owned extension (`ts/src/ext/secrets/`) wired through
`options.extend`. The struct and omni halves are NOT here: they are
refreshes of files the ts target GENERATES, so they belong in sdkgen's
templates and reach this repo by regeneration. Their full working proof —
struct 0.3.2 swapped in, omni replacing the hand-vendored runner, three
upstream omni bug fixes — lives on the unmerged prototype branch
`claude/vendor-omni-struct-sekreto-prototype`
([PR #29](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/pull/29)),
which is deliberately unmergeable and kept as evidence.

Versions pinned by the prototype: omni 0.1.2 (`bc9535d`), struct 0.3.2
(`9440935`), sekreto 0.1.2 (`a8c293b`). All MIT; vendoring needs only
notice retention, which the per-file provenance headers supply.

## 1. "Add is overwrite" decides what can live here

Running `.sdk`'s `generate` over the prototype branch REVERTED every
manual edit to a generated file and RECREATED the file the branch had
deleted. That is the drift gate working as designed, and it partitions
the work cleanly:

- Anything sdkgen generates can only be changed by changing sdkgen. A
  hand-edit is reverted on the next regeneration, and the gate fails in
  the meantime.
- Anything sdkgen does NOT generate survives untouched. New files and new
  directories are left alone — `generate` writes what it owns and prunes
  nothing.

`ts/src/ext/` is the second kind, which is why the secrets extension can
sit on main with the gate green: after `npm run generate`, `git diff` is
empty and no generated file moves.

## 2. Two blockers stop the secrets feature being GENERATED today

The natural home for secrets is an sdkgen feature template, so every
language target gets it. Two things block that, and both were established
by trying it rather than by reading:

**A project-owned sdkgen package is the right shape, and it is not
enough.** An `ext/` package (manifest + `model/feature/secrets.aon` +
`tm/ts/src/feature/secrets/`) modelled on elementdemo's `elementcard`
passes `voxgig-sdkgen package check` with no findings, and `package add`
plus `feature add secrets` wire it in correctly. Generation then FAILS:

```
Copy: from: check: string: tm/js/src/feature/secrets
```

`feature add` warns `feature-source-missing` for all 20+ targets with no
secrets source, and only warns; at generate time `Copy` stat-fails on the
first of them and aborts the whole run (exit 1), so `ts` never emits.
Worse, it would not be enough to skip the copy: the Config components
emit feature imports and registry entries generically from the model's
ACTIVE features, so every target that did generate would carry a dangling
import of a feature it has no source for.

**So the missing capability is a feature APPLICABILITY GATE**, and it is
a real one: a feature is active or inactive for the whole model, with no
per-target dimension. `docs/design/feature-tags.md` proposes tags;
nothing implements them; `Feature.ts` carries the matching TODO (*"Copy
should just warn if from not found"*), which is necessary but not
sufficient. The fix has to filter the per-target model view — one place,
so that `Feature`, the Config components and the docs components all see
the same answer — and it deserves its own design and PR. It is named as a
Phase 3 prerequisite in the migration guide.

Until it exists, `options.extend` is the honest route: it is the
documented seam for adding a feature instance to a generated client, it
needs no sdkgen change, and it puts the design under test now.

## 3. Releases come from main, so a prototype cannot be staged via npm

The obvious way to get template changes into this repo without touching
sdkgen main is to publish a prerelease from a prototype branch and pin
`.sdk` to it. sdkgen's `publish.yml` refuses:

```
Dispatches must come from main
::error::dispatch ref is <branch>; releases must come from main
```

The only other entry, a hand-pushed `v*` tag, has no such guard — but
using it would be circumventing a control the repository installed
deliberately against exactly that, for an action (an npm publish) that
cannot be undone. So there is no prerelease shortcut: struct and omni
reach this repo when sdkgen lands those phases on main and releases
normally, and this repo bumps its pin and regenerates.

## 4. The apikey × sekreto contract

The design that survived contact, now under test in
`ts/test/secrets.test.ts`:

- The `apikey` option keeps its exact meaning and always wins when set,
  because it is the FIRST provider in the chain (a `memory` store named
  `options`). Explicit-beats-lookup is sekreto's own first-hit rule, not
  special-case logic, and the explicit value stays addressable
  (`getfrom('options', 'apikey')`) and redactable like any other store.
- **Two entry points, one rule.** Resolution is async; the auth header is
  built by the synchronous `prepareAuth`. Entity ops await
  `featureHook('PreSpec')` before `makeSpec`, so the hook resolves in
  time for the pipeline's own `prepareAuth`. `prepare()`, `direct()` and
  `graphql()` run no hooks, so the transport wrap resolves there and
  re-applies auth by calling `prepareAuth` through a derived context —
  the prefix rule (Bearer/Basic/raw) is never copied.
- **The direct path keeps its contract.** The wrap runs inside
  `_rawRequest`'s `try`, so a provider failure comes back as
  `{ ok: false, err }`. An earlier design awaited resolution in
  `prepare()`, which is called OUTSIDE that try and would have made
  `direct()` throw — the documented contract says it returns a value or
  an `Error`.
- **Miss versus error** is sekreto's invariant and is preserved: a store
  that does not hold the secret is a miss and the chain continues; a
  store that could not answer fails the operation. A broken vault never
  falls through to an unauthenticated request.
- **Empty versus omitted.** `makeOptions` normalizes an omitted `apikey`
  to `''` before features initialize, so by then the two are
  indistinguishable and both defer to the chain. To send no credential,
  give the feature nothing to find.
- **`auth: null` is unreachable here.** `prepareAuth` has a null-auth
  branch, but this SDK's generated optspec always supplies
  `auth: { prefix: '' }`, so `validate` rejects a null and the branch
  only fires for SDKs whose optspec omits `auth`. Pinned by a test, since
  it is exactly the kind of assumption that reads as true.
- Feature `init` is synchronous by contract (the constructor cannot
  await), so it BUILDS the chain and looks nothing up. Worth documenting
  for feature authors generally: async work belongs in hooks.

## 5. struct 0.3.2: a green suite is not a free upgrade

Proven on the prototype branch: the swap needs zero call-site changes
(0.3.2's exports are a strict superset) and the full shared corpus passes
on both versions. But corpus nulls travel as `'__NULL__'` STRINGS, so
real-JSON-null semantics are untested there, and live API traffic will
see all of this:

- getprop/getelem/getpath treat a stored JSON null as "no value": the
  `alt` default fires on null, and `Result.body`, GraphQL `data: null`
  and null entity fields read as `undefined`.
- inject/transform DELETE an output key whose backtick reference resolves
  to null — reaching every `transform.req`/`transform.res` point spec.
- validate's list-form `` ['`$CHILD`', tm] `` now validates the first
  element; `escre` throws on non-string input; `walk`'s callback path
  array is pooled and must be cloned to retain.

Corpus entries pinning the null semantics should land BEFORE the
per-language refresh, so every port proves the same behaviour.

## 6. omni: three upstream bugs this corpus finds

omni's own consumers feed it pure-JSON specs. This corpus drives LIVE
`Context` objects through entries, and a live context is cyclic
(`sdk._rootctx.client === sdk`). Each is fixed on the prototype branch
behind a marked `PATCH` comment and needs upstreaming:

- `Runner.match()` clones the match base — pointless (it only reads) and
  fatal on a cyclic base.
- `Util.jsonstr()` has no cycle guard, so building the FAILURE MESSAGE
  for a ctx entry also overflows the stack.
- `errify()`/`errmessage()` collapse non-Error throwables to
  `String(err)` = `'[object Object]'`; the corpus throws error-shaped
  maps, and the original runner matched `err.message` regardless of
  class.

Two compat-shim gaps are handled consumer-side rather than patched: the
provider wrapper forwards `utility()`/`tester()` but not
`options()`/`_features`/`_rootctx`, and the caller-directory spec-path
heuristic resolves one level too deep for the compiled layout.

## 7. Smaller findings

- **Vendoring conventions.** Uniform provenance headers (repo, commit,
  upstream path, license, resync notice) made three vendored trees
  auditable; the existing copies had a bare version stamp at best, and
  the go struct copy has none. Stamps must move TOGETHER — the runner,
  StructUtility and the struct corpus test all carried `0.0.10`.
- **Template-side drift is invisible to `doctor`**, which compares a
  consumer's copies against the templates: edit the template and they
  agree again. Detecting it needs per-file hashes checked in sdkgen's own
  suite.
- **`clean()` is an identity function** (its redaction body is commented
  out) while `sekreto.redact()` already tracks every resolved value.
  Wiring them together would give real log hygiene for almost no code.
- **sekreto is Node-only at import time**: `Providers.ts` has top-level
  `node:child_process`/`fs`/`path` imports and `Sigv4.ts` needs
  `node:crypto`. Browser targets need the upstream per-provider split;
  do not fork it locally.
- **`prepare()`/`direct()`/`graphql()` run no feature hooks at all**, so
  every feature that needs to act on those paths must wrap the transport.
  Whether they should instead run a reduced hook pipeline is a question
  for sdkgen, to be answered once rather than per feature.

## Next steps

1. Upstream the three omni fixes, with spec entries pinning cyclic-ctx
   and map-shaped errors.
2. Design and implement the feature applicability gate in sdkgen — the
   prerequisite for secrets (and any package-provided feature) being
   generated in a multi-target project.
3. Land struct 0.3.2 and the omni runner as sdkgen template phases, with
   null-semantics corpus entries; release normally from main; bump this
   repo's pin and regenerate.
4. Move `ts/src/ext/secrets/` into an sdkgen feature template once the
   gate exists, and delete it here.
