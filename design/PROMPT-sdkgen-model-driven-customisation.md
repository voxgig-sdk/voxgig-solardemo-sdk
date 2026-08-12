# Prompt: make sdkgen customisations model-driven

Hand this to an agent working in `~/Projects/voxgig/sdkgen`. Evidence gathered
2026-08-12 against `6bc54f0` (v2.0.2), from upgrading
`voxgig-sdk/voxgig-solardemo-sdk` from sdkgen 1.3.17 to 2.0.2.

---

## The prompt

> You are working in the `@voxgig/sdkgen` repo (`~/Projects/voxgig/sdkgen`,
> currently v2.0.2 at `6bc54f0`).
>
> A consumer project — `voxgig-sdk/voxgig-solardemo-sdk` — cannot be generated
> correctly from its model alone. To get a building, `go get`-able,
> dead-code-free SDK it had to hand-edit vendored components and template
> masters in its own `.sdk/`. Every such edit is silently reverted by the next
> `voxgig-sdkgen target add`, because that command overwrites the vendored
> scaffold.
>
> It has since got to **zero forked components**, but only by renaming its slug
> to make sdkgen's hardcoded assumptions come true — which is not a fix
> available to a project that has already published. Three hand-edits to
> `.sdk/tm/**` remain, and there is still no way to verify any of this.
>
> That is the bug to fix. Each hand-edit is a place where sdkgen hardcodes a
> decision that belongs in the model. **Your task: move those decisions into
> the model, so a project can express them declaratively and never fork a
> component.**
>
> ### The end state to aim at
>
> **`voxgig-solardemo-sdk` must reach zero forked files and regenerate
> completely from stock sdkgen.** Concretely, after your work:
>
> - The project's `.sdk/src/cmp/**` contains **no modified copy** of any sdkgen
>   component. Project-*additive* components are fine, but only through a
>   supported extension point (gap 6) — not by editing files `target add`
>   overwrites.
> - The project's `.sdk/tm/**` contains **no hand-edited or hand-deleted**
>   template master.
> - Everything the project needs to say about itself is said in
>   `.sdk/model/**` — module path, Go version, active features, test strictness.
> - `voxgig-sdkgen target add` is **safe to run at any time**: it never
>   silently reverts a project decision, because there are no project decisions
>   living in the files it overwrites.
> - There is a command that **verifies** all of the above (gap 10), so the
>   property can be enforced in CI rather than remembered.
>
> Judge each gap by whether it moves that repo closer to zero forks. The
> current inventory is in the appendix — it is your acceptance checklist.
>
> Work through the eleven gaps below. For each: add the model surface, make the
> generator read it, keep the current behaviour as the default when the model
> says nothing (no existing project may change output), and cover it with a
> test in the suite that already guards per-target generation.
>
> Treat gaps 1–4 and 11 as required, and 5–10 as strongly desirable. If you disagree
> with a proposed model shape, propose a better one — the requirement is that
> the decision becomes model-driven, not that it takes the exact form below.
>
> When done, report which gaps are closed, the model keys you added, and
> anything you deliberately left out.

---

## Gap 1 — Package and repo identity assume the repo is named `<name>-sdk`

**Required.** Was the single largest source of hand-edits: 12 files.

> **Update:** this repo now has zero forks — see the appendix. It got there by
> renaming `model.name` to `voxgig-solardemo` so the stock derivation happens to
> be right, **not** because the gap is closed. That escape hatch costs a
> public-API rename (the slug drives the SDK class names too) and is unavailable
> to any project with published consumers. The gap stands.

`src/helpers/packageMeta.ts` derives every published identity from the slug:

```ts
// :45
const repo = `${slug}-sdk`
// :131-132
const base = origin.endsWith('-sdk') ? slug : `${slug}-sdk`
const npmScoped = `@${origin}/${slug}${origin.endsWith('-sdk') ? '' : '-sdk'}`
// :149, :188 and the go-cli / go-mcp cases
case 'go': return `github.com/${origin}/${slug}-sdk/go`
```

There is no override. The solardemo repo is **`voxgig-solardemo-sdk`**, not
`solardemo-sdk`, so:

- `go/go.mod` declared `github.com/voxgig-sdk/solardemo-sdk/go`, which **404s on
  `go get`** — the module is unconsumable.
