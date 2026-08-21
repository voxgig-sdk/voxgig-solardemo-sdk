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

## 0. Status — updated 2026-08-20, `main` at `27ffa87`

Every **Critical**, **High**, **Medium** and **Low** finding now has a
final disposition. The
findings below are left as written; each addressed one carries a
**Status** line naming the commit, so the analysis stays readable next to
what was done about it.

| ID | Status | Commit |
| --- | --- | --- |
| C1 create-id contract | **Fixed** | `95037bd` |
| C2 AGENTS.md identity + Result API | **Fixed** | `41ce29a` |
| C3 moon parent enforcement | **Fixed** | `95037bd` |
| H1 live tests cannot fail (G3) | **Fixed** | `246eaf4` + `282d309` |
| H2 CI never regenerates or tests `app/` | **Fixed** | `0b2da35` |
| H3 Seneca generate escapes the repo | **Fixed** | see below |
| H4 `SECURITY.md` linked and absent | **Fixed** | `SECURITY.md` + `design/PUBLISHING.md` |
| H5 Go version unset | **Fixed** | `41ce29a` |
| H6 Planet README API path | **Fixed** | `41ce29a` |
| M2 `DATA_PATH` documented and unused | **Fixed** | see below |
| M3 `Config.fragment.ts` literals | **Fixed** | `41ce29a` |
| M12 empty corpus sections | **Fixed** (1 promoted, 6 deferred with cause + a guard) | see below |
| M1 unauthenticated `/debug` | **Fixed** | `ed26ca9` |
| M4 OpenAPI thinner + two unsynced copies | **Fixed** (sync guarded; thinness recorded) | `4c677a2` |
| M5 inconsistent error envelope | **Fixed** | `ae1f34d` |
| M6 README surface claims | **Fixed** for `ts/` + `go/`; root README still says REPL until the sdkgen pin moves | `bbb488d` |
| M7 LICENSE copyright split | **Fixed** | `c99d0f2` |
| M8 `.claude/settings.local.json` tracked | **Fixed** | `c99d0f2` |
| M9 no Go release workflow; version drift | **Fixed** | `956e916` |
| M10 `publish-ts.yml` `.env.local` | **Fixed** (defence in depth) | `956e916` |
| M11 app tests share one server | **Fixed** | `ae1f34d` |
| L1, L13, L14 | **Fixed** | `c99d0f2`, `0ba4f68` |
| L3, L4, L7, L8, L12, L18 | **Fixed** | `fa93ea9`, `4610d64`, `bbb488d`, `4c677a2`, `ed26ca9` |
| L5, L6 | **Fixed** (toolchain pinned, types aligned) | `4c677a2` |
| L9, L10, L11, L15 | **Documented as deliberate** in `SECURITY.md` | `4c677a2` |
| L2 | **Upstream** — needs `apidef` to carry field descriptions | — |
| L16 `fs.F_OK` deprecation | **REGISTER WRONG** — does not reproduce | `4c677a2` |
| L17 committed `ts/dist` | **Won't fix** — intentional, and now un-ignored (L18) | — |

Everything else in sections 3 and 4 is untouched and still stands.

**What the fixes cost, measured rather than assumed.** Each was checked in
both directions, because several of these defects were *invisible to a
passing check* — which is the theme of this review:

- C1: `validate.ts` went 15/20 → **20/20**. The five failures were ids
  3, 4, 11, 19, 20 — exactly the ones named below. Reproduced by stashing
  the fix, not taken on trust.
- H2: `generate` on a clean checkout produces **zero drift**, and
  appending one line to `ts/src/SolardemoTypes.ts` makes the new gate
  fire.
- H1 + live job: with the server up, ts is 185 pass / 1 skip and go is
  ok; with the port closed, **three suites fail in each language**
  (`MoonDirect`, `MoonEntity`, `PlanetDirect`).

**Two traps found while fixing, worth keeping in mind for the rest:**

1. Setting `test.live.strict: true` alone made live runs red against a
   *healthy* server, because the TS strict branch reused the offline
   mock's fixture assertions (`data.id === 'direct01'`) against real
   data. Go had this right; TS was the outlier. Strict now asserts
   reachability and status, which is what H1 actually asks for.
