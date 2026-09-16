# Critical review — Solardemo SDK workspace

Reviewed: **2026-09-16**, against `main` at `5ba7623` (`@voxgig/sdkgen` **≥4.8.1**,
`@voxgig/apidef` **≥8.10.0**).

This is a re-review of the tree after the August 20 findings were worked
through and the repo grew from two SDK targets to twenty-six. It does not
replace the narrative in
[REPORT-codebase-review-2026-08-20.md](REPORT-codebase-review-2026-08-20.md);
that file is the record of what was found and (mostly) fixed. This file is
the current register.

Severity: **Critical** / **High** / **Medium** / **Low**.
Locus: **model** / **app** / **generator** / **generated** / **ci** / **docs**.

Generated trees are symptoms. Fixes belong in `.sdk/model/` (especially
`project.aon`) or `app/`, then `npm run generate`.

---

## 1. Verdict

The companion server is in good shape. C1 (create ids) and C3 (moon parent
enforcement) still hold, OpenAPI copies are byte-identical and CI-guarded,
`/debug` is gated, `DATA_PATH` works, `validate.ts` is in CI, and generate
is drift-gated. That half of the August review stuck.

The other half did not survive the sdkgen 4.x / `.aon` migration.

**Project identity lives in a file the generate pipeline does not read.**
`.sdk/model/sdk-base.aontu` still pins the published npm name
(`@voxgig-sdk/voxgig-solardemo`), the real GitHub path
(`voxgig-sdk/voxgig-solardemo-sdk`), Go 1.23, and `test.live.strict: true`.
The generate entry point is now `.sdk/model/sdk.aon`, which includes
`project.aon` (versions + `secrets: active`) and **does not include**
`sdk-base.aontu`. Only `provider.aontu` still includes the base, and
`npm run generate-provider` does not exist.

Consequence: generated manifests, READMEs, homepage/bugs URLs, Go module
path, `go.mod` language version, and live-test policy all follow sdkgen
*derivation* (`solardemo-sdk`, `@voxgig-sdk/solardemo`, Go 1.21, lenient
live tests). Publishing docs and OIDC trust still name the *pinned*
identity. Those two stories cannot both be true.

The 26-language expansion is real and mostly coherent. It also multiplied
stock generator bugs (Planet “API path” is `/forbid` in **every** SDK
README) and left CI with a haskell job for a language this repo does not
generate, while `lean/` and `py-data/` have no jobs at all.

---

## 2. What improved since August 20

- **App contract.** Client-supplied create ids, 409 on conflict, moon
  parent 404s, one error envelope, isolated integration tests, `DATA_PATH`,
  `/debug` gated on bind address. PR #32 aligned Planet response fields
  (`terraformState`, `forbidState`, `forbidReason`) with OpenAPI.
- **CI golden rule restored.** `sdk-generate` (drift + untracked +
  “must not write `../../seneca`”) and `app-build-test` (typecheck, tests,
  `validate.ts` against a started server) are blocking again after #24
  dropped them.
- **Fleet generation.** 26 targets from one model; root `AGENTS.md` and
  Surfaces table list them; `go-cli` and `go-mcp` exist (the August “REPL /
  MCP overclaim” is no longer a fiction, though MCP still overclaims
  *coverage*).
- **Secrets as a generated feature.** Vendored sekreto under
  `feature/secrets/` on ts/go/py, applicability-gated, default
  `options.active: false`. The `ext/` prototype is gone.
- **Lockstep 0.1.0** in `project.aon` across targets. `go/VERSION` is
  0.1.0, matching ts.
- **SECURITY.md and PUBLISHING.md exist.** (Their *contents* now disagree
  with generated identity — see R1.)

---

## 3. The meta-defect

### R0 — `sdk-base.aontu` is not on the generate graph
**Locus:** model. **Severity:** Critical (process).

sdkgen 4.x renamed the entry point `sdk.aontu` → `sdk.aon` and introduced
`project.aon` as the file “created once and never overwritten.” That is
exactly the role `sdk-base.aontu` was invented for in August: pins that
`target add` must not wipe.