- `ts/package.json` `homepage`, `repository.url` and `bugs.url` all pointed at a
  GitHub repo that does not exist. This also breaks `npm trust github`, which
  falls back to `repository.url` when `--repository` is omitted.

Worse, the module path is re-derived independently in **11 more components**,
so a fix in one place is not enough. All of these carry the same literal:

```
project/.sdk/src/cmp/go/{Entity,Main,Package,ReadmeExplanation,ReadmeHowto,
                         ReadmeModel,ReadmeQuick,ReadmeTopQuick,
                         ReadmeTopTest,Test}_go.ts
project/.sdk/src/cmp/go/ReadmeInstall_go.ts   (via packageName + repoInfo)
```

The consumer first tried a local `PkgPath.ts` helper wired into all 12. That
worked for the manifests but **could not fix the root `README.md`**, whose
Packages table is emitted by `src/cmp/ReadmeTop.ts` from inside `node_modules`
— not vendored, so not patchable downstream. Two lines stayed wrong.

That fork has since been reverted in favour of renaming the slug (see the
update above), so the repo is at zero forks and the root README is correct. The
gap is unaddressed all the same: the next project in this position may not be
free to rename.

**Proposed model surface:**

```
main: kit: repo: {
  # Full repo path; overrides the `<origin>/<name>-sdk` derivation.
  path: 'voxgig-sdk/voxgig-solardemo-sdk'
  host: 'github.com'          # default 'github.com'
}

main: kit: target: go: module: {
  # Full module path; overrides `github.com/<repo.path>/<subdir>`.
  path: 'github.com/voxgig-sdk/voxgig-solardemo-sdk/go'
}

main: kit: target: ts: module: {
  # Overrides the npm scope derivation. Needed by any project whose published
  # package name is not `@<origin>/<slug>` — e.g. one that renamed its package
  # but cannot rename its slug without renaming its SDK class.
  name: '@acme/legacy-client'
}
```

**Acceptance:**
- `repoInfo`, `packageName`, `installCommand` and `vendorCommand` all read the
  override, falling back to today's formula.
- No component re-derives the module path — every one takes it from a single
  helper. A grep for `` -sdk/go` `` outside `packageMeta.ts` returns nothing.
- `ReadmeTop` uses the same helper, so the root README agrees with `go.mod`.

---

## Gap 2 — The Go language version is hardcoded

**Required.** One-line fix, but it made the build fail outright.

`project/.sdk/src/cmp/go/Package_go.ts:28` emits `go 1.20` unconditionally.
sdkgen's own feature templates import `log/slog`, which needs **Go ≥ 1.21**, so
a generated SDK that ships those templates cannot compile against the `go.mod`
sdkgen wrote for it.

The consumer patched the component to read `target.module.goversion`, then
reverted that patch when the fork was removed. `go/go.mod` is back to sdkgen's
`go 1.20` and builds only because the `log/slog`-using feature templates were
also removed (gap 3). Re-enable any of them and the build breaks again.

**Proposed:** `main: kit: target: go: module: goversion: '1.23'`, defaulting to
the current `1.20`.

**Acceptance:** the emitted `go.mod` carries the model value; a target that
ships `log/slog`-using templates has a default high enough to compile.

---

## Gap 3 — Feature source is copied regardless of the model

**Required.** Ships unreachable code — and production dependencies — to
every consumer.

Full analysis in `REPORT-sdkgen-feature-copy-bug.md` (same folder). In short:
`src/cmp/Feature.ts` correctly copies only active features, but
`Main_<lang>.ts` bulk-copies the whole `tm/<lang>` tree and defeats it.
`Main_go.ts` excludes `/src\//`, but Go's feature templates live at
`tm/go/feature/`; `Main_ts.ts` has no `exclude` at all. clojure, haskell and
lean already exclude `src/feature/`, which shows the intent.

The solardemo model activates one feature (`test`) and received **16** Go
feature implementations and `LogFeature` in TypeScript — the latter dragging
`pino` and `pino-pretty` in as production dependencies of an SDK that could not
switch logging on.

It survived because the default scaffold model activates all 17 features,
making "copy everything" and "copy what's modelled" produce identical output.

**Acceptance:** with a model activating only `test`, no unmodelled feature
source appears in any target's output. `base` and shared infrastructure
(`feature_options.go`) still ship — consider moving them out of the `feature/`
template directory so the exclusion needs no allowlist.

