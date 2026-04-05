# Report: sdkgen Update & Documentation Comparison

## Methodology

1. Restored original documentation files from the pre-update baseline (`aa6e7cd`).
2. Removed `node_modules/` and `package-lock.json` in `.sdk/`.
3. Ran a fresh `npm install` to pull `@voxgig/sdkgen` directly from GitHub `main`.
4. Verified the installed version matches the latest commit on `voxgig/sdkgen#main`:
   - **Version**: 0.35.2
   - **Commit**: `c7c8ac49495034f932025b9f1ac22a98b22a20c9` (2026-04-04)
   - **Commit message**: "Merge pull request #4 from voxgig/claude/fix-go-duplicate-test-PzhlD"
5. Ran `npm run build` and `npm run generate` in `.sdk/` to regenerate both
   TypeScript and Go targets.
6. Confirmed deterministic output (two independent generation runs produced
   identical results).
7. Ran `voxgig-sdkgen target add ts` and `voxgig-sdkgen target add go` to
   refresh per-target components from the latest sdkgen project template.
8. Rebuilt and regenerated again after target add.
9. Compared documentation output against originals a second time.

## Target Add Results

Running `target add` for both targets brought in several template module
updates but **did not change the documentation output**:

**New files added:**
- `tm/go/feature/log_feature.go` -- Go LogFeature implementation
- `tm/ts/src/utility/FeaturehookUtility.ts` -- TS feature hook utility

**Updated template modules (18 files):**
- Go: `core/context.go`, `core/error.go`, `core/types.go`,
  `feature/test_feature.go`, `test/primary_utility_test.go`,
  `test/runner_test.go`, `utility/make_error.go`, `LICENSE`
- TS: `src/Context.ts`, `src/types.ts`, `src/utility/MakeContextUtility.ts`,
  `src/utility/MakeErrorUtility.ts`, `test/exists.test.ts`,
  `test/utility/Custom.test.ts`, `LICENSE`
- Model: `model/feature/test.jsonic`, `model/target/ts.jsonic`,
  `src/cmp/ts/fragment/Config.fragment.ts`

**Key finding**: The sdkgen project template at `node_modules/@voxgig/sdkgen/project/.sdk/src/cmp/go/` does **not** contain `ReadmeInstall_go.ts` or `ReadmeQuick_go.ts`. These Go-specific Readme components simply do not exist in sdkgen v0.35.2. The `target add` command cannot add what doesn't exist upstream. All existing local components were already in sync with the template prior to running `target add`.

## Generation Warnings

The generator emitted two warnings during the Go target pass:

```
WARN: model/jostraca  require-missing  ./cmp/go/ReadmeInstall_go
WARN: model/jostraca  require-missing  ./cmp/go/ReadmeQuick_go
```

These indicate that Go-specific Readme sub-components (`ReadmeInstall_go`,
`ReadmeQuick_go`) do not exist in sdkgen yet. The generator falls back to
the generic (TypeScript-oriented) templates for those sections.

## Files Changed

| File | Lines (old) | Lines (new) | Net | Nature of change |
|---|---|---|---|---|
| `README.md` | 234 | 9 | -225 | Replaced with skeleton stub |
| `ts/README.md` | 389 | 154 | -235 | Restructured; reference split to REFERENCE.md |
| `go/README.md` | 425 | 125 | -300 | Restructured; uses wrong language (TS) for examples |
| `ts/REFERENCE.md` | 114 | 114 | 0 | Unchanged |
| `go/REFERENCE.md` | 114 | 114 | 0 | Unchanged |
| `.sdk/package.json` | -- | -- | -- | Dependency ordering alphabetized by npm |
| `ts/package.json` | -- | -- | -- | `pino`/`pino-pretty` removed from dependencies |

**Total**: 219 insertions, 938 deletions across 5 changed files.

## Detailed Documentation Comparison

### Root `README.md`

**Original (234 lines):**
- Title, description, and links to TS/Go SDKs
- Entity table (Planet, Moon) with API paths
- Architecture section: 5-stage pipeline, features table, direct/prepare methods
- Quick start examples in both TypeScript and Go
- Testing section (unit + live) with environment variable reference
- 4 how-to guides: direct calls, nested entities, custom features, request inspection
- Links to language-specific docs

