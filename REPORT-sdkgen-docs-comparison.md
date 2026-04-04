# Report: sdkgen Update & Documentation Comparison

## What was done
- Updated `@voxgig/sdkgen` to latest GitHub main (v0.35.2)
- Rebuilt `.sdk/` templates and regenerated both **TypeScript** and **Go** targets
- 5 files changed: 175 insertions, 938 deletions

## Files Changed

| File | Change |
|---|---|
| `.sdk/package.json` | Dependency ordering normalized (alphabetized) |
| `ts/package.json` | Removed `pino`/`pino-pretty` from dependencies, added empty `peerDependencies` |
| `README.md` | Drastically reduced (234 -> 9 lines) |
| `ts/README.md` | Restructured (368 -> 155 lines) |
| `go/README.md` | Restructured (425 -> 125 lines) |
| `ts/REFERENCE.md` | Unchanged (already existed) |
| `go/REFERENCE.md` | Unchanged (already existed) |

## Documentation Comparison: Old vs New

### Root `README.md`
- **Old**: Comprehensive 234-line document with architecture overview, quick start examples for both languages, testing guide, how-to guides, and links to language-specific docs
- **New**: Minimal 9-line stub with just a title ("Solardemo SDKs"), an empty mermaid diagram, and an "API Entities" heading
- **Assessment**: **Significant regression** -- nearly all content was removed. The new template generates only a skeleton.

### `ts/README.md`
- **Old** (368 lines): Full tutorial (4-step walkthrough), 5 how-to guides (direct requests, prepare, test mode, entity state, custom middleware, live tests), complete API reference (constructor, methods, entities, result shapes, pipeline explanation, features/hooks deep dive)
- **New** (155 lines): Concise structure with Introduction, Install, Quick Start, SDK Structure (client/entity method tables), Direct API Access, Testing, and a pointer to `REFERENCE.md`
- **Assessment**: **Content was moved/split** -- reference material now lives in `REFERENCE.md`. However, the new README drops tutorials, how-to guides, entity state explanation, pipeline explanation, and custom middleware examples. Code examples use generic paths (`/api/v1/resource/{id}`) instead of domain-specific ones (`/api/planet/{id}`).

### `go/README.md`
- **Old** (425 lines): Full Go-specific tutorial with idiomatic Go code, 5 how-to guides, complete Go API reference (type signatures, Go conventions), pipeline explanation, package structure overview
- **New** (125 lines): Same template structure as TypeScript but with **TypeScript code examples** instead of Go -- shows `const client = new SolardemoSDK(...)` instead of Go code
- **Assessment**: **Significant issues** -- (1) Go README uses TypeScript syntax/examples, not Go. (2) States "Type safe: full TypeScript definitions included" in the Go SDK features list. (3) Missing Go-specific install instructions (`go get`), Go-specific type information, and `map[string]any` patterns. The generation warnings `require-missing: ./cmp/go/ReadmeInstall_go` and `./cmp/go/ReadmeQuick_go` confirm that Go-specific Readme sub-components don't exist yet, so the generator fell back to the generic/TS templates.

## Key Issues Found

1. **Root README is a stub** -- the new sdkgen template produces an empty mermaid diagram and no real content
2. **Go README uses TypeScript code** -- missing `ReadmeInstall_go` and `ReadmeQuick_go` components in sdkgen cause wrong-language examples
3. **Go features list says "TypeScript definitions"** -- generic template text not adapted for Go
4. **`ts/package.json` lost pino dependencies** -- `pino` and `pino-pretty` removed from dependencies, which may break logging at runtime
5. **Tutorials and explanatory content removed** -- the old docs had rich tutorials and architectural explanations that the new template-generated docs don't replicate
6. **REFERENCE.md files are identical for both languages** -- both use TypeScript syntax (`new SolardemoSDK(...)`, `Promise<...>`) rather than language-appropriate signatures
