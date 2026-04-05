# Report: sdkgen Update & Documentation Comparison

## Methodology

1. Restored original documentation files from the pre-update baseline (`aa6e7cd`).
2. Removed `node_modules/` and `package-lock.json` in `.sdk/`.
3. Ran a fresh `npm install` to pull `@voxgig/sdkgen` directly from GitHub `main`.
4. Verified the installed version:
   - **Version**: 0.35.2
   - **Commit**: `d2e16cf00c7f60bc40468f90ee98739314718566`
   - Prior commit (`c7c8ac4`) was missing Go Readme components; this new
     commit adds them.
5. Ran `voxgig-sdkgen target add` for both `ts` and `go` targets to pull in
   all new per-target components from the updated sdkgen template.
6. Ran `npm run build` and `npm run generate` in `.sdk/` to regenerate both
   TypeScript and Go targets.

## Target Add Results

Running `target add` brought in many new Readme components:

**New Go components (8 files):**
- `ReadmeInstall_go.ts`, `ReadmeQuick_go.ts` -- Install and Quick Start
- `ReadmeHowto_go.ts` -- How-to guides with idiomatic Go examples
- `ReadmeExplanation_go.ts` -- Explanation section (pipeline, features, etc.)
- `ReadmeModel_go.ts` -- Entity model documentation
- `ReadmeTopHowto_go.ts`, `ReadmeTopQuick_go.ts`, `ReadmeTopTest_go.ts` -- Top-level (root README) components

**New TS components (5 files):**
- `ReadmeHowto_ts.ts` -- How-to guides
- `ReadmeModel_ts.ts` -- Entity model documentation
- `ReadmeTopHowto_ts.ts`, `ReadmeTopQuick_ts.ts`, `ReadmeTopTest_ts.ts` -- Top-level components

**Updated existing TS components (2 files):**
- `ReadmeInstall_ts.ts`, `ReadmeQuick_ts.ts`

## Generation Warnings

Only one minor warning remained:

```
WARN: model/jostraca  require-missing  ./cmp/ts/ReadmeExplanation_ts
```

The Go `ReadmeInstall_go` and `ReadmeQuick_go` warnings are **resolved**.

## Files Changed

| File | Lines (old) | Lines (new) | Net | Nature of change |
|---|---|---|---|---|
| `README.md` | 234 | 9 | -225 | Still a stub (root template unchanged) |
| `ts/README.md` | 389 | 445 | +56 | Major restructure with new sections |
| `go/README.md` | 425 | 442 | +17 | Now uses idiomatic Go code throughout |
| `ts/REFERENCE.md` | 114 | 298 | +184 | Expanded with per-entity docs |
| `go/REFERENCE.md` | 114 | 255 | +141 | Now uses Go syntax and types |
| `.sdk/package.json` | -- | -- | -- | Dependency ordering alphabetized |
| `ts/package.json` | -- | -- | -- | `pino`/`pino-pretty` removed from dependencies |

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

**Assessment**: **Still a stub**. The new sdkgen added `ReadmeTopQuick`,
`ReadmeTopHowto`, and `ReadmeTopTest` components for both targets, but the
root `Top` component in the project's `Root.ts` does not yet use them.
All substantive content from the original root README is lost.

---

### `ts/README.md`

**Original (389 lines):**
- Introduction with install instructions
- 4-step tutorial: create client, list planets, load a moon, CRUD operations
- 5 how-to guides: direct HTTP, prepare requests, test mode, entity state, custom middleware, live tests
- Full API reference: constructor options, methods, entities, result/fetchdef shapes
- Explanatory sections: operation pipeline, features/hooks deep-dive, entity state, direct vs entity