2. The first Go live negative control **passed from cache** with the port
   closed — `go test` caches by input and reported `ok` without
   contacting the server. The live job pins `-count=1` for that reason.

App test coverage went 34 → 45 tests; CI went from 4 jobs to 5.

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

> **Resolved.** All four surfaces now agree: the server honours client
> ids (C1, `95037bd`) and `AGENTS.md` is driven from the model pins and
> documents entity-return + throw (C2, `41ce29a`). The table above is
> kept as the record of what was found, not as current state.

---

## 2. What is working

These are not faint praise. They are the parts that should not be
disturbed while the contract issues are fixed.

- **Model as source of truth.** `model/sdk-base.aontu` documents *why* pins live
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

**Status: FIXED** `95037bd`. Client ids honoured, generated only when
absent, 409 on a duplicate rather than a silent overwrite. `validate.ts`
15/20 -> 20/20; app tests 34 -> 42 (45 after M2).

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

**Status: FIXED** `41ce29a`. `sdkNames()` now calls `packageName(model,
'npm')` and `goModule(model, 'go')` instead of re-deriving, and the TS
Agents template documents entity-return + throw with `direct()` as the
named exception.

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

**Status: FIXED** `95037bd`. get/update/delete 404 on a parent mismatch,
checked BEFORE the mutation, and PUT can no longer reparent via the body.

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

#### H1 — Live direct tests cannot fail (G3 — now closed, see Status)
**Locus:** generator. **Files:** `.sdk/src/cmp/ts/TestDirect_ts.ts:339-345`.

**Status: FIXED** `246eaf4` (strict) + `282d309` (a CI job that runs it).
Note the flag alone was not enough: the TS strict branch asserted the
offline mock fixtures against live data. See section 0.

In live mode a non-2xx is a bare `return`, not `t.skip()` and not an
assertion. Comments say “Skip rather than fail”. Go emits `t.Skipf`.
sdkgen 3.3.1 has `liveStrict()`; this model does not set
`main: kit: test: live: strict: true`.

A green live run still mostly proves dispatch. Entity `basic` tests are
the only ones that notice ECONNREFUSED. Combined with C1, even those
cannot prove create.

#### H2 — CI never regenerates, never tests `app/`
**Locus:** ci. **File:** `.github/workflows/ci.yml`.

**Status: FIXED** `0b2da35`. Generate + drift gate (two checks: `git diff
--exit-code` ignores untracked files) and an `app` job running typecheck,
42 tests and `validate.ts` against a real server.

Jobs: `.sdk` **build only** (no `generate`, no `git diff --exit-code`),
`ts` build+test, `go` build+test. Missing:

- `npm run generate` + dirty-tree check (the golden rule in root
  `AGENTS.md`)
- `app` unit/integration tests
- `app` `validate` / `validate:full`

Hand-edits in `ts/` or `go/`, or a broken app, merge to `main` unnoticed.
The Seneca provider write outside the repo would also be invisible
because generate is not run (H3).

#### H3 — Seneca provider generate escapes the repository on a flat clone
**Locus:** generator. **File:** `.sdk/model/sdk-base.aontu` (`output: path`).

**Status: FIXED.** The target is now `active: false` by default, and
generating it is a separate, deliberate command.

`model/sdk.aontu` was split into three: `sdk-base.aontu` holds everything the
project declares about itself, and two thin entry points include it and set
the one value that differs — `sdk.aontu` (`active: false`, used by `npm run
generate`) and `provider.aontu` (`active: true`, used by `npm run
generate-provider`). Two files rather than a one-line override because aontu
UNIFIES: a concrete `false` and a concrete `true` for one path conflict, and
the schema already defaults `active: *true` at `sdkgen.aontu:136`, so a
competing default conflicts too.

**The recorded diagnosis was wrong, and understated it.** The failure is not
`EACCES` — that was one workspace's luck in landing on a root-owned path.
sdkgen does not refuse a destination that does not exist:
`checkExternalFolders` explicitly `continue`s on a missing folder, so
generation CREATES it. Where the parent is writable, nothing fails at all.
Observed on a clone at `/home/user/<repo>`: `npm run generate` silently wrote
a 48-file `/home/seneca/solardemo-provider`, outside the project entirely.

