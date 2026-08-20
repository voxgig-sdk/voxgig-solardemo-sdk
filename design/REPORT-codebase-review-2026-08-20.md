# Critical review — Solardemo SDK workspace

Reviewed: **2026-08-20**, against `main` at `591dbfc` (`@voxgig/sdkgen` **3.3.1**).

This is a fresh review of the working tree, not a restatement of
[REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) (last verified
2026-08-12 against sdkgen 2.0.2). That register is now partially stale;
section 6 maps old IDs onto current status.

Severity: **Critical** / **High** / **Medium** / **Low**.
Locus: **app** / **generator** / **generated** / **ci** / **docs**.

Generated trees (`ts/`, `go/`) are treated as symptoms. Fixes belong in
`.sdk/` (or `app/` for the companion server), then regenerate.

---

## 1. Verdict

The generator and published SDK identity are in better shape than the
August register describes. Publication pins, the slug revert to
`solardemo`, entity-returning operations, OIDC npm publish, and SHA-pinned
CI actions are real improvements.

The weak point is **contract coherence**. Four surfaces describe the same
API and disagree with each other:

| Surface | Create ID | Entity ops return | npm package | Go module |
| --- | --- | --- | --- | --- |
| OpenAPI | client-supplied, required | n/a | n/a | n/a |
| `app/` server | **server-generated**, `id` rejected on create | n/a | n/a | n/a |
| `ts/README.md` | client-supplied | **entity, throws** | `@voxgig-sdk/voxgig-solardemo` | correct |
| `ts/AGENTS.md` | n/a | **`Result`, no throw** | **`@voxgig-sdk/solardemo`** | n/a |
| `go/AGENTS.md` | n/a | `ok` map | n/a | **`voxgigsolardemosdk` + `replace`** |

An AI agent following `ts/AGENTS.md` installs a package that is not the
published name, and writes call sites that do not type-check against the
0.1.0 entity-returning contract. A human following the OpenAPI spec or
`validate.ts` cannot create a planet with a chosen id. Live SDK tests
against `app/` therefore cannot validate the create round-trip the
generated types require.

That is the review's main finding. Everything else is secondary.

---

## 2. What is working

These are not faint praise. They are the parts that should not be
disturbed while the contract issues are fixed.

- **Model as source of truth.** `model/sdk.aontu` documents *why* pins live
  at the root (so `target add` cannot wipe them). The npm package,
  repo path, author split (SDK vs Seneca provider), and provider output
  path are explicit project decisions, not generator accidents.
- **Publication identity in consumer READMEs.** Root `README.md` and
  `ts/README.md` install `@voxgig-sdk/voxgig-solardemo`. `go/go.mod` is
  `github.com/voxgig-sdk/voxgig-solardemo-sdk/go`. Class name is
  `SolardemoSDK` — the `VoxgigSolardemoSDK` rename was correctly reverted.
- **Entity-returning operations.** `PlanetEntity` / `MoonEntity` absorb the
  record and return `this`; `done()` throws on failure. `ts/README.md`
  documents this accurately, including `.data()`.
- **TS feature copy.** sdkgen 3.3.1 `srcFeatureExcludes` stops deactivated
  feature source from being restored on generate. Go uses `feature.trim`
  plus a truncated harness. The August “16 features come back on every
  generate” problem is mitigated.
- **Env-var hyphen bug (G4) is gone** in generated output. Slug is
  `solardemo`; tests consistently read `SOLARDEMO_*`.
- **CI supply chain.** Actions pinned to full-length SHAs, Node 24
  runtime, npm trusted publishing via OIDC, no `NPM_TOKEN`, tarball
  contents read from `package.json` rather than hardcoded class names.
- **App architecture.** Routes → handlers → stores → schemas is clean.
  Cascade delete of moons with a planet works. Moon *create* does check
  path `planet_id` against body. `npm audit` in `app/` is clean. Default
  bind is `localhost`.
- **In-tree generate is idempotent** for `ts/` and `go/` on an unchanged
  model (Seneca external pass aside).

---

## 3. Findings

### Critical

