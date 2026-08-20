# Report: Bugs & Issues

Originally written 2026-06-08. **Re-verified and largely resolved 2026-08-12**
during the `@voxgig/sdkgen` 1.3.17 → 2.0.2 upgrade.

> **Superseded as the current register** by
> [REPORT-codebase-review-2026-08-20.md](REPORT-codebase-review-2026-08-20.md)
> (sdkgen 3.3.1). Keep this file for history; §6 of the 2026-08-20 review
> maps each ID below onto present status. Several items here are wrong
> now — notably A2 (Go 1.23), E9 (no forks), G4 (hyphenated env vars),
> and the “single source of truth” claim in the next paragraph.

This **was** the single source of truth for issue status through 2026-08-12;
the other reports in `design/` deferred to it.

Severity: **High** / **Medium** / **Low**.
Status: **Fixed** / **Open** / **Upstream**.

> Companion documents: [REPORT-build-and-test-status.md](REPORT-build-and-test-status.md)
> for what currently builds and passes; [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md)
> for the upstream sdkgen defect found during this work; and
> [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md),
> which specifies the upstream work that would close E9, E10, E11, G3 and B0 by
> making the hardcoded decisions model-driven.

---

## A. Build & CI regressions — all fixed

| ID | Severity | Status | Issue |
| --- | --- | --- | --- |
| A1 | High | Fixed | **TS `pino` deps dropped.** Moot: `LogFeature` was the only consumer and is now removed (**B0**); `ts/package.json` has no runtime dependencies at all. |
| A2 | High | Fixed | **Go `log/slog` vs `go 1.20`.** sdkgen 2.0.2 hardcodes `go 1.20` in `Package_go.ts`; the model now sets `module.goversion: '1.23'` and the component reads it. |
| A3 | High | Fixed | **Go `ctx.Spec.Name` does not exist.** Moot — the file is gone with `LogFeature`. |
| A4 | High | Fixed | **Filename casing collision** in `ts/src/utility/`. |
| A5 | Medium | Fixed | **TS type resolution** — explicit `"types": ["node"]` in the tsconfig templates. |
| A6 | High | Fixed | **App dependency vulnerabilities.** Recurred as D4 and was fixed again; `npm audit` in `app/` now reports 0. |

---

## B. `LogFeature` correctness — resolved by removal

`LogFeature` was never registered: the model activates only `test`, and
`go/solardemo.go` wires only `BaseFeature` + `TestFeature`. It shipped in both
SDKs as unreachable code, and cost the TS SDK two production dependencies.

### B0 — `LogFeature` shipped unregistered — **Medium, Fixed**
Removed, along with the 15 other unmodelled feature templates the 2.0.2 resync
pulled in (audit, cache, clienttrack, debug, idempotency, metrics, netsim,
paging, proxy, ratelimit, rbac, retry, streaming, telemetry, timeout).
`.sdk/tm/{go/feature,ts/src/feature}` now contain only `base` and `test`.

The root cause is an upstream sdkgen defect — `Main_<lang>.ts` bulk-copies the
whole `tm/<lang>` tree regardless of which features the model activates. Full
analysis in [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md).
Until that is fixed upstream, every `voxgig-sdkgen target add` re-adds all 16
templates and they must be deleted again.

### B1–B5 — **Fixed (code removed)**
The caller-supplied-logger bug (B1), the cross-target `active` default
divergence (B2), the missing TS `SetMatch` hook (B3), the dead `level`
parameter (B4) and the TS/Go spec-logging divergence (B5) all lived in
`LogFeature`. They are gone from this repo. **They still exist in the sdkgen
templates** and will return with the feature if it is ever modelled — worth
fixing upstream regardless.

---

## C. Generated documentation — fixed

### C1 — Wrong install / import name — **High, Fixed**
sdkgen 2.0.2 introduced `helpers/packageMeta.ts` as the single source of truth
for published identity. `Package_ts.ts` and the Readme components now all call
`packageName(model, …)`, so the manifest and the README can no longer disagree.
`ts/README.md` install line and `ts/package.json` name both read
`@voxgig-sdk/solardemo`.

### C2 — Empty entity field tables — **High, Fixed**
The 2.0.2 `ReadmeModel_{ts,go}.ts` read `entity.fields` (plural). Field tables
are populated in both READMEs.

