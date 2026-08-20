# Report: Build & Test Status

Verified: **2026-08-12**, after the `@voxgig/sdkgen` 1.3.17 → 2.0.2 upgrade.

> **Stale as of 2026-08-20.** Toolchain is sdkgen **3.3.1**, slug is
> `solardemo` (not `voxgig-solardemo`), class is `SolardemoSDK`, G4 env-var
> dual-spelling is gone, and `app/` `validate:full` is not green. Use
> [REPORT-codebase-review-2026-08-20.md](REPORT-codebase-review-2026-08-20.md)
> as the current picture. Numbers below are left as a snapshot of that day.

## Summary

Everything green *as of 2026-08-12*. The generator builds with no warnings, generation is
idempotent, and both SDKs build and pass their full suites.

| Step | Result |
| --- | --- |
| `.sdk` — `npm run build` | PASS |
| `.sdk` — `npm run generate` | PASS — **0 warnings** (was 9 `require-missing`) |
| `ts` — `npm run build` | PASS |
| `ts` — `npm test` | PASS — 186 tests, 22 suites, 0 fail (was 128 / 8) |
| `go` — `go build ./...` | PASS |
| `go` — `go test ./...` | PASS — 17 top-level tests (was 8) |
| `app` — `npm audit` | 0 vulnerabilities |

## Toolchain

`.sdk` dependency ranges float on `>=`, so these move without a commit.

| Component | Version | Range in `.sdk/package.json` |
| --- | --- | --- |
| Node | 24.16.0 | `.node-version` pins `24` |
| Go | 1.26.3 | `go/go.mod` declares `go 1.20` |
| `@voxgig/sdkgen` | 2.0.2 | `>=2.0` |
| `@voxgig/apidef` | 7.0.1 | `>=7.0` |
| `@voxgig/model` | 9.4.1 | `>=9.4` |
| `@voxgig/util` | 0.5.4 | `>=0.5` |
| `@voxgig/struct` | 0.2.2 | `>=0.2` |
| `jostraca` | 0.31.2 | `>=0.31` |
| `aontu` | 0.51.0 | `>=0.51` |
| `typescript` | 7.0.2 | `>=6.0` |

## Targets

The model defines exactly two targets — `ts` and `go` — in
`.sdk/model/target/target-index.aontu`. The resolved model
(`.sdk/model/sdk.json`) has `main.kit.target = { go, ts }`, both active.
Templates (`.sdk/tm/`) and output directories match. sdkgen 2.0.2 ships
scaffolds for ~25 languages; this project uses two of them.

## Divergence from stock sdkgen

`.sdk/src/cmp/**` matches the sdkgen 2.0.2 scaffold **exactly** — zero forked
components. Three repairs to `.sdk/tm/**` remain, and are undone by
`voxgig-sdkgen target add`; see [README.md](README.md) for the checklist and
[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md)
for the upstream work that removes them.

## Package identity

| | Value |
| --- | --- |
| model slug | `voxgig-solardemo` |
| npm package | `@voxgig-sdk/voxgig-solardemo` |
| Go module | `github.com/voxgig-sdk/voxgig-solardemo-sdk/go` |
| Go minimum | 1.20 (sdkgen default; nothing needs `log/slog` any more) |
| SDK class | `VoxgigSolardemoSDK` |
| TS runtime deps | none |

All derived by **stock sdkgen** from `model.name` — there are no generator
overrides. The slug is `voxgig-solardemo` rather than `solardemo` precisely so
that sdkgen's `<origin>/<name>-sdk` formula lands on this repo. See D1.

## Go tests

17 top-level tests, all passing. Only `…/go/test` has tests; `core`, `entity`,
`feature`, `utility` and `utility/struct` report `[no test files]` (G1).

| Suite | Note |
| --- | --- |
| TestCustomUtility, TestExists | |
| TestMoonDirect, TestMoonEntity | |
| TestPlanetDirect, TestPlanetEntity | |
| TestPrimaryUtility | drives the `.sdk/test/primary/` corpus |
| TestStructUtility | shared `struct` corpus |
| TestNetsim | new in 2.0.2 — offline network simulation |
| TestPipeline* (6) | new in 2.0.2 — pipeline error and edge branches |
| TestReadmeGoSnippets | new in 2.0.2 — compiles every Go snippet in the READMEs |