#### C1 — Companion server ignores client-supplied ids on create
**Locus:** app. **Files:** `app/src/handlers/planet.handlers.ts:33`,
`app/src/handlers/moon.handlers.ts:58`, `app/src/schemas/planet.schemas.ts:23-33`.

```ts
const planet = planetStore.create({ ...request.body, id: nid(8) })
```

Create schemas require `name`, `kind`, `diameter` and set
`additionalProperties: false`, so a client `id` is **rejected or
overwritten**. OpenAPI `POST /api/planet` uses the full `Planet` schema
with required `id`. Generated `PlanetCreateData.id` is required.
`app/validate.ts:58-74` asserts the created planet is `'pluto'`.

**Why it matters:** SDK create examples and live entity tests that send
`id: 'example_id'` cannot round-trip against this server. `validate.ts`
tests 3, 4, 11, 19, 20 fail downstream of the id mismatch. The advertised
“20 validation tests covering all API functionality” is currently red.

**Fix:** Accept the client `id` when present (OpenAPI/SDK contract), or
change OpenAPI + entity model + README + `validate.ts` together. Do not
leave the four surfaces split.

#### C2 — Per-SDK `AGENTS.md` documents a different product
**Locus:** generator. **Files:** `.sdk/src/AgentInfo.ts:26-42`,
`.sdk/src/cmp/ts/Agents_ts.ts:54-106`, generated `ts/AGENTS.md`, `go/AGENTS.md`.

`sdkNames()` re-derives identity instead of using sdkgen helpers
(`packageName()`, `goModule()`) and the model pins:

| | AGENTS.md | Actual |
| --- | --- | --- |
| npm | `@voxgig-sdk/solardemo` | `@voxgig-sdk/voxgig-solardemo` |
| Go module | `voxgigsolardemosdk` + local `replace` | `github.com/voxgig-sdk/voxgig-solardemo-sdk/go` |
| TS ops | return `{ ok, status, data }`; “do not throw” | return entity; **throw** on failure |
| TS error field | `result.error` | `result.err` |

`AgentInfo.ts` even comments “so the install + import snippets match the
actual published artifacts” — they do not. The 0.1.0 entity-returning
contract landed in READMEs and entity code; the Agents templates were not
updated.

**Why it matters:** `AGENTS.md` is the file coding agents read first. Wrong
install name plus a stale Result API will produce broken client code at
higher rate than a wrong README paragraph.

**Fix:** Drive names from `packageName(model, 'npm')` and
`goModule(model, 'go')`. Rewrite the Agents TS/Go templates to match
entity-return + throw (TS) and `(entity, error)` (Go).

#### C3 — Nested moon routes do not enforce parent `planet_id`
**Locus:** app. **Files:** `app/src/handlers/moon.handlers.ts:24-37, 62-93`.

`get` / `update` / `delete` look up by `moon_id` only. Create is the one
operation that checks `body.planet_id === params.planet_id`. Update will
happily reassign `planet_id` in the body.

Consequence: `GET /api/planet/mars/moon/luna` succeeds if luna exists
under earth; `DELETE /api/planet/mars/moon/luna` deletes it. The SDK model
requires both ids for moon load/update/remove; the server treats the
parent path as decoration.

**Fix:** 404 when `moon.planet_id !== params.planet_id`. Reject
`planet_id` changes on update, or treat them as an explicit move with
validation.

---

### High

#### H1 — Live direct tests cannot fail (G3, still open)
**Locus:** generator. **Files:** `.sdk/src/cmp/ts/TestDirect_ts.ts:339-345`.

In live mode a non-2xx is a bare `return`, not `t.skip()` and not an
assertion. Comments say “Skip rather than fail”. Go emits `t.Skipf`.
sdkgen 3.3.1 has `liveStrict()`; this model does not set
`main: kit: test: live: strict: true`.

A green live run still mostly proves dispatch. Entity `basic` tests are
the only ones that notice ECONNREFUSED. Combined with C1, even those
cannot prove create.

#### H2 — CI never regenerates, never tests `app/`
**Locus:** ci. **File:** `.github/workflows/ci.yml`.

Jobs: `.sdk` **build only** (no `generate`, no `git diff --exit-code`),
`ts` build+test, `go` build+test. Missing:

- `npm run generate` + dirty-tree check (the golden rule in root
  `AGENTS.md`)
- `app` unit/integration tests
- `app` `validate` / `validate:full`

Hand-edits in `ts/` or `go/`, or a broken app, merge to `main` unnoticed.
The Seneca generate error (`mkdir '/seneca/solardemo-provider'`) would
also be invisible because generate is not run.

#### H3 — Seneca provider generate fails on a flat clone
**Locus:** generator. **File:** `.sdk/model/sdk.aontu:72`.

`output.path: '../../seneca/solardemo-provider'` assumes
`~/Projects/voxgig-sdk/<this repo>` beside `~/Projects/seneca/`. In this
workspace that resolves to `/seneca/solardemo-provider` (`EACCES`).
In-tree `ts/`/`go/` still write; `npm run generate` logs an error.

Documented on purpose. Still means “generate” is not a portable command,
and CI (if it ever ran generate) would fail or skip the provider silently
depending on error handling.

#### H4 — `SECURITY.md` is linked and absent
**Locus:** docs. **File:** `README.md:217-220`.

Root README: “See [SECURITY.md](SECURITY.md)”. No such file. Publish
workflow comments also point at `design/PUBLISHING.md`, which does not
exist either.

#### H5 — Go version unset; docs say 1.23, `go.mod` says 1.21
**Locus:** generator. **Files:** `.sdk/model/target/go.aontu` (no
`goversion`), `go/go.mod:3`, root `AGENTS.md:26`.

August report A2 claimed `module.goversion: '1.23'` was set. It is empty;
sdkgen defaults to 1.21. CI reads `go.mod`, so runners use 1.21. The CI
comment still talks about 1.23 / `log/slog`.

#### H6 — Planet README “API path” is `/forbid`, not `/api/planet`
**Locus:** generator. **Files:** `.sdk/src/cmp/ts/ReadmeModel_ts.ts:167-170`,
`ts/README.md:364`.

Planet `create` has three points (forbid, terraform, plain create). The
README takes `points[0]`. `AgentInfo.primaryPoint()` already skips
`$action` points; `ReadmeModel` does not use it.

---

### Medium

#### M1 — Unauthenticated `/debug` dumps the whole store
**Locus:** app. **File:** `app/src/routes/index.ts:41-48`.

Not in OpenAPI. No env guard. Harmless on `HOST=localhost`; a footgun if
someone sets `HOST=0.0.0.0`.

#### M2 — `DATA_PATH` is documented and unused
**Locus:** app. **Files:** `app/src/config.ts:9-11`, `app/src/server.ts:41`.

Config reads `process.env.DATA_PATH`; `build()` hardcodes
`../../solar.data.json`.

#### M3 — `Config.fragment.ts` is a named-literal fork
**Locus:** generator. **File:** `.sdk/src/cmp/ts/fragment/Config.fragment.ts:22,32`.

Stock placeholders are `$$const.Name$$` and
`$$main.kit.info.servers.0.url$$`. This repo hardcodes `'Solardemo'` and
`'http://localhost:8901'`. They happen to match today.

`MakeOptionsUtility` still defaults `base` to `http://localhost:8000`
(`ts/src/utility/MakeOptionsUtility.ts:47`; same in Go). Merged options
pick up Config’s 8901, so runtime is correct; the fallback is a trap for
anyone reading the utility in isolation.

#### M4 — OpenAPI is thinner than the server
**Locus:** app / model. **File:** `app/def/` and `.sdk/def/` (identical
copies).

Missing: 4xx responses, `terraformState` / `forbidState` / `forbidReason`
on Planet, `/debug`, error schema. Entity model then *widens* Planet with
`forbid`, `ok`, `start`, `state`, `stop`, `why` from action payloads —
so `PlanetCreateData` includes terraform/forbid fields on the core
create type (`ts/src/SolardemoTypes.ts:76-93`).

Two copies of the YAML, no check they stay in sync. They match today.

#### M5 — Error envelope is inconsistent
**Locus:** app. **File:** `app/src/server.ts:20-38`.

Ajv hits the `statusCode` branch (`error: err.name` → `"Error"`). Custom
`ValidationError` → `"ValidationError"`. README documents
`"Validation Error"`. The `'validation' in err` branch looks dead.

