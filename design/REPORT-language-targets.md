# Report: Language Targets Supported by sdkgen

Date: 2026-06-08
Task: "generate language targets for all available languages supported by sdkgen."

## Outcome

The pinned generator — `@voxgig/sdkgen` resolved from `github:voxgig/sdkgen#main`
to **version 0.35.2** — can only generate **two** working targets:
**TypeScript (`ts`)** and **Go (`go`)**. Both already exist in this repo. The
other languages it appears to "support" are **not generatable** in this version:

| Language | target model | `cmp/` generators | `tm/` templates | Generatable? |
| --- | --- | --- | --- | --- |
| `ts` (TypeScript) | ✅ | ✅ full | ✅ full | ✅ yes (present) |
| `go` (Go) | ✅ | ✅ full | ✅ full | ✅ yes (present) |
| `js` (JavaScript) | ✅ | ⚠️ partial/older | ❌ incomplete | ❌ **no** |
| `py` (Python) | ❌ | ❌ | ❌ stub only | ❌ **no** |

No target was added — doing so would have required hand-authoring sdkgen's own
JS/Python runtime, which is generating *around* the tool rather than *with* it.

## Evidence

### JavaScript (`js`) — half-baked in 0.35.2

`js` ships a target model (`model/target/js.jsonic`) and a `cmp/js/` generator
set, so it looks supported, but:

1. **`voxgig-sdkgen target add js` fails.** The scaffolder copies
   `tm/js/src/feature/README.md`, which does not exist in the shipped base:
   ```
   ShapeError: Copy: (solardemo: tm/js/src/feature): ENOENT ...
     tm/js/src/feature/README.md
   ```

2. **The `tm/js` template tree is missing feature templates.** Compared with the
   working `tm/ts`:
   - `tm/ts/src/feature/` has `README.md`, `base/BaseFeature.ts`,
     `test/TestFeature.ts`, `log/LogFeature.ts`.
   - `tm/js/src/feature/` has **only** `log/LogFeature.js` — no `base/`, no
     `test/`, no `README.md`.
   A manual scaffold + `generate` confirmed this: generation aborts with
   ```
   ShapeError: Copy: (solardemo: js/src/feature/test): ENOENT  tm/js/src/feature/test
   ```

3. **Mismatched utility architecture.** `tm/js/src/utility/` uses an older naming
   scheme (`AuthUtility`, `BodyUtility`, `FullurlUtility`, `JoinurlUtility`,
   `ReqformUtility`, …) unrelated to the `tm/ts` `Make*Utility` scheme, and
   `cmp/js/` is a smaller, older component set than `cmp/ts/` (e.g. no
   `EntityBase_js`, only `ReadmeInstall`/`ReadmeQuick`, not the full Readme set).
   `tm/js` and `cmp/js` are from a different, abandoned sdkgen vintage.

Conclusion: the `js` target was not maintained to the same level as `ts`/`go` in
0.35.2. Producing a working JS SDK would mean writing the missing feature
runtime and reconciling the utility architecture by hand — i.e. authoring, not
generating.

### Python (`py`) — stub only

- `model/target/py.jsonic`: **absent**.
- `src/cmp/py/`: **absent**.
- `tm/py/`: contains **only** `LICENSE` (no source/runtime templates).

Python is a placeholder in 0.35.2. Nothing can be generated.

## Available runtimes ≠ supported targets

For the record, the environment has runtimes for many languages
(`python3` 3.11, `java` 21, `rustc`/`cargo` 1.94, `ruby` 3.3, `php` 8.4; `dotnet`
absent), but sdkgen 0.35.2 has no `cmp`/`tm` for any of them. The constraint is
the generator's templates, not the toolchain.

## Recommendations

1. **Treat `ts` + `go` as the supported set** for this pinned sdkgen.
2. To add **JavaScript**, the upstream `voxgig/sdkgen` base project needs a
   complete `tm/js` (feature `base`/`test`/`README` templates) and a `cmp/js`
   set aligned with the current utility architecture — fixes that belong in the
   sdkgen repo, not here.
3. **Consider the npm-published `@voxgig/sdkgen@1.2.1`** (the registry latest;
   this project pins `github#main` = 0.35.2). A newer major *may* ship complete
   `js`/`py` targets — but switching the generator is a separate, higher-risk
   change (it would regenerate `ts`/`go` from newer templates, with an unknown
   diff) and was out of scope here. Evaluate it deliberately before adopting.

## What this repo already provides

The two working targets are fully generated, build, and test green
(TypeScript: 128 tests; Go: build/vet/test), and now carry agent docs
(`AGENTS.md` + `CLAUDE.md`) and accurate per-SDK usage guides.