**Generated (9 lines):**
- Title: "Solardemo SDKs"
- "API Entities" heading
- Empty mermaid flowchart diagram (no nodes)

**Assessment**: **Major regression**. The root README is now a non-functional stub.
The new sdkgen template appears to generate only a placeholder. All substantive
content -- architecture overview, quick starts, how-to guides, testing
instructions -- has been lost.

---

### `ts/README.md`

**Original (389 lines):**
- Introduction with install instructions
- 4-step tutorial: create client, list planets, load a moon, CRUD operations
- 5 how-to guides: direct HTTP, prepare requests, test mode, entity state, custom middleware, live tests
- Full API reference: constructor options table, instance/static methods, entity interface, result/fetchdef shapes, entity field tables
- Explanatory sections: operation pipeline, features/hooks deep-dive, entity state, direct vs entity access

**Generated (154 lines):**
- Introduction with feature bullet points
- Install (correct: `npm install solardemo`)
- Quick Start: create client + direct API access example
- SDK Structure: client methods table, entity methods table
- Direct API Access section (duplicated -- appears twice in the README)
- Result shape and prepare usage
- Testing (minimal: just `SolardemoSDK.test()`)
- Pointer to `REFERENCE.md`

**What improved:**
- Clean separation of concerns: README for getting started, REFERENCE.md for API details
- Feature bullet list gives a quick overview
- Client and entity method tables are well-structured

**What regressed:**
- No tutorial walkthrough (the old 4-step guide was effective onboarding)
- No how-to guides (direct calls, entity state, custom middleware, live tests all dropped)
- Code examples use generic paths (`/custom/endpoint/{id}`, `/api/v1/resource/{id}`) rather than project-specific ones (`/api/planet/{id}`, `/api/planet/{planet_id}/moon/{id}`)
- Introduction body is empty (blank line between "## Introduction" and "### Features")
- Direct API Access section appears twice (under Quick Start and under SDK Structure)
- No entity-specific documentation (Planet, Moon not mentioned by name)
- No pipeline/architecture explanation
- Install section uses ` ```ts ` code fence instead of ` ```bash `

---

### `go/README.md`

**Original (425 lines):**
- Go-specific introduction mentioning `map[string]any` conventions
- Install via `go get` with `replace` directive example
- Full Go tutorial (5 steps with idiomatic Go code)
- 5 how-to guides with Go code: direct HTTP, prepare, test mode, custom fetch, live tests
- Complete Go API reference: `NewSolardemoSDK` signature, `TestSDK`, entity interface with Go type signatures, result shapes, type exports, helper functions
- Explanatory sections: pipeline, features/hooks, `map[string]any` philosophy, entity state, package structure diagram

**Generated (125 lines):**
- Title: "Solardemo Golang SDK"
- Introduction body is empty
- Features list says "Type safe: full **TypeScript** definitions included" (wrong language)
- Install section is completely empty (no `go get`, no module info)
- Quick Start section is completely empty
- SDK Structure section uses **TypeScript code examples** throughout:
  - `const client = new SolardemoSDK({ apikey: '...' })` instead of Go
  - `const testClient = SolardemoSDK.test()` instead of Go
  - `client.direct({ ... })` with TypeScript syntax
  - `const fetchdef = await client.prepare(...)` instead of Go
  - `SolardemoSDK.test()` instead of `sdk.TestSDK(nil, nil)`
- All code blocks tagged as ` ```ts ` instead of ` ```go `
- Entity method names use camelCase (`load`, `list`) instead of Go PascalCase (`Load`, `List`)
- No mention of `map[string]any`, error returns, or Go-specific patterns

**Assessment**: **Critical issues**. The Go README is essentially a copy of the
TypeScript README with the title changed. Every code example is TypeScript, not Go.
This would actively mislead Go developers. The root cause is the missing
`ReadmeInstall_go` and `ReadmeQuick_go` components in sdkgen.

---

### `ts/REFERENCE.md` and `go/REFERENCE.md`

**Both files are unchanged** from the pre-update baseline (114 lines each).
They were not regenerated by this run.