#### M6 — README surface claims (REPL, CLI, MCP)
**Locus:** generated docs. **Files:** `README.md:9`, `ts/README.md:12-13`.

Stock `ReadmeTop` advertises surfaces this repo does not ship. The
Surfaces table two screens later lists only `ts/` and `go/`.

#### M7 — LICENSE copyright split
**Locus:** docs. Root `LICENSE`: `Copyright (c) 2025 voxgig-sdk`.
`ts/LICENSE` and `go/LICENSE`: `Copyright (c) 2026 Voxgig`.

#### M8 — `.claude/settings.local.json` is tracked
**Locus:** docs. Root and `app/`. Permission allow-lists only, no secrets
today. `.local` implies machine-local; `.gitignore` does not exclude
`.claude/`.

#### M9 — No Go release workflow; `go/VERSION` is `0.0.1`
**Locus:** ci. TS publishes on `ts/v*` tags. Go documents `go get …@latest`
via `go/vX.Y.Z`. Makefile `publish` pushes tags and **explicitly does not
run tests**. TS SDK is `0.1.0`; Go module file still says `0.0.1`.

#### M10 — `publish-ts.yml` does not strip `.env.local`
**Locus:** ci. CI does (`ci.yml:57-59`); publish runs `npm test` without
that step.

#### M11 — App integration tests share one mutable server
**Locus:** app. Single `build()` in `before()`; terraform/forbid/create
mutate seed data. Passing today, order-fragile.

#### M12 — Empty primary test corpus sections
**Locus:** generator. G2 filled `preparePath` / `clean` / `prepareAuth`.
At least seven other `.sdk/test/primary/*.aontu` files still have
`basic: set: []`. `test-model` passes those silently (sdkgen 3.3.1 fails
a *section* with zero cases; empty `set` inside a named section may still
slip through — confirm before closing).

---

### Low

| ID | Issue |
| --- | --- |
| L1 | `ts/package.json` has no trailing newline (E6). |
| L2 | Entity field Description columns blank — OpenAPI has no property descriptions. |
| L3 | Agents dispatch hand-wired in `.sdk/src/Root.ts` (`if (target.name === 'ts')`). |
| L4 | `app/AGENTS.md` facts hardcoded in `.sdk/src/Agents.ts`. |
| L5 | `.sdk/package.json` floats on `>=` ranges (D5) — how the toolchain sat two majors behind. |
| L6 | `@types/node` `^25` in TS SDK vs `^24` in app / seneca-provider. |
| L7 | Go `core` / `entity` / `feature` / `utility` have no `_test.go` (G1). Coverage lives in `go/test`. |
| L8 | `.sdk/src/DocStaticRoot.ts` is a commented stub. |
| L9 | No CORS on `app/` — Node tests fine; browser demos will fail. |
| L10 | 500 handler returns `err.message`. Fine for a test stub. |
| L11 | No health/ready endpoint or graceful shutdown. |
| L12 | `exists.test.ts` `await`s synchronous `SolardemoSDK.test()`. |
| L13 | `validate:full` uses `sleep 3` + PID file; races on `EADDRINUSE`. |
| L14 | App `LOG_LEVEL` default is `error`; README says `info`. |
| L15 | Weak field validation (empty `kind`, negative `diameter`). Acceptable for a stub. |
| L16 | `jostraca` `fs.F_OK` deprecation (E7) — not re-verified this pass. |
| L17 | Committed `ts/dist` and `ts/dist-test` — intentional for clone-and-test, noisy diffs. |
| L18 | Root `.gitignore` ignores `dist` globally; generated SDKs force-add it. |

---

## 4. Architecture notes (not defects)

**Planet actions are extra `create` points.** `/terraform` and `/forbid`
are not first-class SDK methods. Callers pass `$action: 'terraform' | 'forbid'`
on `Planet().create()`. That is a generator convention, but it is how
action fields leaked onto `PlanetCreateData` (M4). Worth a sentence in
the Planet README; the current “API path: /forbid” (H6) is the worst
possible presentation of this.