`0b2da35` therefore made it worse, not better: it `mkdir -p`'d the external
path in CI so the write would succeed rather than preventing it. That step is
removed, and replaced by a guard that fails the job if `../../seneca` exists
after generate — so a future `active: true` goes red instead of quietly
publishing a provider repo into `/home/runner/work/`.

Verified both directions: `npm run generate` exits 0, logs
`generate-external-skip seneca-provider inactive, not generated`, creates
nothing outside the repo, and changes exactly one line of `model/sdk.json`
(`active: true` -> `false`) with no `ts/`/`go/` drift; `npm run
generate-provider` logs `generate-external -> /home/seneca/solardemo-provider`
and writes the 48 files, confirming the opt-in path still works and that the
guard above has something real to catch.

`output.path: '../../seneca/solardemo-provider'` assumes
`~/Projects/voxgig-sdk/<this repo>` beside `~/Projects/seneca/`. In this
workspace that resolves to `/seneca/solardemo-provider` (`EACCES`).
In-tree `ts/`/`go/` still write; `npm run generate` logs an error.

Documented on purpose. Still means “generate” is not a portable command,
and CI (if it ever ran generate) would fail or skip the provider silently
depending on error handling.

#### H4 — `SECURITY.md` is linked and absent
**Locus:** docs. **File:** `README.md:217-220`.

**Status: FIXED.** Both dangling links now resolve. `SECURITY.md` states
what is actually published, and that `app/` is a test server rather than a
product — no auth, unauthenticated `/debug`, in-memory state — so those are
documented design rather than findings. `design/PUBLISHING.md` documents the
real release flow for both artifacts and records the M9 version drift.

Root README: “See [SECURITY.md](SECURITY.md)”. No such file. Publish
workflow comments also point at `design/PUBLISHING.md`, which does not
exist either.

#### H5 — Go version unset; docs say 1.23, `go.mod` says 1.21
**Locus:** generator. **Files:** `.sdk/model/target/go.aontu` (no
`goversion`), `go/go.mod:3`, root `AGENTS.md:26`.

**Status: FIXED** `41ce29a`. `goversion: '1.23'` pinned in `model/sdk-base.aontu`
(not `target/go.aontu`, which `target add` overwrites).

August report A2 claimed `module.goversion: '1.23'` was set. It is empty;
sdkgen defaults to 1.21. CI reads `go.mod`, so runners use 1.21. The CI
comment still talks about 1.23 / `log/slog`.

#### H6 — Planet README “API path” is `/forbid`, not `/api/planet`
**Locus:** generator. **Files:** `.sdk/src/cmp/ts/ReadmeModel_ts.ts:167-170`,
`ts/README.md:364`.

**Status: FIXED** `41ce29a`. `ReadmeModel_ts.ts` uses the primary point.

Planet `create` has three points (forbid, terraform, plain create). The
README takes `points[0]`. `AgentInfo.primaryPoint()` already skips
`$action` points; `ReadmeModel` does not use it.

---

### Medium

#### M1 — Unauthenticated `/debug` dumps the whole store
**Locus:** app. **File:** `app/src/routes/index.ts:41-48`.

**Status: FIXED** `ed26ca9`. The bind address now decides: loopback keeps
`/debug`, anything else does not register it — 404, as though it never existed,
so no handler survives for a later edit to un-guard. `DEBUG_ROUTE=true|false`
overrides either way. Eight tests, including that `DEBUG_ROUTE=0|no|1|yes` are
NOT overrides. Forcing the guard back to `true` fails three of them.

Not in OpenAPI. No env guard. Harmless on `HOST=localhost`; a footgun if
someone sets `HOST=0.0.0.0`.

#### M2 — `DATA_PATH` is documented and unused
**Locus:** app. **Files:** `app/src/config.ts:9-11`, `app/src/server.ts:41`.

**Status: FIXED.** `build()` now reads `config.data.initialDataPath`. A
relative value resolves against the app root rather than the CWD, so the
default keeps working from any directory. Three regression tests added
(app 42 -> 45); with the fix reverted, all three fail.

Config reads `process.env.DATA_PATH`; `build()` hardcodes
`../../solar.data.json`.

#### M3 — `Config.fragment.ts` is a named-literal fork
**Locus:** generator. **File:** `.sdk/src/cmp/ts/fragment/Config.fragment.ts:22,32`.