**Generated (445 lines):**
- Introduction with description
- Install (`npm install solardemo`) with correct `bash` fence
- 4-step tutorial: create client, list moons, load a moon, create/update/remove
- 6 how-to guides: direct HTTP, prepare, test mode, entity state, custom middleware, live tests
- Reference section: constructor with options table, SDK methods table, static methods, entity interface with signatures, result/directresult/fetchdef shapes, entity tables (Moon, Planet with operations)
- Entities section: per-entity docs with operations tables and code examples
- Explanation section: operation pipeline, features/hooks, entity state, direct vs entity
- Pointer to REFERENCE.md

**What improved vs original:**
- Entities section with per-entity operations tables and load/list/create examples
- Better structure: Tutorial -> How-to -> Reference -> Entities -> Explanation -> Full Reference
- Generated from model data, so entity lists stay in sync

**What regressed vs original:**
- Tutorial examples use generic entity names (`client.Moon()`) rather than contextual ones (old docs used planet/moon nested examples)
- Entity field tables are empty (no field descriptions populated)
- Entity API path fields are empty (shows `API path: ` with no value)
- `create()` examples have empty data objects (`create({})`)
- Feature descriptions in "Features and hooks" are terse ("TestFeature: Test")
- Explanation section missing `ReadmeExplanation_ts` (warning logged, falls back to generic)

**What's the same:**
- How-to guides are structurally very similar to the originals
- Pipeline explanation is identical
- Entity state and direct vs entity sections preserved

---

### `go/README.md`

**Original (425 lines):**
- Go-specific introduction mentioning `map[string]any` conventions
- Install via `go get` with `replace` directive example
- Full Go tutorial with idiomatic Go code (5 steps)
- 5 how-to guides with Go code
- Complete Go API reference with Go type signatures
- Explanatory sections: pipeline, features, data as maps, entity state, package structure

**Generated (442 lines):**
- Go-specific introduction mentioning `map[string]any` conventions
- Install: `go get voxgigsolardemosdk` with correct `bash` fence
- 4-step tutorial with idiomatic Go code: create client, list moons, load a moon, create/update/remove
- 5 how-to guides with Go code: direct HTTP, prepare, test mode, custom fetch, live tests
- Reference section with Go type signatures: `NewSolardemoSDK`, `TestSDK`, entity interface, result shapes
- Entities section: per-entity docs with Go method signatures and Go examples
- Explanation section: pipeline, features/hooks, data as maps, package structure, entity state, direct vs entity
- Pointer to REFERENCE.md

**What improved (MAJOR):**
- **All code examples are now idiomatic Go** -- `map[string]any`, error returns, `nil` params, PascalCase methods
- Go-specific introduction mentioning `map[string]any` conventions
- Go install instructions present (`go get`)
- Explanation includes "Data as maps" and "Package structure" Go-specific sections
- Entity examples use correct Go syntax (`client.Moon(nil).Load(...)`)

**What regressed vs original:**
- Entity field tables are empty (no field descriptions)
- Entity API path fields are empty
- `Create()` examples have empty data maps
- Feature descriptions terse ("TestFeature: Test")
- Missing the `replace` directive example from install section
- Tutorial uses Moon as first entity (original used Planet context more)

**What's the same:**
- How-to guides structurally match the originals
- Pipeline explanation preserved
- Package structure diagram preserved
- Custom fetch function example preserved

---

### `ts/REFERENCE.md`

**Original (114 lines):**
- SDK constructor and options table
- Static/instance methods
- Feature table
- Feature activation example

**Generated (298 lines):**
- SDK constructor and options table
- Static methods with parameters
- Instance methods with per-entity constructors (`Moon()`, `Planet()`)
- Per-entity sections: MoonEntity and PlanetEntity
  - Each with operations (create, list, load, remove, update) with full signatures and code examples
  - Common methods: data, match, make, client, entopts
- Feature table and activation example

**Assessment**: **Significant improvement**. Now includes per-entity reference
documentation with code examples for every operation. Previously was a minimal
stub.

---

### `go/REFERENCE.md`

**Original (114 lines):**
- Same as TS REFERENCE (used TypeScript syntax for Go)