**Auth is consistently absent.** OpenAPI has no `securitySchemes`; the
server has no auth middleware; the SDK still has apikey plumbing. The
server cannot exercise that plumbing. Fine if intentional.

**`app/` is not an SDK.** Correct. It is also the only implementation the
live tests can hit, so its contract *is* the SDK’s contract for this
repo. Treating it as “just a stub” is how C1 survived.

**Seneca provider belongs in another repo.** Correct. Generation from
here is a convenience that encodes a checkout layout (H3).

---

## 5. Recommended order of work

Do these in `.sdk/` or `app/`, then regenerate. Do not hand-edit `ts/` or
`go/`.

1. **C2 — Agents identity + entity-return docs.** Highest leverage for
   anyone (or any agent) consuming the SDK. Use `packageName` / `goModule`;
   rewrite the operation examples.
2. **C1 — create-id contract.** Pick one semantics and align OpenAPI,
   Fastify schemas, handlers, entity model, `validate.ts`. Prefer
   client-supplied ids: that is what the SDK types already require.
3. **C3 — moon parent enforcement.** Cheap, and it makes nested URLs mean
   something.
4. **H2 — CI generate-diff + `app` test job.** Prevents the next silent
   drift. Guard Seneca with `active: false` in CI or a writable output
   path (H3).
5. **H1 — `test.live.strict: true`** once the app honours create ids, so
   live runs become evidence.
6. **H4, H5, H6, M2, M3** — SECURITY.md, goversion, primaryPoint in
   ReadmeModel, wire `DATA_PATH`, restore Config.fragment placeholders.
7. **M9** — either automate Go tags or stop advertising `go get @latest`
   until `go/VERSION` matches the TS 0.1.0 line.

---

## 6. Reconciliation with the August 12 register

| ID | Aug 12 | Now |
| --- | --- | --- |
| A1–A6 | Fixed | Still fixed (A2 Go 1.23 **regressed** → H5) |
| B0–B5 | Fixed by removing LogFeature | Still gone; TS generate no longer restores extra features |
| C1–C6 | Fixed | Residual blank descriptions (L2); **new** wrong Planet API path (H6) |
| D1, D2, D4 | Fixed | Still fixed |
| D3, D5 | Open | Still open (L5, L6) |
| E1 | Open | Still open (no stale-output prune) |
| E3–E7 | Open | Still open |
| E8 | Fixed | Still fixed |
| E9 | Fixed (no forks) | **Partially regressed** — AgentInfo, Agents, Config.fragment, Root, BuildSDK are custom |
| E10 | Upstream workaround | Still truncated Go feature harness |
| E11 dryrun | Upstream | **Fixed** in sdkgen 3.3.1 |
| G1 | Open | Still open (L7) |
| G2 | Fixed | Residual empty corpus files (M12) |
| G3 | Open | **Still open** (H1); `liveStrict()` exists, unused |
| G4 | Open / High | **Fixed** in generated output (slug `solardemo`) |
| — | — | **New:** C1, C2, C3, H2–H6, M1–M11 |

Keep [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) as historical
context. Treat **this document** as the current register until the next
review.

---

## 7. Verification performed

Read, not assumed:

- `.sdk/model/sdk.aontu`, `target/go.aontu`, `AgentInfo.ts`, `Agents_ts.ts`,
  `ReadmeModel_ts.ts`, `TestDirect_ts.ts`, `Config.fragment.ts`
- `app/src/handlers/*`, `schemas/*`, `server.ts`, `routes/index.ts`,
  `config.ts`, `validate.ts`, OpenAPI YAML (both copies identical)
- `ts/package.json`, `ts/AGENTS.md`, `ts/README.md`, `PlanetEntity.ts`,
  `SolardemoTypes.ts`
- `go/go.mod`, `go/AGENTS.md`, `go/VERSION`
- `.github/workflows/ci.yml`, `publish-ts.yml`
- Root `README.md`, `LICENSE`, `.gitignore`, `.claude/settings.local.json`

Not run this pass (environment still settling): full `npm test` matrices,
live `validate:full`, consecutive generate diff. Claims about test
leniency and create-id behaviour are from source, not from a live
falsification this session. C1 create-id overwrite is unambiguous in
source; a live POST is not required to confirm it.