Not present: the 15 per-feature behavioural blocks from
`tm/go/test/feature_test.go`, dropped because they hard-reference feature
source this SDK does not ship (E10).

## TypeScript tests

186 tests across 22 suites, all passing. `ts/node_modules` is not committed —
`npm install` is required before `npm run build`.

## Entity types

sdkgen 2.0.2 generates typed models, which is what
[DESIGN-entity-types.md](DESIGN-entity-types.md) had proposed and never got:

- `ts/src/VoxgigSolardemoTypes.ts` — `Moon`, `Planet`, plus per-operation
  `…LoadMatch` / `…ListMatch` / `…CreateData` / `…UpdateData` / `…RemoveMatch`.
- `go/entity/types.go` — the same set as Go structs with JSON tags.

Both are derived from `main.kit.entity.<e>.fields[]` and per-op params, so they
track the model automatically.

## Generation idempotency

Two consecutive `npm run generate` runs produce a byte-identical tree.
`.sdk/model/sdk.json` is regenerated and **committed** — that is the standing
decision; the drift recorded as E8 is resolved by re-committing the current
dump.

## Generation warnings

None. The nine `require-missing` warnings are gone: `voxgig-sdkgen target add`
brought in `ReadmeIntro`, `ReadmeOptions`, `ReadmeEntity` and `ReadmeRef` for
both targets, plus `ReadmeExplanation_ts`.

## Documentation sizes

| File | Lines | Was |
| --- | --- | --- |
| `README.md` | 215 | 9 (stub) |
| `ts/README.md` | 567 | 399 |
| `go/README.md` | 555 | 397 |
| `ts/REFERENCE.md` | 332 | 298 |
| `go/REFERENCE.md` | 339 | 255 |

## Live testing against the local app

Verified 2026-08-12: **186 pass, 0 fail, 0 skipped** against `app/` on
`localhost:8901` (the SDK's configured `base`, so live mode needs no `base`
override).

```bash
cd app && npm run build && npm start &      # port 8901

cd ts
IDP='{"planet01":"earth","planet02":"mars","planet03":"venus"}'
IDM='{"moon01":"io","moon02":"europa","moon03":"ganymede","planet01":"jupiter","planet02":"jupiter","planet03":"jupiter"}'

# BOTH env-var spellings are required — see G4.
VOXGIGSOLARDEMO_TEST_LIVE=TRUE      VOXGIG_SOLARDEMO_TEST_LIVE=TRUE \
VOXGIGSOLARDEMO_TEST_PLANET_ENTID="$IDP"  VOXGIG_SOLARDEMO_TEST_PLANET_ENTID="$IDP" \
VOXGIGSOLARDEMO_TEST_MOON_ENTID="$IDM"    VOXGIG_SOLARDEMO_TEST_MOON_ENTID="$IDM" \
  npm test
```

**Both env-var spellings are required.** sdkgen derives the prefix two
different ways from a hyphenated slug (`VOXGIG_SOLARDEMO` and
`VOXGIGSOLARDEMO`) and emits both. Set only one and part of the suite silently
stays on the mock transport while reporting green. Tracked as **G4**.

**The `*_ENTID` maps are required.** Without them 4 tests self-skip: the
fixtures use synthetic IDs (`planet01`, `moon01`) that 4xx against a real
server. The maps translate synthetic key → real seed-data ID. The values above
match `app/solar.data.json`; any existing planet/moon IDs work.

The suite is non-destructive — create/update/remove flows clean up after
themselves, and the server's 8 planets and 4 Jovian moons are unchanged
afterwards. The store is in-memory anyway, so a restart resets it.

### Caveat: a green live run proves less than it looks

Stop the server and re-run, and **184 of 186 tests still pass**. Only
`MoonEntity/basic` and `PlanetEntity/basic` fail on ECONNREFUSED — the
generated direct tests treat a non-2xx in live mode as an early `return`, not
an assertion. Tracked as **G3**; the fix is a model-driven strict mode
(gap 8 in
[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md)).

Read a green live run as "the SDK builds and dispatches", not "the SDK
round-trips correctly".

## Verification commands

```bash
cd .sdk && npm install && npm run build && npm run generate
cd ts   && npm install && npm run build && npm test
cd go   && go build ./... && go test ./...
cd app  && npm audit
```