**Status: FIXED** `41ce29a`. Restored to `$$const.Name$$` and
`$$main.kit.info.servers.0.url$$`, byte-identical to the stock fragment.

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

**Status: FIXED** `4c677a2`. The two copies are now guarded byte-for-byte by
`app/test/defsync.test.ts`; appending one line to `app/def` fails it. The
spec's thinness relative to the server is left as-is deliberately — widening it
regenerates SDK types, which is a far larger blast radius than the drift risk
this closes.

Missing: 4xx responses, `terraformState` / `forbidState` / `forbidReason`
on Planet, `/debug`, error schema. Entity model then *widens* Planet with
`forbid`, `ok`, `start`, `state`, `stop`, `why` from action payloads —
so `PlanetCreateData` includes terraform/forbid fields on the core
create type (`ts/src/SolardemoTypes.ts:76-93`).

Two copies of the YAML, no check they stay in sync. They match today.

#### M5 — Error envelope is inconsistent
**Locus:** app. **File:** `app/src/server.ts:20-38`.

**Status: FIXED** `ae1f34d`. One envelope, `{ error, message }`, with `error`
kept when it is one of this app's own classes and derived from the status
otherwise. The `'validation'` branch was UNREACHABLE — Fastify sets
`statusCode` 400 before the handler runs — so the documented
`"Validation Error"` never appeared and Ajv failures reached clients as
`"Error"`. Measured across all five paths. `errors.integration.test.ts` pins
it; reverting the handler fails three of its cases.

Ajv hits the `statusCode` branch (`error: err.name` → `"Error"`). Custom
`ValidationError` → `"ValidationError"`. README documents
`"Validation Error"`. The `'validation' in err` branch looks dead.

#### M6 — README surface claims (REPL, CLI, MCP)
**Locus:** generated docs. **Files:** `README.md:9`, `ts/README.md:12-13`.

**Status: FIXED** `bbb488d` (here) + `voxgig/sdkgen#85` (root README). The
per-language sentence is now model-driven: it names the active sibling targets
and disappears when there is none. `go/README.md` carried the same false claim
and was missed by the register. The root README's "interactive REPL" came from
sdkgen's own `ReadmeTop.ts`, where the entry was gated on `hasJsLike` — a ts or
js target merely EXISTING. That is wrong in both directions: a ts/js SDK is a
library and ships no REPL, while `go-cli` genuinely emits one (`func repl`, a
prompt, `/help` and `/quit`) and went uncredited. Fixed upstream by gating it
on `hasCli`.

**Not yet visible here.** `README.md` is generated by the PINNED
`@voxgig/sdkgen` (3.3.1 — see `.sdk/package.json`, pinned exactly by L5), so
line 9 still advertises the REPL and will until that pin is raised to a release
carrying the fix. Raising it regenerates every target with a newer generator,
which is its own change with its own drift to review, so it is deliberately not
bundled here.

Stock `ReadmeTop` advertises surfaces this repo does not ship. The
Surfaces table two screens later lists only `ts/` and `go/`.

#### M7 — LICENSE copyright split
**Locus:** docs. Root `LICENSE`: `Copyright (c) 2025 voxgig-sdk`.
`ts/LICENSE` and `go/LICENSE`: `Copyright (c) 2026 Voxgig`.

**Status: FIXED** `c99d0f2`. All three files read
`Copyright (c) 2025-2026 Voxgig`. The `tm/{ts,go}/LICENSE` fork turned out to
be load-bearing: the stock template derives the year from
`new Date().getFullYear()`, unconditionally, so in a drift-gated repo CI would
fail every 1 January with nothing changed. Recorded in `design/README.md`.

#### M8 — `.claude/settings.local.json` is tracked
**Locus:** docs. Root and `app/`. Permission allow-lists only, no secrets
today. `.local` implies machine-local; `.gitignore` does not exclude
`.claude/`.

**Status: FIXED** `c99d0f2`. Both files renamed to `settings.json` — shared
and deliberate — with `**/.claude/settings.local.json` ignored. The `**` is
required: a pattern containing a slash anchors to the repo root and would have
missed `app/`.

