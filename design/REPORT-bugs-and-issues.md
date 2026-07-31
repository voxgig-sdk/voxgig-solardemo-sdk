# Report: Bugs & Issues Found

Date: 2026-06-08
Status of this document: **record only — no fixes applied.**

A consolidated catalogue of bugs, defects and issues discovered while updating
dependencies, rebuilding/testing the SDKs, reviewing the code, and extending the
`.sdk` generator with agent docs. Items already fixed during the
dependency-update work are included for the record and marked accordingly;
everything else is **open**.

Severity: **High** / **Medium** / **Low**.
Status: **Fixed** (this session) / **Open**.

> Companion document: `design/REPORT-agent-docs-generation.md` covers the
> doc-generation DX context in more depth.

---

## A. Build & CI regressions (were breaking `main`)

CI was red on `main` before this work: PRs #2/#3 regenerated the SDKs and left
generated output inconsistent with the templates/model.

| ID | Severity | Status | Issue |
| --- | --- | --- | --- |
| A1 | High | Fixed | **TS `pino` deps dropped.** `ts/src/feature/log/LogFeature.ts` imports `pino` / `pino-pretty`, but a regeneration emptied `dependencies` in `ts/package.json`, breaking `tsc --build src`. Root cause: the model never declared them. |
| A2 | High | Fixed | **Go `log/slog` vs `go 1.20`.** `go/feature/log_feature.go` imports `log/slog` (requires Go ≥ 1.21) but `go.mod` (hardcoded in `Package_go.ts`) and CI pinned `1.20`, so `go build` failed. |
| A3 | High | Fixed | **Go `ctx.Spec.Name` does not exist.** `log_feature.go:120` referenced `ctx.Spec.Name`; `core.Spec` has no `Name` field → `go build` failed. |
| A4 | High | Fixed | **Filename casing collision.** `ts/src/utility/` contained both `FeatureHookUtility.ts` and `FeaturehookUtility.ts` (TS1261). The template was named lowercase-`h` while `Utility.ts` imports capital-`H`; a stale duplicate output file lingered. |
| A5 | Medium | Fixed | **TS 6 type resolution.** TS 6 no longer auto-includes all `@types/*` globally; the test build failed to resolve `process`, `__dirname`, `node:*`. Fixed by adding explicit `"types": ["node"]` to the src/test tsconfig templates. |
| A6 | High | Fixed | **App dependency vulnerabilities.** `fast-uri` (high — path traversal) and `ajv` (moderate — ReDoS), transitive via `fastify`. Resolved with `npm audit fix`. |

---

## B. Latent correctness bugs in generated SDK code (open)

These originate in the vendored sdkgen templates (`.sdk/tm/...`), so the durable
fix belongs upstream. None block build/test, so none were changed.

### B1 — `LogFeature`: caller-supplied logger is silently ignored — **High, Open**
`ts/src/feature/log/LogFeature.ts` (template `.sdk/tm/ts/src/feature/log/LogFeature.ts`), `init()`:

```ts
let logger = this._options.logger
if (null == logger) {
  ...
  this._logger = logger     // only assigned when logger was NOT provided
}
```
If a caller passes `options.logger`, it is never stored to `this._logger`, so no
logging happens. The `this._logger = logger` assignment should sit outside the
`if (null == logger)` block.

### B2 — `active` default differs across targets — **Medium, Open**
TS `LogFeature.init()` does `this.active = options.active` (omitted → `undefined`
→ logging off). The Go `LogFeature` keeps its constructor default `true` unless
`active` is explicitly provided. Same input, opposite behaviour.

### B3 — TS `LogFeature` missing the `SetMatch` hook — **Medium, Open**
The Go `LogFeature` implements `SetMatch`; the TS one only implements `GetMatch`.
Inconsistent hook coverage between targets.

### B4 — `_loghook` `level` parameter is dead — **Low, Open**
`_loghook(this, hook, ctx, level)` — every caller passes 2 args, so `level` is
always `undefined` and defaults to `'info'`. The parameter is effectively unused.

### B5 — TS vs Go "spec" log semantics differ — **Low, Open**
TS logs the whole `ctx.spec` / `ctx.op` objects; Go logs single fields
(`ctx.Op.Name`, and `ctx.Spec.Path` after the A3 fix). Minor cross-target
divergence in what gets logged.

---

## C. Generated documentation bugs (open)

The README generator emits inaccurate docs. Locations are verified.

### C1 — Wrong install / import name — **High, Open**
- `.sdk/src/cmp/ts/ReadmeInstall_ts.ts:10` → `npm install ${target.module.name}`
- `.sdk/src/cmp/ts/ReadmeQuick_ts.ts:27` and `ReadmeTopQuick_ts.ts:18` → `import { ...SDK } from '${target.module.name}'`

`target.module.name` is `solardemo`, but the actual published package (per
`Package_ts.ts`) is `@voxgig-sdk/solardemo`. The generated `ts/README.md`
therefore tells users to `npm install solardemo` and import from `'solardemo'` —
both wrong. (The new `AgentInfo.sdkNames` computes the correct name.)

### C2 — Empty entity field tables — **High, Open**
- `.sdk/src/cmp/ts/ReadmeModel_ts.ts:128` → `const fields = ent.field || []`
- `.sdk/src/cmp/ts/ReadmeQuick_ts.ts:59`, `ReadmeTopQuick_ts.ts:43` → `(nestedEntity.field || [])`
- `.sdk/src/cmp/go/ReadmeModel_go.ts` — same pattern