`sdk.aon` includes `project.aon` last. `project.aon` carries per-target
`publish.version: '0.1.0'` and `feature.secrets.active: true`. It does
**not** carry:

| Pin in `sdk-base.aontu` | Effective `sdk.json` |
| --- | --- |
| `repo.path: 'voxgig-sdk/voxgig-solardemo-sdk'` | `"path": ""` |
| ts registry `package: '@voxgig-sdk/voxgig-solardemo'`, `active: true` | `"package": ""`, `state: pending` |
| `test.live.strict: true` | `"strict": false` |
| `go.module.goversion: '1.23'` | default **1.21** |
| seneca `output.path: '../../seneca/…'`, version `0.1.3` | in-tree `seneca-provider/`, version `0.1.0` |

`provider.aontu` still includes `sdk-base.aontu` and documents
`npm run generate-provider`. That script is not in `.sdk/package.json`.
The in-tree provider is produced by ordinary `generate` because the
target is `active: true` in the compiled model.

**Fix:** Move the pins into `project.aon` (that is now the overlay),
delete or demote `sdk-base.aontu` so it cannot lie, and either restore
`generate-provider` *or* accept in-tree seneca and update
`design/README.md`. Do not leave three files that each believe they own
identity.

This single omission is the parent of R1–R4 below.

---

## 4. Findings

### Critical / High

#### R1 — Published identity vs generated identity
**Locus:** model → generated + ci + docs.

| Surface | Says |
| --- | --- |
| Real git remote | `github.com/voxgig-sdk/voxgig-solardemo-sdk` |
| `ts/package.json` name | `@voxgig-sdk/solardemo` |
| `ts/package.json` homepage / bugs | `github.com/voxgig-sdk/solardemo-sdk` (**404**) |
| `go/go.mod` | `github.com/voxgig-sdk/solardemo-sdk/go` |
| Root README / ts README install | `@voxgig-sdk/solardemo`, “publish pending” |
| `design/PUBLISHING.md` | `@voxgig-sdk/voxgig-solardemo` on npm; Go module under `voxgig-solardemo-sdk` |
| `publish-ts.yml` OIDC trust | `@voxgig-sdk/voxgig-solardemo` **and**
  `--repository voxgig-sdk/voxgig-solardemo-sdk` |
| `SECURITY.md` issue tracker | `github.com/voxgig-sdk/solardemo-sdk/issues` (**404**) |
| `seneca-provider/package.json` | depends on `@voxgig-sdk/solardemo` |

Pushing `ts/v0.1.0` publishes whatever `package.json` names, against an
OIDC trust registered for a different name. Consumers following README
bugs URLs file issues on a repo that does not exist.

August C2 (wrong name in `AGENTS.md`) is a different shape of the same
bug. sdkgen 4.x replaced per-target consumer `AGENTS.md` with a generate
guide (`AgentGuide`). The install name now lives in README/`package.json`,
where it is consistently *derived* — and consistently not the GitHub repo
or the npm trust.

**Fix:** One decision, in `project.aon`: either pin the historical npm
name and `repo.path`, or accept derivation and change OIDC trust,
PUBLISHING.md, and (if possible) the GitHub repo. Mixing them is the
failure mode.

#### R2 — Live tests are lenient again; CI does not run them (H1)
**Locus:** model + ci.

`sdk-base.aontu:153` still says `strict: true`. Compiled model is
`strict: false`. Generated
`ts/test/entity/planet/PlanetDirect.test.ts:84-90` is again a bare
`return` on non-2xx in live mode.

The live ts/go job added in `282d309` is gone. `ci.yml` header: “Live API
verification is NOT run here.” `app-build-test` still runs `validate.ts`,
which is necessary and not sufficient — it does not prove the SDKs
round-trip.

A green `npm test` / `go test` is offline. A green CI run is offline plus
the companion server’s own HTTP suite.

#### R3 — Go version pin lost (H5)
**Locus:** model + ci.