*Residual (Low, Open):* the **Description** column is blank because
`.sdk/model/entity/*.aontu` carries no per-field descriptions. That is missing
model data, not a generator bug — the OpenAPI spec has no field descriptions to
import. Adding them by hand would populate the tables.

### C3 — Empty "API path" — **Medium, Fixed**
Paths now render per operation point, e.g.
`API path: /api/planet/{planet_id}/moon` in both READMEs.

### C4 — Empty create examples — **Low, Fixed**
Consequence of C2; create examples now carry real fields.

### C5 — Missing Readme sub-components — **Low, Fixed**
`target add` brought in the nine missing components
(`ReadmeIntro`, `ReadmeOptions`, `ReadmeEntity`, `ReadmeRef` for both targets,
plus `ReadmeExplanation_ts`). `npm run generate` now emits **zero**
`require-missing` warnings.

### C6 — Root `README.md` was a 9-line stub — **High, Fixed**
`.sdk/src/Top.ts` hand-rolled a stub and bypassed sdkgen's `ReadmeTop`. It now
delegates to `ReadmeTop`, producing a 215-line root README (packages,
quickstart per language, entities, how-to, upstream API, security). This also
makes `go/test/readme_examples_test.go` pass — it compiles every Go snippet in
the READMEs, and previously failed with "no go code blocks in root README".

---

## D. Packaging & consumption

### D1 — Go module is not `go get`-able — **High, Fixed**
`go/go.mod` declares `module github.com/voxgig-sdk/voxgig-solardemo-sdk/go`.

Fixed by renaming the model slug, **not** by overriding the generator.
`model.name` is now `voxgig-solardemo`, so sdkgen's stock
`github.com/<origin>/<name>-sdk/go` derivation lands on the real repo. The same
rename gives the npm package `@voxgig-sdk/voxgig-solardemo` and correct
`homepage`/`repository`/`bugs` URLs.

An earlier attempt overrode the derivation via a local `PkgPath.ts` wired into
12 vendored components. That worked but forked a third of the Go generator; it
was reverted in favour of the rename. Cost of the rename: `SolardemoSDK` →
`VoxgigSolardemoSDK`, `SolardemoError` → `VoxgigSolardemoError`, and the test
env prefix changed. Free here because nothing is published yet.

### D2 — `pino` as a hard prod dependency — **Medium, Fixed**
Removed with `LogFeature`. `ts/package.json` now has **no** runtime
dependencies.

### D3 — `@types/node` major mismatch — **Low, Open**
`app/` uses `@types/node ^24`; the TS SDK now uses `^25.6.0` (set by the 2.0.2
target scaffold). Both run on Node 24. Harmless but inconsistent.

### D4 — App dependency vulnerabilities returned — **High, Fixed**
`fast-uri`, `find-my-way` and `esbuild` advisories, all transitive via
`fastify`. `npm audit fix` applied; `app/` now reports 0 vulnerabilities. This
has now recurred once — worth automating (Dependabot or a scheduled audit)
rather than fixing by hand each time.

### D5 — `.sdk` dependency ranges are unpinned — **Low, Open**
`.sdk/package.json` floats on `>=` ranges, now bumped to the current majors
(`@voxgig/sdkgen >=2.0`, `@voxgig/apidef >=7.0`, `@voxgig/model >=9.4`,
`@voxgig/util >=0.5`, `@voxgig/struct >=0.2`, `jostraca >=0.31`,
`aontu >=0.51`). Deliberate per the fleet convention, but it is why the
toolchain silently sat two majors behind until this session.

---

## E. Generator robustness & authoring DX

### E1 — No stale-output pruning — **Medium, Open**
Still true, and it bit twice this session. The 2.0.2 resync left two orphans
that broke the Go build:

- `.sdk/tm/go/utility/make_target.go` — replaced upstream by `make_point.go`;
  both were emitted, so `makePointUtil` was declared twice.
- `.sdk/tm/go/utility/struct/go.mod` — a nested module declaring
  `github.com/voxgig/struct`, which made `utility/struct` unimportable from the
  parent module. sdkgen explicitly excludes this file, so it was pure stale
  output.

Both removed by hand. A "clean the target directory before generate" option, or
a `tm/` diff against the scaffold, would catch this class automatically.