---

## Gap 4 — Generated feature tests hard-depend on all feature source

**Required**, and it must land with Gap 3 — fixing 3 alone converts a silent
dead-code problem into a hard build break.

`project/.sdk/tm/go/test/feature_test.go` guards at **runtime**:

```go
func fhSkipWithout(t *testing.T, names ...string) { ... t.Skip(...) }
```

but references constructors at **compile time**:

```go
rf := feat.NewRetryFeature()
```

An SDK generated without those features cannot compile its test package, so the
runtime skip never runs. The consumer truncated the template to its first 365
lines (the `fh*` harness, which `pipeline_test.go` and `netsim_test.go` reuse)
and **lost all 15 per-feature behavioural test blocks**.

**Proposed:** split the `fh*` harness into its own always-emitted file, and emit
each per-feature block only when the model activates that feature — the same
condition Gap 3 introduces.

**Acceptance:** a one-feature model generates a compiling test package that runs
the harness, the pipeline tests and the blocks for its active features only.
A full-feature model generates exactly what it does today.

---

## Gap 5 — No stale-output pruning

Generation adds and merges but never deletes outputs whose source template was
removed upstream. This broke the solardemo Go build **twice in one session**:

- `tm/go/utility/make_target.go` — replaced upstream by `make_point.go`. Both
  were emitted, so `makePointUtil` was declared twice and the package would not
  compile.
- `tm/go/utility/struct/go.mod` — a nested module declaring
  `github.com/voxgig/struct`, which made `utility/struct` unimportable from the
  parent module. sdkgen's `Main_go.ts` already excludes this exact file, so it
  was pure stale output that the exclusion could not reach.

It also caused an earlier casing-collision bug (`FeatureHookUtility.ts` vs
`FeaturehookUtility.ts`, TS1261).

**Proposed:** either a `--clean` generate mode, or have `target add` reconcile
`tm/<target>` against the scaffold and report (or remove) files the scaffold no
longer ships. At minimum, **warn** — a silent orphan that breaks compilation is
the worst outcome.

---

## Gap 6 — No hook to register a custom per-target component

sdkgen's built-ins auto-dispatch to `cmp/<target>/X_<ext>.ts`, and `ReadmeTop`
uses `requirePath(ctx$, './cmp/<t>/ReadmeTopQuick_<t>', { ignore: true })` to do
it. `requirePath` is exported (`src/sdkgen.ts:455`), but there is no documented
way for a project to add a **new** per-target component to that mechanism.

The solardemo project wanted per-target `AGENTS.md` files and had to hand-wire
the dispatch in its own `Root.ts`:

```ts
if ('ts' === target.name) { AgentsTs({ target }) }
else if ('go' === target.name) { AgentsGo({ target }) }
```

This works but duplicates sdkgen's internal dispatch and does not scale past a
couple of targets.

**Proposed:** a registration API — e.g. `registerComponent('Agents')` resolving
`cmp/<target>/Agents_<ext>.ts` with the same `ignore: true` semantics — or
document `requirePath` as the supported extension point with an example.

---

## Gap 7 — `--dryrun` does not prevent writes in `target add`

Low severity, high surprise. `npx voxgig-sdkgen -y target add ts` prints
`** DRY RUN **` and **writes the files anyway**.

`src/action/target.ts:64-79` builds the `opts` object for `jostraca.generate`
and never passes `dryrun` through — it only interpolates the flag into the log
messages at `:83` and `:107`. Compare `src/sdkgen.ts:141`, which does pass
`dryrun: opts.dryrun`. `src/action/feature.ts` looks like it has the same
shape (`:82`, `:91`) and should be checked.

This matters because `target add` overwrites vendored components; a dry run is
exactly how a maintainer would preview that blast radius before committing.

**Acceptance:** `-y/--dryrun` on `target add` and `feature add` writes nothing
and reports the files it would change.

---

## Gap 8 — Live tests are unfalsifiable against a server the project controls

**Strongly desirable.** Found by falsification-testing the solardemo live
suite, not by reading code.

Running the TypeScript suite live against the local test app gives
**186 pass, 0 fail, 0 skipped**. Then stop the server and run it again:

```
ℹ tests 186
ℹ pass 184
ℹ fail 2      <-- ECONNREFUSED, from MoonEntity/basic and PlanetEntity/basic
ℹ skipped 0
```

**184 of 186 tests pass with nothing listening on the port.** Only the two
entity `basic` flows notice the server is gone. A green live run therefore says
almost nothing about whether the SDK can actually talk to the API.

The cause is deliberate leniency in the generated direct tests.
`project/.sdk/src/cmp/ts/TestDirect_ts.ts:338-344` emits:

```ts
if (setup.live) {
  // Live mode is lenient: synthetic IDs frequently 4xx. Skip rather
  // than fail when the load endpoint isn't reachable with the IDs we
  // can construct from setup.idmap.
  if (!result.ok || result.status < 200 || result.status >= 300) {
    return                    // <-- passes
  }
} else {
  assert(result.ok === true)
  ...
}
```

A failed request becomes an early `return`, not an assertion.
`TestDirect_go.ts:256-260` has the same shape. Four such sites are emitted per
target (load and list, per entity). `TestEntity_{ts,go}.ts` has **no** lenient
branch — which is exactly why the entity tests were the only ones to fail.

There is a second silent-pass path: `skipIfMissingIds` (4 call sites) skips when
idmap keys are absent. That one at least reports as a skip, so it is visible.

**The leniency is correct for sdkgen's default case** — a fleet SDK generated
against an arbitrary third-party public API, where synthetic IDs 4xx and list
response shapes vary wildly. It is wrong when the project owns the server it is
testing against, which is precisely the situation of any SDK with a local test
app. Those projects have no way to say so.

**Proposed model surface:**

```
main: kit: test: live: {
  # false (today's behaviour) — a non-2xx in live mode is an early return.
  # true  — live assertions match the offline ones; a non-2xx fails.
  strict: false
}

# Per-target override, for a project whose targets differ.
main: kit: target: <t>: test: live: strict: true
```

Generate the resolved value into the existing per-SDK
`tm/<target>/test/sdk-test-control.json`, which already carries
`test.live.delayMs` and `test.skip.live` and is already loaded by the test
utility — so this needs no new config surface, just a new key. Allow a run-time
override via `<NAME>_TEST_LIVE_STRICT=TRUE`, matching how `<NAME>_TEST_LIVE`
already works.

Under `strict`, `skipIfMissingIds` should also fail rather than skip: if the
project controls the server, a missing idmap is a fixture bug, not an
environmental one.

**Acceptance** — this is the falsification test, and it is the whole point:

- With `strict: true` and the server **stopped**, the live suite **fails**.
- With `strict: true` and the server running with correct `*_ENTID` maps, it
  passes.
- With `strict` absent or `false`, output is byte-identical to today.

---

## Gap 9 — Project scaffold files are created once and never updated

**Strongly desirable.** This is the gap that let a defect sit unnoticed for
months.

`target add` writes `.sdk/src/cmp/**` and `.sdk/tm/**`. It does **not** touch
the project-root generator wiring — `.sdk/src/Root.ts`, `Top.ts`,
`BuildSDK.ts`. The scaffold does not even ship them
(`project/.sdk/src/` contains only `cmp/`); they come from `create-sdkgen` at
project init and are then frozen forever.

Consequence: when sdkgen adds a root-level capability, existing projects never
learn about it. sdkgen grew a full `ReadmeTop` component that assembles the root
README from `ReadmeTopQuick`/`ReadmeTopHowto`/`ReadmeTopTest`. solardemo's
`Top.ts` — written before that existed — kept hand-rolling a 9-line stub with an
empty mermaid diagram, and **nothing in any number of `target add` runs would
ever have told it otherwise**. It was found by hand this session and fixed by
rewriting `Top.ts` to call `ReadmeTop({})`.

Note this cuts against gap 6 if handled naively: a project's `Root.ts` is the
one place its custom components get wired, so it cannot simply be overwritten.

**Proposed:** treat root wiring as scaffold that can be reconciled —
`voxgig-sdkgen project update`, reporting where the project's wiring differs
from the current scaffold's and what capability it is missing. Combined with
gap 6 (a registration API for custom components), a project's `Root.ts` becomes
thin enough to be regenerated safely: the custom parts live in a registration
list, not inline `if (target.name === …)` branches.