`go/go.mod` is `go 1.21`. CI `go` job hardcodes `go-version: '1.24'`.
`publish-go.yml` uses `go-version-file: go/go.mod` → **1.21** at release.
`go-mcp` requires 1.25. Three numbers, none of them the model’s `'1.23'`.

#### R4 — Planet README path is `/forbid` in every language (H6, multiplied)
**Locus:** generator.

Every `ReadmeModel_<lang>.ts` takes `points[0]`. Planet `create` declares
forbid, then terraform, then plain create. Result, 20 times:

```
API path: `/api/planet/{planet_id}/forbid`
```

August fixed this in the TS ReadmeModel with `primaryPoint()`. The
all-targets resync restored stock `points[0]` everywhere. This is now an
**upstream** sdkgen defect with a 20× blast radius; a local fork of one
ReadmeModel is the wrong fight.

---

### Medium

#### R5 — `js/README.md` install line is a different package
```js
npm install solardemo
```
Tutorial imports `@voxgig-sdk/solardemo-js`. Stock ReadmeIntro vs
packageName split; same class of bug as August C1/C2, now on the JS
target.

#### R6 — MCP “every operation” is list and load
**Locus:** generated docs vs `go-mcp/tools.go`.

Root README: “The generated MCP server exposes every operation in this
SDK as an MCP tool.” `registerTools` adds `solardemo_list` and
`solardemo_load` only. CLI/REPL existence is real; MCP completeness is
not.

#### R7 — CI coverage holes in the new fleet
- **haskell** job, `continue-on-error`, `hashFiles('haskell/Makefile')` —
  there is no `haskell/` and no haskell target. Permanent skip.