### E2 — Entity hierarchy / mermaid diagram — **Medium, Fixed (diagram dropped)**
The old diagnosis was wrong twice over. The hierarchy is **not** missing from
the model — it is at `entity.<name>.relations.ancestors` (`moon` →
`[["planet"]]`), an array of ancestor *paths*, not a flat list — and `Top.ts`
read `entity.ancestors`, so the diagram always rendered empty.

`Top.ts` now delegates to sdkgen's `ReadmeTop`, which has a proper Entities
section but **no mermaid diagram**. Nothing working was lost (the old one never
rendered), but if the diagram is wanted it belongs in `ReadmeTop` upstream and
must read `relations.ancestors`.

### E3 — No hook to register custom per-target components — **Low, Open**
The `Agents` dispatch is still hand-wired in `.sdk/src/Root.ts` with an
`if (target.name === …)` branch. Unchanged in 2.0.2.

### E4 — `app/` is outside the generation model — **Low, Open**
Unchanged. The generator still writes `app/AGENTS.md` into a hand-written
folder with app facts hardcoded.

### E5 — Markdown authored via TS template literals — **Low, Open**
Unchanged.

### E6 — Generated JSON has no trailing newline — **Low, Open**
`ts/package.json` and `.sdk/model/sdk.json` still end without a final newline.

### E7 — `fs.F_OK` deprecation warning — **Low, Open**
Still emitted on `jostraca 0.31.2`.

### E8 — Committed `sdk.json` drifted from the toolchain — **Low, Fixed**
`.sdk/model/sdk.json` is regenerated and committed at its current shape.
**Decision: the model dump stays committed.** Consecutive `npm run generate`
runs now produce a byte-identical tree.

### E9 — Forked generator components — **Medium, Fixed**
Twelve components were forked to override the module path. All reverted to
stock and `PkgPath.ts` deleted; the slug rename (D1) removed the need. The
root `README.md` Packages table is now correct too, which the fork could never
achieve — it is emitted by sdkgen's own `ReadmeTop` from `node_modules`.

**`.sdk/src/cmp/**` now matches the sdkgen 2.0.2 scaffold exactly.** Three
`.sdk/tm/**` repairs still survive a resync (B0, E10, E1) — see
[design/README.md](README.md) for the post-`target add` checklist.

### E10 — Go feature tests hard-depend on all feature source — **Medium, Upstream** *(new)*
`tm/go/test/feature_test.go` calls `feat.New<Name>Feature()` for all 15
enterprise features at **compile time**, while guarding at *runtime* with
`fhSkipWithout`. Removing a feature's source therefore breaks compilation of
the whole test package rather than skipping the block.

Worked around by truncating the template to its harness (the first 365 lines),
which keeps the `fh*` helpers that `pipeline_test.go` and `netsim_test.go`
reuse. **Cost: the 15 per-feature behavioural test blocks no longer run here.**
Restore them by re-adding the feature templates and re-running `target add go`.
Upstream, the harness belongs in its own file and each block should be
conditional on the model. Same root cause as
[REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md).

### E11 — `voxgig-sdkgen --dryrun` writes anyway — **Low, Upstream** *(new)*
`npx voxgig-sdkgen -y target add ts` prints `** DRY RUN **` and writes the
files regardless. `src/action/target.ts` builds the `jostraca.generate` opts
without passing `dryrun` through; the flag only reaches the log messages.
`src/action/feature.ts` appears to have the same shape.

This matters precisely because `target add` overwrites vendored components —
a dry run is how you would preview that blast radius. Gap 7 in
[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md).

---

## F. Process / environment

### F1 — CI Go version — **Fixed**
`.github/workflows/ci.yml:76` uses `go-version-file: go/go.mod`, so the runner
tracks the module's declared `go 1.23`. Node jobs pin `'24'` and `'latest'`.

---

## G. Test coverage

### G3 — Live direct tests cannot fail — **Medium, Upstream** *(new)*
Verified by falsification 2026-08-12. The TS suite run live against the local
app gives 186 pass / 0 fail / 0 skipped. **Stop the server and 184 of 186 still
pass** — only `MoonEntity/basic` and `PlanetEntity/basic` fail on
ECONNREFUSED.