#### M9 — No Go release workflow; `go/VERSION` is `0.0.1`
**Locus:** ci. TS publishes on `ts/v*` tags. Go documents `go get …@latest`
via `go/vX.Y.Z`. Makefile `publish` pushes tags and **explicitly does not
run tests**. TS SDK is `0.1.0`; Go module file still says `0.0.1`.

**Status: FIXED** `956e916`. The Go version is model-driven and both
artifacts read 0.1.0. The cause was not neglect: `tm/go/VERSION` holds a
resolved literal because `target add` substitutes `PROJECTVERSION` and
`generate` does not, so it froze at whatever the model said when the target was
last added. `publish-go.yml` now asserts the tag matches `go/VERSION` and runs
the suite offline.

#### M10 — `publish-ts.yml` does not strip `.env.local`
**Locus:** ci. CI does (`ci.yml:57-59`); publish runs `npm test` without
that step.

**Status: FIXED** `956e916`, as defence in depth rather than the
vulnerability the register implied. `.env.local` matches `.gitignore`'s
`.env.*` and is untracked, so `actions/checkout` cannot produce one — but the
step was NAMED "Test (offline)" while nothing enforced it. One line makes the
name true, and it holds on a reused workspace.

#### M11 — App integration tests share one mutable server
**Locus:** app. Single `build()` in `before()`; terraform/forbid/create
mutate seed data. Passing today, order-fragile.

**Status: FIXED** `ae1f34d`. Both suites build per test. The register's
structural claim was right; its asserted consequence (failures today) could not
be reproduced. The isolation-guard pair is the durable part — the first test
leaves a planet behind, the second asserts the next cannot see it — so
reverting the hooks fails loudly instead of silently restoring the coupling.

#### M12 — Empty primary test corpus sections
**Locus:** generator. G2 filled `preparePath` / `clean` / `prepareAuth`.
At least seven other `.sdk/test/primary/*.aontu` files still have
`basic: set: []`. `test-model` passes those silently (sdkgen 3.3.1 fails
a *section* with zero cases; empty `set` inside a named section may still
slip through — confirm before closing).

**Status: FIXED.** One section promoted with real cases, the other six
given a machine-checkable reason, and a guard added so this cannot recur.

**The count was right; the diagnosis was not.** These were not seven fixtures
awaiting data. Six are blocked on a *runner capability*, and one was not
blocked at all:

- **`makePoint` is promoted** — 7 cases covering every branch: single point,
  `allow.op` denial, empty-points error, `select.exist` selection and its
  fall-through, `$action` selection, and the invalid-`$action` error. The
  inherited note said it "requires ... a real client". It does not: `Context`
  rebuilds `op` from `opname` + `entity` + `config.entity.<n>.op.<n>.points`,
  and `options` can be supplied literally, so the whole utility is expressible
  as data. Verified by running it, not by reading it.
- **Six stay deferred, and now say why in the fixture** — `featureInit` and
  `featureHook` need `f.init` / `f[name]` to be FUNCTIONS, which a fixture
  compiled to JSON cannot carry; `fetcher` needs a transport; `makeFetchDef`
  and `makeResult` need a ctx built through the SDK's own constructors;
  `featureAdd` mutates the shared client and the runner builds one client per
  spec, not per entry. These are runner changes, not fixture data.

**Why it went unseen for two reviews.** The per-section zero-case guard in
each language runner only fires for a section some test actually calls. None
of the seven had a call — TS had one hand-written `makePoint-single` covering
one branch of one of them, and Go had hand-written tests that had drifted from
the corpus. A fixture nobody runs is indistinguishable from one that passes.

`ts/test/utility/Corpus.test.ts` now guards the corpus **as a whole**, and
deferral is DATA (`basic: pending: '<reason>'`) rather than a comment —
comments do not survive compilation to `test.json`, so a marker written only
in the `.aontu` source cannot be checked by the thing that consumes it. Three
invariants, each verified able to fail: an empty section must declare a
reason, a reason must be more than a marker, and a section that gains cases
must drop its deferral.

**Two latent TS/Go divergences surfaced while promoting `makePoint`**, both
found because the shared corpus forces the two ports through identical input:

- `options.allow.op` is a COMMA-SEPARATED STRING. Go type-asserts it to
  `string` and uses `strings.Contains`; TS uses `.includes()`, which accepts a
  list too. A list denies every operation in Go and passes in TS.