**Pre-existing issue**: `go/REFERENCE.md` is identical to `ts/REFERENCE.md`
except for the title. Both use TypeScript syntax:
- Constructor: `new SolardemoSDK(options?: object)` (not Go)
- Code examples: `const client = SolardemoSDK.test()` (not Go)
- Return types: `Promise<{ ok, status, headers, data } | Error>` (not Go)
- Feature activation: TypeScript object literal syntax

This is a pre-existing problem in the sdkgen `ReadmeRef` component, not
introduced by this update.

---

### `ts/package.json`

**Changes:**
- `pino` (^10.3.1) and `pino-pretty` (^13.1.3) **removed** from `dependencies`
- `@types/pino-pretty` (^4.7.5) **removed** from `devDependencies`
- Empty `peerDependencies: {}` block added
- `dependencies` now empty: `{}`
- `@types/node` moved after `typescript` in devDependencies (re-ordered)
- Trailing newline removed

**Impact**: If the SDK uses pino for logging (LogFeature), removing pino from
dependencies will cause runtime errors. The generated TypeScript source files
still import pino -- this needs verification.

---

### `.sdk/package.json`

**Changes**: Dependencies re-ordered alphabetically by npm during install.
No functional change.

## Summary of Issues

| # | Severity | Issue | Root Cause |
|---|---|---|---|
| 1 | **Critical** | Go README/REFERENCE use TypeScript code examples | Missing `ReadmeInstall_go`, `ReadmeQuick_go` in sdkgen; `ReadmeRef` has no Go variant |
| 2 | **Critical** | Go features list says "TypeScript definitions" | Generic template text not parameterized per target |
| 3 | **High** | Root README is a 9-line stub | sdkgen `Top` component generates only a placeholder |
| 4 | **High** | Go Install and Quick Start sections are empty | Missing Go-specific readme components |
| 5 | **Medium** | `pino`/`pino-pretty` removed from ts/package.json | sdkgen template change; may break LogFeature at runtime |
| 6 | **Medium** | Tutorials and how-to guides dropped | New template structure is reference-oriented, lacks tutorial content |
| 7 | **Medium** | TS code examples use generic paths not project-specific | Template uses placeholders instead of model-derived paths |
| 8 | **Low** | Direct API Access section duplicated in ts/README | Template renders the section in both Quick Start and SDK Structure |
| 9 | **Low** | TS Install uses ` ```ts ` fence instead of ` ```bash ` | Template bug |
| 10 | **Low** | Introduction section body empty in both READMEs | No `ReadmeIntro` content for this project |
| 11 | **Info** | REFERENCE.md files unchanged | Not affected by this sdkgen version |

## Recommendations

1. **sdkgen upstream**: Add Go-specific readme components (`ReadmeInstall_go`,
   `ReadmeQuick_go`, `ReadmeRef_go`) that generate idiomatic Go examples.
   These files need to be created at `project/.sdk/src/cmp/go/` in the
   sdkgen repo. Without them, the Go README will always fall back to the
   TypeScript-oriented generic templates.
2. **sdkgen upstream**: Parameterize the features bullet list per target language
   (e.g. "Type safe" should reference Go types for the Go target). The
   `ReadmeIntro` component uses a single hardcoded feature list that mentions
   "TypeScript definitions" regardless of target.
3. **sdkgen upstream**: Parameterize `ReadmeRef` per target. Currently both
   `ts/REFERENCE.md` and `go/REFERENCE.md` are generated with TypeScript
   syntax (`new SolardemoSDK(...)`, `Promise<...>`).
4. **sdkgen upstream**: Populate the root README template (`Top` component)
   with entity diagrams, architecture overview, and cross-links to language
   SDKs. Currently generates an empty mermaid diagram.
5. **sdkgen upstream**: Use model-derived API paths in code examples
   (e.g. `/api/planet/{id}`) instead of generic placeholders
   (`/api/v1/resource/{id}`).
6. **This project**: Verify whether pino is still imported in generated TS source;
   if so, either restore pino to dependencies or update the template.
7. **This project**: Consider maintaining hand-written tutorial/how-to content
   alongside the generated reference docs until sdkgen templates mature.
   The old docs contained effective tutorials and architecture explanations
   that the current template system cannot reproduce.