**Generated (255 lines):**
- SDK constructor with **Go syntax**: `func NewSolardemoSDK(options map[string]any) *SolardemoSDK`
- `TestSDK` with Go signature
- Instance methods with Go signatures and `map[string]any` types
- Per-entity sections: MoonEntity and PlanetEntity
  - Each with operations using Go signatures (`(reqdata, ctrl map[string]any) (any, error)`)
  - Go code examples for every operation
  - Common methods with Go signatures (`Data(args ...any) any`)
- Feature table and Go activation example using `map[string]any`

**Assessment**: **Major improvement**. Previously identical to TS (wrong language).
Now uses correct Go syntax, types, and conventions throughout.

---

### `ts/package.json`

**Changes:**
- `pino` (^10.3.1) and `pino-pretty` (^13.1.3) **removed** from `dependencies`
- `@types/pino-pretty` (^4.7.5) **removed** from `devDependencies`
- Empty `peerDependencies: {}` block added
- `dependencies` now empty: `{}`

**Impact**: If the SDK uses pino for logging (LogFeature), removing pino from
dependencies will cause runtime errors.

## Summary of Issues

| # | Severity | Issue | Status vs prior sdkgen |
|---|---|---|---|
| 1 | **High** | Root README is still a 9-line stub | Unchanged -- needs `Root.ts` update |
| 2 | **Medium** | Entity field tables are empty in all READMEs | New issue -- model fields not populated |
| 3 | **Medium** | Entity API paths are empty in reference sections | New issue -- model paths not populated |
| 4 | **Medium** | `pino`/`pino-pretty` removed from ts/package.json | Unchanged |
| 5 | **Medium** | `create()` examples have empty data objects | New issue -- no example fields |
| 6 | **Low** | Feature descriptions terse ("TestFeature: Test") | New issue -- needs richer feature metadata |
| 7 | **Low** | Missing `ReadmeExplanation_ts` component (warning) | New minor gap |
| 8 | **Low** | Go install missing `replace` directive example | Minor regression vs original |

## Issues Resolved from Prior sdkgen Version

| # | Issue | Resolution |
|---|---|---|
| 1 | **Go README used TypeScript code examples** | **FIXED** -- all Go examples now idiomatic Go |
| 2 | **Go features list said "TypeScript definitions"** | **FIXED** -- Go-specific introduction |
| 3 | **Go Install/Quick Start sections were empty** | **FIXED** -- populated with Go content |
| 4 | **Go REFERENCE.md used TypeScript syntax** | **FIXED** -- now uses Go types and signatures |
| 5 | **TS README had no tutorial** | **FIXED** -- 4-step tutorial restored |
| 6 | **TS README had no how-to guides** | **FIXED** -- 6 how-to guides restored |
| 7 | **Tutorials and explanatory content dropped** | **FIXED** -- pipeline, entity state, direct vs entity all restored |
| 8 | **Direct API Access section duplicated in TS** | **FIXED** -- no longer duplicated |
| 9 | **TS Install used wrong code fence** | **FIXED** -- now uses ` ```bash ` |
| 10 | **Introduction section body was empty** | **FIXED** -- populated with descriptions |

## Recommendations

1. **Root README**: Update `Root.ts` / `Top.ts` to use the new `ReadmeTopQuick`,
   `ReadmeTopHowto`, and `ReadmeTopTest` components that sdkgen now provides.
   This should populate the root README with cross-language quick start,
   how-to, and testing content.
2. **Entity fields**: Ensure entity field descriptions are populated in the model
   (`.sdk/model/entity/planet.jsonic`, `moon.jsonic`) so they appear in the
   generated field tables.
3. **Entity API paths**: Verify that entity path information flows from the
   model/guide into the Readme templates.
4. **pino dependencies**: Verify whether pino is still imported in generated TS
   source; if so, restore to dependencies or update the template.
5. **Feature metadata**: Add richer descriptions to feature definitions in
   `.sdk/model/feature/test.jsonic` so generated docs say more than just "Test".