- Go resolves the operation through the `Entity` INTERFACE, so a literal
  `{name: 'planet'}` leaves `ctx.Entity` nil and every config lookup misses;
  TS reads the same field with `getprop` and accepts the plain map.

Neither is live — real callers pass a string and a real entity — so they are
recorded here rather than raised as defects.

---

### What the Medium/Low sweep changed about the findings themselves

Five entries were wrong or incomplete as recorded, and the corrections matter
more than the fixes:

- **L16 does not reproduce at all.** No `F_OK` in jostraca, either version.
- **M9's cause was not neglect.** `tm/go/VERSION` is *supposed* to hold a
  resolved literal — `target add` substitutes `PROJECTVERSION`, `generate`
  does not — so the version froze at whatever the model said when the target
  was last added. Restoring the placeholder by hand ships the literal string.
- **L13 was two defects.** The `sleep 3`, and `$!` capturing the `npm start`
  wrapper rather than the `node` server. The second is what caused the
  `EADDRINUSE` the register blamed on the first.
- **L7 was a measurement artefact, not a gap.** Go coverage is 76.3% with
  `-coverpkg`; the default per-package mode reports 0.0% because the suite is
  one external `package sdktest`.
- **L18's wording was half wrong.** The bare `dist` rule matched `ts/dist`
  but never `ts/dist-test`. The real hazard was that a NEW file under
  `ts/dist` was invisible to `git add -A`.

And three defects were found only because a fix needed somewhere to live:

- `app/package.json`'s test glob **never ran top-level test files** — `**`
  requires at least one directory, and every existing suite happened to be
  nested. A test added at `app/test/*.test.ts` compiled and silently did not
  run.
- The **LICENSE templates' frozen year is load-bearing**: the stock template
  derives it from the system clock, which in a drift-gated repo fails CI every
  1 January with nothing changed.
- **sdkgen mis-gated its "interactive REPL" claim**, keying it on a ts/js
  target merely existing. My first fix deleted the line on the premise that no
  target generates a REPL — which an adversarial review refuted: `go-cli` does.
  The entry was mis-gated, not unfounded, and is now keyed on `hasCli`.


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
| L16 | ~~`jostraca` `fs.F_OK` deprecation (E7)~~ **Does not reproduce.** Zero `F_OK` references in installed jostraca 0.31.2 AND in the upstream clone; the only hits in the tree are `@types/node` type declarations, and `npm run generate` emits no deprecation at all. Carried from an earlier review and never re-verified. |
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
here is a convenience that encodes a checkout layout, so it is now opt-in
via `npm run generate-provider` rather than part of `generate` (H3).

---

## 5. Recommended order of work

Do these in `.sdk/` or `app/`, then regenerate. Do not hand-edit `ts/` or
`go/`.

Items 1-5 are **done**, in this order. What remains is 6 (minus H5, H6 and
M3) and 7.

1. ~~**C2 — Agents identity + entity-return docs.**~~ **Done** `41ce29a`.
   **C2 — Agents identity + entity-return docs.** Highest leverage for
   anyone (or any agent) consuming the SDK. Use `packageName` / `goModule`;
   rewrite the operation examples.
2. ~~**C1 — create-id contract.**~~ **Done** `95037bd` — client-supplied
   ids, as recommended.
   **C1 — create-id contract.** Pick one semantics and align OpenAPI,
   Fastify schemas, handlers, entity model, `validate.ts`. Prefer
   client-supplied ids: that is what the SDK types already require.
3. ~~**C3 — moon parent enforcement.**~~ **Done** `95037bd`.
   **C3 — moon parent enforcement.** Cheap, and it makes nested URLs mean
   something.
4. ~~**H2 — CI generate-diff + `app` test job.**~~ **Done** `0b2da35`. The
   Seneca guard initially went the other way: the output path was CREATED
   in CI rather than the target deactivated, which made the escaping write
   succeed instead of preventing it. Superseded by H3 — `active: false`
   plus a CI guard that fails if generate writes outside the repo.