The model stores entity fields under `ent.fields` (plural; see
`model/entity/planet.aontu`), but these read `ent.field` (singular), so field
tables and create-example bodies render **empty**. (`AgentInfo.entityInfo` reads
`fields` and produces full tables.)

### C3 — Empty "API path" — **Medium, Open**
`.sdk/src/cmp/ts/ReadmeModel_ts.ts:149` emits `` API path: `${path}` `` but the
value is empty: there is no entity-level path — paths live per operation point
(`op.points[].orig`). The reference renders `` API path: `` `` for every entity.

### C4 — Empty create examples — **Low, Open**
A consequence of C2: generated `client.X().create({ })` snippets contain no
fields because field data is not read.

---

## D. Packaging & consumption limitations (open)

### D1 — Go module is not `go get`-able — **High, Open**
`go/go.mod` declares module `voxgigsolardemosdk` (no remote host) and uses a
local `replace github.com/voxgig/struct => ./utility/struct`. External consumers
cannot `go get` it, yet the generated `go/README.md` prints
`go get voxgigsolardemosdk`. Consumable only via a `replace` directive pointing at
the SDK source. Recommend a real module path (e.g.
`github.com/voxgig-sdk/voxgig-solardemo-sdk/go`) and a published/vendored `struct`.

### D2 — `pino` is a hard prod dependency for all consumers — **Medium, Open**
`ts/package.json` lists `pino` + `pino-pretty` under `dependencies`, so every
consumer pulls a full logging framework even if they never enable logging. The Go
SDK uses zero-dependency stdlib `slog`. Worth a deliberate decision
(optional/peer dep, or a lighter default logger).

### D3 — `@types/node` major mismatch — **Low, Open**
`app/` uses `@types/node ^24` while the TS SDK uses `^25`, although everything
runs on Node 24 LTS. Harmless (separate installs) but inconsistent; the SDK could
reference Node 25 type surface not present at runtime.

---

## E. Generator robustness & authoring DX (open)

### E1 — No stale-output pruning — **Medium, Open**
Generation merges/adds files but never deletes outputs whose source template was
removed or renamed. This directly produced the A4 casing duplicate. A "clean the
target directory before generate" option would prevent this class of bug.

### E2 — Entity hierarchy missing from the model — **Medium, Open**
Moon is nested under Planet (paths `/api/planet/{planet_id}/moon/...`), but
`entity.ancestors` is empty. As a result the top-level `README.md` mermaid
diagram (`Top.ts`) renders **empty**, and "nested under" relationships cannot be
derived. (apidef should populate `ancestors`, or parent should be derivable from
path parts.)

### E3 — No hook to register custom per-target components — **Low, Open**
sdkgen's built-ins (`Main`, `Readme`, `Test`, `Entity`) auto-dispatch to
`cmp/<target>/X_<ext>.ts`, but a project cannot register a **new** per-target
component into that mechanism. The new `Agents` dispatch had to be wired manually
in `Root.ts` with an `if (target.name === ...)` branch — works, but does not
scale and duplicates sdkgen's internal dispatch.

### E4 — `app/` is outside the generation model — **Low, Open**
The test server in `app/` is hand-written and not a generation target. Emitting
`app/AGENTS.md` required the generator to write into a hand-written folder, and
app facts (Node 24, port 8901) had to be hardcoded in the generator rather than
modelled.

### E5 — Markdown authored via TS template literals — **Low, Open**
Doc components build markdown with TypeScript template strings, forcing escaping
of backticks and `${...}` inside fenced code blocks. A markdown-aware emit helper
or `.md` template-master files with placeholder substitution would be more
ergonomic and less error-prone.

### E6 — Generated `package.json` has no trailing newline — **Low, Open**
`Package_ts.ts` emits `JSON.stringify(...)` with no final newline (`\ No newline
at end of file`). Cosmetic; some tooling/linters flag it.

### E7 — `fs.F_OK` deprecation warning — **Low, Open**
Running `.sdk` model tests prints
`[DEP0176] DeprecationWarning: fs.F_OK is deprecated`, emitted from an upstream
dependency (jostraca / voxgig-model). Warning only.

---

## F. Process / environment

### F1 — CI workflow change cannot be pushed from this environment — **Medium, Open**
The required CI bump in `.github/workflows/ci.yml` (`go-version: '1.20' → '1.23'`,
needed so the runner can build the `go 1.23` module) was rejected by both
`git push` and the GitHub MCP for lack of `workflow` scope. The one-line change
is documented but **not yet applied on the remote**; without it the Go CI job
will fail.

---

## G. Test coverage observation

`go test ./...` exercises only the `voxgigsolardemosdk/test` package; `core`,
`entity`, `feature`, `utility` report `[no test files]`. The shared `struct`
suite drives most assertions, but the generated Go packages themselves have no
direct unit tests. Not a defect — a coverage gap to be aware of.

---

## Summary counts

- Fixed this session (build/CI): **6** (A1–A6).
- Open correctness bugs in generated code: **5** (B1–B5).
- Open documentation bugs: **4** (C1–C4).
- Open packaging/consumption limitations: **3** (D1–D3).
- Open generator/DX issues: **7** (E1–E7).
- Open process item: **1** (F1).

Highest-value open items: **C1/C2** (broken install name + empty field tables —
small, high-impact doc fixes), **D1** (Go not consumable), **B1** (logger bug),
**F1** (CI workflow bump), **E1/E2** (stale-output pruning + entity hierarchy).