**Acceptance:** a project initialised against an older sdkgen can discover, via
a command, that a new root-level component exists and is not wired in.

---

## Gap 10 — There is no way to detect divergence

**Strongly desirable**, and the one that makes all the others *stay* fixed.

Nothing tells a project that its `.sdk/` has drifted from the scaffold. Every
divergence in this document was found by hand-diffing against
`node_modules/@voxgig/sdkgen/project/.sdk`. Without a check, closing gaps 1–9
fixes the repo once and guarantees nothing about next month.

**A naive file diff will not work, and you should know why before designing
this.** `target add` writes template masters with substitution *partly*
applied, and inconsistently:

- `tm/go/core/error.go` — project has `SolardemoError`; scaffold has
  `ProjectNameError`. Substituted on write.
- `tm/ts/test/utility.ts` — project **keeps** `PROJECTNAME_TEST_LIVE`; the
  substitution happens later, at generate time.
- `tm/go/LICENSE` — project has `2026`; scaffold has `$$const.year$$`.

So the project's `tm/` is neither a verbatim copy nor a fully substituted one.
Only sdkgen knows which replacements it applied to which files, which is
exactly why this check belongs upstream and cannot be scripted downstream.

**Proposed:** `voxgig-sdkgen doctor` (or `target add --check`) that reports:

1. **Forked components** — files in `.sdk/src/cmp/**` that differ from the
   scaffold. Should be empty; anything here will be silently reverted.
2. **Edited or missing template masters** — `.sdk/tm/**` compared *after*
   applying the same substitutions `target add` applied, so the comparison is
   meaningful.