5. ~~**H1 — `test.live.strict: true`**~~ **Done** `246eaf4`, and `282d309`
   adds the CI job that actually runs it. Sequencing this after C1 was
   right — before it, strict live runs would have been red for a server
   defect.
   **H1 — `test.live.strict: true`** once the app honours create ids, so
   live runs become evidence.
6. ~~**H4, H5, H6, M2, M3**~~ — **all done.** H5, H6 and M3 in `41ce29a`;
   H4 (SECURITY.md + PUBLISHING.md) and M2 (`DATA_PATH` wired) since.
7. **M9** — either automate Go tags or stop advertising `go get @latest`
   until `go/VERSION` matches the TS 0.1.0 line.

---

## 6. Reconciliation with the August 12 register

| ID | Aug 12 | Now |
| --- | --- | --- |
| A1–A6 | Fixed | Still fixed; A2 regressed to H5 and is **re-fixed** (`41ce29a`) |
| B0–B5 | Fixed by removing LogFeature | Still gone; TS generate no longer restores extra features |
| C1–C6 | Fixed | Residual blank descriptions (L2); the new wrong Planet API path (H6) is **fixed** (`41ce29a`) |
| D1, D2, D4 | Fixed | Still fixed |
| D3, D5 | Open | Still open (L5, L6) |
| E1 | Open | Still open (no stale-output prune) |
| E3–E7 | Open | Still open |
| E8 | Fixed | Still fixed |
| E9 | Fixed (no forks) | **Partly recovered** — AgentInfo now calls the sdkgen helpers and Config.fragment is back to stock placeholders (`41ce29a`); Agents, Root, BuildSDK remain custom |
| E10 | Upstream workaround | Still truncated Go feature harness |
| E11 dryrun | Upstream | **Fixed** in sdkgen 3.3.1 |
| G1 | Open | Still open (L7) |
| G2 | Fixed | Residual empty corpus files (M12) now resolved: 1 promoted, 6 deferred with a machine-checked reason |
| G3 | Open | **FIXED** — `246eaf4` sets `test.live.strict`, `282d309` adds the CI job that runs it. Open across two reviews; closed now. |
| G4 | Open / High | **Fixed** in generated output (slug `solardemo`) |
| — | — | **New:** C1, C2, C3, H2–H6, M1–M11 |

Keep [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) as historical
context. Treat **this document** as the current register until the next
review.

---

## 7. Verification performed

Read, not assumed:

- `.sdk/model/sdk-base.aontu`, `target/go.aontu`, `AgentInfo.ts`, `Agents_ts.ts`,
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

### Run during the fix pass (2026-08-20, `main` at `27ffa87`)

The three caveats above are now closed. Each fix was falsified in both
directions rather than confirmed in one:

| Claim | How it was checked |
| --- | --- |
| C1 create-id overwrite is real | Stashed the fix, re-ran `validate.ts` against the same server: **15/20**, failing ids 3, 4, 11, 19, 20 — the exact five predicted from source. Restored: **20/20**. |
| The H2 drift gate does not false-positive | `generate` on a clean checkout of `main`: **zero drift**, tracked and untracked. |
| The H2 drift gate actually catches drift | Appended one line to `ts/src/SolardemoTypes.ts`: gate fires. |
| Live runs are now evidence | Server up: ts **185 pass / 1 skip**, go ok. Port closed: **3 suites fail in each language**. |
| The generate job is not vacuously green | Read the runner log, not the tick: apidef ran (entities=2, paths=6, methods=12), jostraca emitted go and ts, `generate-external` resolved to `/home/runner/work/seneca/solardemo-provider`. |
| The live job is not vacuously green | Runner log shows ts `tests 186 / pass 185 / fail 0 / skipped 1` and go `ok ... 0.936s` — a real duration, **not `(cached)`**. |

Full matrices: ts **186** (185 pass / 1 skip live), go ok, app **42**,
`validate.ts` **20/20**, CI **6/6** green.

Two things this pass found that source reading alone would not have:

- Enabling `test.live.strict` made live runs red against a *healthy*
  server, because the TS strict branch asserted the offline mock's
  fixtures (`data.id === 'direct01'`) against live data. Go was correct;
  TS was the outlier.
- The first Go live negative control **passed from cache** with the port
  closed. `go test` caches by input and reported `ok` without contacting
  the server — hence `-count=1` in the live job.