The generated direct tests treat a non-2xx in live mode as an early `return`
rather than an assertion (`ts/test/entity/planet/PlanetDirect.test.ts:110-120`,
from `TestDirect_ts.ts:338`; `TestDirect_go.ts:256` is the same). Four such
sites per target. `TestEntity_{ts,go}.ts` has no lenient branch, which is why
the entity tests were the only ones to notice.

This is a sensible default for sdkgen's fleet — those SDKs run against
arbitrary third-party APIs where synthetic IDs 4xx routinely. It is wrong for a
project with its own test app, and there is no way to say so. Gap 8 in
[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md)
proposes a model-driven `test.live.strict`.

Until then, treat a green live run as evidence the SDK *builds and dispatches*,
not that it round-trips correctly. The two entity `basic` flows are the only
tests carrying that weight.

### G4 — Two env-var spellings from a hyphenated slug — **High, Upstream** *(new)*
The slug rename to `voxgig-solardemo` exposed an sdkgen bug: test env-var names
are derived two ways that disagree when the slug contains a hyphen.
`helpers/packageMeta.ts` has `envName()` (→ `VOXGIG_SOLARDEMO`), added
explicitly because "model.NAME left a hyphen in, breaking process.env.X" — but
other components still strip the hyphen (→ `VOXGIGSOLARDEMO`). Both reach the
generated output, in both targets, sometimes in the same file:
`ts/test/utility.ts:65` reads `VOXGIGSOLARDEMO_TEST_LIVE`;
`PlanetEntity.test.ts:41` reads `VOXGIG_SOLARDEMO_TEST_LIVE`.

**Consequence: setting one spelling sends some tests live and leaves others
mocked, and the suite reports green either way.** Running fully live requires
setting *both* spellings of every variable — see
[REPORT-build-and-test-status.md](REPORT-build-and-test-status.md).

Invisible for a single-word slug, which is why it was never hit before.
Gap 11 in [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md).

### G1 — Generated Go packages have no direct unit tests — **Low, Open**
`go test ./...` still exercises only the `test` package; `core`, `entity`,
`feature`, `utility` report `[no test files]`. Coverage did improve: 2.0.2
added `pipeline_test.go` (pipeline error/edge branches), `netsim_test.go` and
`readme_examples_test.go` (compiles every Go snippet in the READMEs), taking
the Go suite from 8 top-level tests to 17.

### G2 — Corpus fixtures were empty or wrong — **Medium, Fixed** *(new)*
2.0.2 fails a corpus section that would run zero cases, instead of passing
silently. Three fixtures needed work:

- `.sdk/test/primary/preparePath.aontu` — was `basic: set: []`. Now 6 cases
  covering plain join, single part, dropped empties, slash normalisation, the
  nested moon-under-planet path, and the empty-parts case.
- `.sdk/test/primary/clean.aontu` — was `basic: set: []`. Now 7 cases pinning
  the pass-through contract across scalars, empty string, maps and arrays.
- `.sdk/test/primary/prepareAuth.aontu` — expected `' APIKEY01'`, encoding an
  old leading-space bug. The Solardemo spec declares no `securitySchemes`, so
  auth is inactive and the prefix is empty; a raw credential must go in with no
  leading space. Expectation corrected to `'APIKEY01'`.

---

## Summary

| Group | Fixed | Open |
| --- | --- | --- |
| A. Build & CI | 6 | 0 |
| B. `LogFeature` | 6 (B0–B5) | 0 |
| C. Generated docs | 6 (C1–C6) | 1 residual (field descriptions) |
| D. Packaging | 3 (D1, D2, D4) | 2 (D3, D5) |
| E. Generator & DX | 3 (E2, E8, E9) | 8 (E1, E3–E7, E10, E11) |
| F. Process | 1 | 0 |
| G. Coverage | 1 (G2) | 3 (G1, G3, G4) |
| **Total** | **26** | **14** |

### Remaining open items, by priority

1. **E9 / E10 / B0 — the `target add` trap.** Three separate hand-repairs
   (module path, feature templates, feature-test truncation) are undone by the
   next scaffold resync, silently. Every one exists because sdkgen hardcodes a
   decision that belongs in the model — specified for upstream in
   [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md),
   whose gaps 1–4 remove all three. E11 below covers the rest.
2. **E1** — stale-output pruning; caused two build breaks this session alone.
3. **D4 follow-up** — automate the `app/` audit so it stops recurring.
4. **D3, D5, E3–E7, G1** — low-severity, long-standing.