3. **Stale files** — present in the project but no longer in the scaffold
   (this is gap 5's detection half).
4. **Additive files** — project-owned components, listed separately and **not**
   flagged as drift.

Non-zero exit on categories 1–3 so it can gate CI.

**Acceptance:** running it on `voxgig-solardemo-sdk` after gaps 1–9 reports
zero forks, zero edited masters, zero stale files, and lists only
`Agents_{ts,go}.ts` as additive.

---

## Gap 11 — Two different env-var derivations from a hyphenated slug

**Required.** A correctness bug, found by acting on gap 1's advice.

The cleanest resolution of gap 1 for this repo turned out to need no override at
all: setting `model.name: 'voxgig-solardemo'` makes sdkgen's own derivations
land on the real npm package, Go module and repo URL. That removed all 12 forks
— **but exposed that sdkgen derives test env-var names two different ways**, and
they disagree whenever the slug contains a hyphen.

`helpers/packageMeta.ts` has the correct helper, added for exactly this reason:

```ts
// "...so examples are valid identifiers (model.NAME left a hyphen in,
//  breaking process.env.X)"
function envName(model: any): string {
  return String(model.name || '').toUpperCase()
    .replace(/[^A-Z0-9]+/g, '_').replace(/^_+|_+$/g, '')
}
```

`envName` yields `VOXGIG_SOLARDEMO`. But other components still derive the
prefix by stripping the hyphen, yielding `VOXGIGSOLARDEMO`. Both reach the
generated output, in both targets:

```
generated TS          generated Go
 6  VOXGIG_SOLARDEMO_TEST_LIVE      1  VOXGIG_SOLARDEMO_TEST_LIVE
13  VOXGIGSOLARDEMO_TEST_LIVE      11  VOXGIGSOLARDEMO_TEST_LIVE
 4  VOXGIG_SOLARDEMO_TEST_PLANET    6  VOXGIGSOLARDEMO_TEST_PLANET
 2  VOXGIGSOLARDEMO_TEST_PLANET     ...
```

Within a single file: `test/utility.ts:65` reads `VOXGIGSOLARDEMO_TEST_LIVE`
while `PlanetEntity.test.ts:41` reads `VOXGIG_SOLARDEMO_TEST_LIVE`.

**Impact:** live tests are gated inconsistently. Setting one variant sends some
tests live and leaves others mocked, with no warning — the suite reports green
either way. Running fully live currently requires setting **both** spellings of
every variable.

This is invisible for a single-word slug, which is why it has not been seen.
Any project whose slug has a hyphen — the natural shape for `<org>-<product>` —
hits it immediately.

**Acceptance:** exactly one env-var spelling appears in generated output for
any slug. Grep the output of a hyphenated-slug model for
`_TEST_LIVE` and expect a single distinct prefix. Route every derivation
through `envName`.

---

## Appendix — current divergence inventory (acceptance checklist)

Measured 2026-08-12 against sdkgen 2.0.2. Each line must reach zero, or be
reclassified as supported-additive.

### Forked components — 0 (was 12)

**Already resolved**, by renaming the slug rather than overriding the
derivation: `model.name` is now `voxgig-solardemo`, so sdkgen's stock formula
produces `@voxgig-sdk/voxgig-solardemo`,
`github.com/voxgig-sdk/voxgig-solardemo-sdk/go` and the correct repo URLs with
no generator change. All 12 forks were reverted to stock and `PkgPath.ts`
deleted.

Gap 1 therefore no longer blocks *this* repo — but it still matters for any
project that cannot rename (the slug also drives the SDK class names, which is
a public-API change; it was free here only because nothing is published yet).
Keep gap 1: the fix should be a model override, not a forced naming
convention.

The rename is what surfaced **gap 11**.

### Edited template masters — 1

```
tm/go/test/feature_test.go     truncated to its harness (first 366 lines)
```

**Gap 4 → 0.**

Verified by normalising sdkgen's own target-add substitutions before comparing.
A naive `diff -r` against the scaffold reports **20** edited files here; 19 are
substitution artefacts (`ProjectName` → `VoxgigSolardemo`, `$$const.year$$` →
`2026`) and only this one is a hand-edit. That 20-vs-1 gap is the whole
argument for gap 10.

### Deleted template masters — 48

The unmodelled feature templates: 16 Go `tm/go/feature/*_feature.go`, 16
TypeScript `tm/ts/src/feature/<name>/`, and 16
`tm/go/src/feature/<name>/.gitkeep` placeholders. **Gap 3 → 0** (they stop
being copied into output, so the project has no reason to delete them).

### Stale files removed by hand — 4

```
tm/go/utility/make_target.go        superseded by make_point.go; duplicate symbol
tm/go/utility/struct/go.mod         nested module; broke the parent module build
tm/go/test/exists_test.go           Test_go.ts:31 generates this programmatically
src/cmp/ts/fragment/Config.fragment.ts   substituted values where the scaffold has placeholders
```

The first two broke the Go build. The last two were found while auditing for
this appendix; both were verified to leave generated output byte-identical.
None is reported by any tool — all four were found by hand-diffing.
**Gap 5 → detected automatically instead of by hand.**

These reappear after `target add`, so they are part of the recurring manual
repair, not a one-off cleanup.

### Additive project components — 2 (acceptable, but unsupported today)

```
src/cmp/go/Agents_go.ts
src/cmp/ts/Agents_ts.ts
```

Hand-dispatched from `Root.ts` with `if (target.name === …)`. **Gap 6** should
make these supported extensions rather than a convention the project invented.

### Project-owned, correctly so — no action

```
.sdk/model/**              the model: module path, goversion, entities, features
.sdk/test/primary/*.aontu  the utility test corpus — project data
.sdk/src/{Root,Top,BuildSDK,Agents,AgentInfo}.ts   root wiring (see gap 9)
```

`PkgPath.ts` no longer exists — deleted when the 12 forks were reverted.

---

## Why this matters beyond one project

Every gap above has the same shape: **sdkgen decided something that belongs to
the project, and offered no model key to say otherwise.** The consumer's only
recourse is to fork a vendored component — which `target add` then silently
reverts, so the SDK regresses without anyone touching it.

The solardemo repo reached zero forked components, but only by renaming its
slug so sdkgen's hardcoded assumptions happen to be true — an escape hatch that
costs a public-API rename and is closed to any project with published
consumers. It still needs a documented three-step repair to `.sdk/tm/**` after
every scaffold resync (feature templates, feature-test truncation, stale
files). Closing gaps 3, 4 and 5 removes all three; gap 1 removes the need for
the rename; gap 10 makes the whole property checkable.

Gap 8 is the same shape with a sharper edge: the default is not merely
inconvenient, it is **quietly wrong** for any project that owns its test
server. Gaps 1–7 announce themselves — a build fails, a `go get` 404s, dead
code appears in a diff. Gaps 8 and 11 announce themselves as a passing test
suite, which is worse.