- **lean/** and **py-data/** exist, are in the root Makefile `TARGETS`,
  and have **no CI jobs**.
- Advisory jobs (rust, zig, java, …) are allowed to stay red
  (`continue-on-error: true`). The workflow comment says not to leave
  them advisory indefinitely.
- **go-cli / go-mcp** blocking jobs `go test ./...` with no `_test.go`
  files — compile/vet only.
- Comment still says “22 language targets”; the model has 26.

#### R8 — REFERENCE advertises `secrets` on targets that do not ship it
ts/go/py generate secrets (sekreto). java, zig, and others have no
secrets source; their REFERENCE still lists the feature. Root
`AGENTS.md` says each feature is generated into every target — false.

#### R9 — `validate.ts` still skips moon parent negatives
Wrong-parent GET/PUT/DELETE are covered in
`app/test/integration/moon.integration.test.ts` (CI runs it). The 20-case
`validate.ts` script operators actually look at does not. Same class as
August: a named suite that can stay green while the interesting contract
is only in another file.

#### R10 — CHANGELOG is still `[0.0.1]`
Every generated manifest is `0.1.0`. The changelog understates the line
and still describes “six languages plus CLI and MCP.”

#### R11 — OpenAPI vs server, remaining nits (post–PR #32)
- Create `id` optional on the server (superset); OpenAPI requires it.
  SDK types require it, so SDK↔app is fine.
- `terraformState: complete` is in the spec; the handler only toggles
  `idle` ↔ `terraforming`.
- Forbid body: server requires `forbid`; OpenAPI does not.
- Error responses still mostly undocumented in OpenAPI.

#### R12 — Companion app cannot exercise `secrets` or `apikey`
OpenAPI `auth: false`; app has no Authorization handling. Secrets tests
are client-side only. Fine if intentional; do not read a green secrets
suite as “the API authenticated.”

---

### Low

| ID | Issue |
| --- | --- |
| R13 | `.sdk/package.json` still floats on `>=` ranges (August L5). How the toolchain jumped 3.3.1 → 4.8.1 without a pin in this file. |
| R14 | Dual extension era: `sdk-base.aontu` / `provider.aontu` beside a `.aon` tree. Easy to edit the wrong file. |
| R15 | `project.aon` comment “secrets ACTIVE (proof state)” vs runtime `options.active: false`. |
| R16 | Senecaprovider in-tree `0.1.0` vs `sdk-base` `0.1.3`. |
| R17 | `design/README.md` still describes 3.3.1, `generate-provider`, and seneca `active: false`. |
| R18 | Root LICENSE vs generated LICENSE years — not re-litigated; check after next `target add`. |
| R19 | No health endpoint on `app/`; CORS absent. Documented as test-server scope. |

---

## 5. August 20 register — hold / regress / evolve

| ID | Aug disposition | 2026-09-16 |
| --- | --- | --- |
| C1 create-id | Fixed | **Holds** |
| C2 AGENTS identity + Result API | Fixed | **Evolved / partial regress.** Result-API docs are gone (AgentGuide). Identity pins are not applied (R0/R1). |
| C3 moon parent | Fixed | **Holds** |
| H1 live strict + live CI job | Fixed | **Regressed** (R2) |
| H2 generate drift + app CI | Fixed, then dropped by #24, restored by #27 | **Holds** for drift + app. Live SDK job **not** restored. |
| H3 seneca escapes repo | Fixed (`active: false` + generate-provider) | **Evolved.** In-tree generate; CI still guards `../../seneca`. Docs stale. |
| H4 SECURITY.md missing | Fixed | **Holds** (file exists). Tracker URL wrong (R1). |
| H5 Go 1.23 | Fixed | **Regressed** (R3) |
| H6 Planet API path | Fixed in TS ReadmeModel | **Regressed, ×20** (R4) |
| M1–M3, M5, M7–M11 | Fixed | **Hold** (spot-checked) |
| M4 OpenAPI copies | Fixed + defsync test | **Holds**; PR #32 filled Planet extra fields |
| M6 README REPL/MCP | Partial | **Evolved.** Surfaces exist; MCP completeness still wrong (R6) |
| M12 empty corpus | Partial | Not re-audited this pass |
| L5 unpinned `.sdk` deps | Marked fixed in Aug status table | **Still open** (R13) |

---

## 6. Recommended order of work

1. **R0 / R1 — identity.** Decide pin vs derive. Put the decision in
   `project.aon`. Regenerate. Align `publish-ts.yml`, `PUBLISHING.md`,
   `SECURITY.md`, seneca dependency name. This unblocks honest publishing.
2. **R2 — live strict.** Set `main: kit: test: live: strict: true` in
   `project.aon` (the August comment still explains why). Put a live ts/go
   job back in CI, with `-count=1` on Go. `app-build-test` is not a
   substitute.
3. **R3 — `goversion`** in `project.aon`; stop hardcoding 1.24 in CI
   (or document why CI runs newer than `go.mod`).
4. **R4 — upstream** `primaryPoint()` (or equivalent) in sdkgen
   `ReadmeModel_*`. Do not fork twenty copies.
5. **R5, R6, R10, R17** — js install line, MCP wording, CHANGELOG,
   `design/README.md`.
6. **R7** — delete haskell job or add the target; add lean/py-data or
   drop them from `TARGETS`; start promoting advisory jobs that are
   actually green.
7. **R9** — two wrong-parent cases in `validate.ts`.

Do not hand-edit `ts/`, `go/`, or any other language directory.

---

## 7. Verification

Read, not assumed:

- `.sdk/model/sdk.aon`, `project.aon`, `sdk-base.aontu`, `provider.aontu`
- `ts/package.json`, `ts/AGENTS.md`, `ts/README.md`, `PlanetDirect.test.ts`
- `go/go.mod`, `go/VERSION`, `go-mcp/tools.go`
- `app/src/handlers/{planet,moon}.handlers.ts`
- `.github/workflows/ci.yml`, `publish-ts.yml`
- `SECURITY.md`, `design/PUBLISHING.md`, root `README.md`
- Grep: Planet `API path: …/forbid` in 20 READMEs
- `git grep` for `@"sdk-base` → only `provider.aontu`

Not re-run this pass: full 26-language `make test` matrix, npm publish
dry-run, live SDK suite against `app/`. Generate idempotency was checked
by a parallel pass (`npm run generate` → no diff) and is treated as
holding.

The identity split (R1) does not need a live publish to confirm: the
tarball name is `package.json` `name`, and the workflow comment names a
different package.
