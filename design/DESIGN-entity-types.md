# Design: Entity Type Definitions

> **Status: SUPERSEDED — delivered upstream by `@voxgig/sdkgen` 2.0.2**
> (2026-08-12). Kept as the record of the requirement; **do not implement it
> as written**.
>
> ### History
>
> PR #3 (`aa177cd`, 2026-04-17) merged this document only — no code was ever
> written. That turned out to be lucky: the "Files modified" tables below name
> `ts/src/types.ts`, `ts/src/SolardemoSDK.ts`, `go/entity/types.go` and
> `go/solardemo.go`, all of which are **generated output** under the
> repository's golden rule (`AGENTS.md`). Hand-editing them would have been
> erased by the next `npm run generate`.
>
> ### What ships now
>
> sdkgen's `EntityTypes_ts` / `EntityTypes_go` components generate typed models
> from `main.kit.entity.<e>.fields[]` and per-operation params, so they track
> the model automatically:
>
> - `ts/src/SolardemoTypes.ts` — `Moon`, `Planet`, plus `MoonLoadMatch`,
>   `MoonListMatch`, `MoonCreateData`, `MoonUpdateData`, `MoonRemoveMatch`
>   and the `Planet` equivalents.
> - `go/entity/types.go` — the same set as Go structs with JSON tags, feeding
>   `…Typed` operation variants.
>
> This is a **superset** of the proposal: it covers per-operation request
> shapes, not just the entity data shape, and the types are generated rather
> than hand-maintained.
>
> ### How the open questions landed
>
> | Question below | Resolution in 2.0.2 |
> | --- | --- |
> | Implementation route | Option 3 — upstream in sdkgen. |
> | Naming (`PlanetData` vs `Planet`) | Plain `Planet` / `Moon` for the entity shape; the `Data`/`Match` suffixes are reserved for per-operation payloads. |
> | Go `diameter` type | `float64`, as the proposal predicted — the model's `` `$NUMBER` `` does not distinguish int from float. |
> | Go optional fields | Value types with `omitempty`, not pointers. |
> | Scope | Extended: entity method signatures gain typed variants rather than staying `any` / `map[string]any` only. |
>
> The field tables below still match `.sdk/model/entity/*.aontu`
> (Planet: 10 fields, Moon: 5).
>
> Everything from "Context" onwards is the **original 2026-04 proposal**,
> preserved unchanged for the record.

---

## Context

The SDK currently uses `any` (TypeScript) and `map[string]any` (Go) for all entity
data throughout the public API. SDK consumers have no type information about what
fields a Planet or Moon entity contains. The entity field definitions exist in
`.sdk/model/entity/planet.aontu` and `.sdk/model/entity/moon.aontu` but are not
surfaced as types in either language SDK.

This change adds **consumer-facing** type definitions for entity data shapes. The
internal pipeline (feature hooks, context flow) intentionally uses untyped data and
must not be changed.


## Entity Fields (source of truth: `.sdk/model/entity/`)

### Planet

| Field    | Type    | Required |
|----------|---------|----------|
| id       | STRING  | yes      |
| name     | STRING  | yes      |
| kind     | STRING  | yes      |
| diameter | NUMBER  | yes      |
| forbid   | BOOLEAN | no       |
| ok       | BOOLEAN | no       |
| start    | BOOLEAN | no       |
| state    | STRING  | no       |
| stop     | BOOLEAN | no       |
| why      | STRING  | no       |

### Moon

| Field     | Type   | Required |
|-----------|--------|----------|
| id        | STRING | yes      |
| name      | STRING | yes      |
| planet_id | STRING | yes      |
| kind      | STRING | yes      |
| diameter  | NUMBER | yes      |


## Design Principles

1. **Consumer-facing only** -- types are for SDK users, not for the internal pipeline.
2. **Additive** -- no existing signatures or interfaces are changed.
3. **Idiomatic per language** -- TypeScript uses interfaces and utility types; Go uses
   structs with conversion helpers.
4. **Named to avoid collision** -- `PlanetData` / `MoonData` rather than `Planet` /
   `Moon`, which are already entity class/struct names.


## TypeScript

### New types in `ts/src/types.ts`

```typescript
interface PlanetData {
  id: string
  name: string
  kind: string
  diameter: number
  forbid?: boolean
  ok?: boolean
  start?: boolean
  state?: string
  stop?: boolean
  why?: string
}

interface MoonData {
  id: string
  name: string
  planet_id: string
  kind: string
  diameter: number
}
```

### Utility types

```typescript
// Create -- id may be server-generated
type PlanetCreateData = Omit<PlanetData, 'id'> & { id?: string }
type MoonCreateData   = Omit<MoonData, 'id'>   & { id?: string }

// Update -- only changed fields, id required
type PlanetUpdateData = Partial<PlanetData> & { id: string }
type MoonUpdateData   = Partial<MoonData>   & { id: string; planet_id: string }

// Match -- any subset of fields for load/list/remove
type PlanetMatch = Partial<PlanetData>
type MoonMatch   = Partial<MoonData>
```

### Re-export from package entry point

`ts/src/SolardemoSDK.ts` adds:

```typescript
export type {
  PlanetData,
  MoonData,
  PlanetCreateData,
  MoonCreateData,
  PlanetUpdateData,
  MoonUpdateData,
  PlanetMatch,
  MoonMatch,
} from './types'
```

This makes types available from the package root since `package.json` declares
`"types": "dist/SolardemoSDK.d.ts"`.

### What does NOT change

- Entity method signatures stay `any` -- the `this: any` pattern, `done()` returning
  `ctx.result.resdata`, and the feature hook pipeline all depend on untyped flow.
- `SolardemoEntityBase._data` stays `any`.
- No runtime behavior changes.

### Consumer usage

```typescript
import { SolardemoSDK } from '@voxgig-sdk/solardemo'
import type { PlanetData, PlanetCreateData } from '@voxgig-sdk/solardemo'

const sdk = new SolardemoSDK({ apikey: '...' })
const planet = sdk.Planet()

const created: PlanetData = await planet.create({
  name: 'Mars', kind: 'rocky', diameter: 6779
} satisfies PlanetCreateData)
```

### Files modified

| File | Change |
|------|--------|
| `ts/src/types.ts` | Add interfaces and type aliases |
| `ts/src/SolardemoSDK.ts` | Add type re-exports |


## Go

### New file: `go/entity/types.go`

#### Structs

```go
type PlanetData struct {
    ID       string  `json:"id"`
    Name     string  `json:"name"`
    Kind     string  `json:"kind"`
    Diameter float64 `json:"diameter"`
    Forbid   *bool   `json:"forbid,omitempty"`
    Ok       *bool   `json:"ok,omitempty"`
    Start    *bool   `json:"start,omitempty"`
    State    *string `json:"state,omitempty"`
    Stop     *bool   `json:"stop,omitempty"`
    Why      *string `json:"why,omitempty"`
}

type MoonData struct {
    ID       string  `json:"id"`
    Name     string  `json:"name"`
    PlanetID string  `json:"planet_id"`
    Kind     string  `json:"kind"`
    Diameter float64 `json:"diameter"`
}
```

Design decisions:
- `Diameter` is `float64` because Go's `encoding/json` unmarshals JSON numbers as
  `float64` in `map[string]any`. Using `int` would cause conversion friction.
- Optional boolean fields use `*bool` to distinguish "not set" from `false`.
- Optional string fields use `*string` for the same reason.
- JSON tags use snake_case matching the wire format.

#### Conversion functions

```go
func (p PlanetData) ToMap() map[string]any { ... }
func PlanetDataFromMap(m map[string]any) PlanetData { ... }

func (md MoonData) ToMap() map[string]any { ... }
func MoonDataFromMap(m map[string]any) MoonData { ... }
```

`ToMap` builds a `map[string]any` suitable for passing to SDK entity methods.
`FromMap` extracts typed fields from a `map[string]any` result with safe type
assertions.

### Re-export from `go/solardemo.go`

```go
type PlanetData = entity.PlanetData
type MoonData   = entity.MoonData

var PlanetDataFromMap = entity.PlanetDataFromMap
var MoonDataFromMap   = entity.MoonDataFromMap
```

The `entity` package is already imported in `solardemo.go`.

### What does NOT change

- `SolardemoEntity` interface in `go/core/types.go` -- method signatures stay
  `map[string]any`.
- Entity method implementations stay untyped.
- No runtime behavior changes.

### Consumer usage

```go
import sdk "voxgigsolardemosdk"
import "voxgigsolardemosdk/core"

client := sdk.NewSolardemoSDK(opts)
ent := client.Planet(nil)

// Create with typed data
pd := sdk.PlanetData{Name: "Mars", Kind: "rocky", Diameter: 6779}
result, err := ent.Create(pd.ToMap(), nil)

// Parse result
planet := sdk.PlanetDataFromMap(core.ToMapAny(result))
fmt.Println(planet.Name) // "Mars"
```

### Files modified

| File | Change |
|------|--------|
| `go/entity/types.go` | New file -- structs and conversion functions |
| `go/solardemo.go` | Add type aliases and function re-exports |


## Verification

1. **TypeScript**: `cd ts && npm install && npm run build && npm test` -- compilation
   succeeds, all tests pass, `dist/SolardemoSDK.d.ts` includes new type exports.
2. **Go**: `cd go && go build ./... && go test ./...` -- compilation succeeds, all
   tests pass.
3. **Generation**: `cd .sdk && npm run build && npm run generate` -- the new types
   survive regeneration and `git status` shows no unexpected churn. **This step is
   the one the design does not currently satisfy.**


## Implementation route

> **Resolved: option 3.** sdkgen 2.0.2 ships `EntityTypes_{ts,go}`. Nothing
> below needs doing — kept to show the reasoning that pointed upstream.

The design has to be re-expressed as generator work before it can be
built. Three options, in rough order of preference:

1. **New per-target components.** Add `.sdk/src/cmp/ts/Types_ts.ts` and
   `.sdk/src/cmp/go/Types_go.ts` that read `entity.fields` from the model and
   emit `ts/src/entity-types.ts` / `go/entity/types.go`, then wire the re-exports
   through the existing `Main`/`Package` components. Types stay in sync with the
   model automatically. Note this runs into **E3** in
   [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) — there is no
   registration hook for a new per-target component, so dispatch would be
   hand-wired in `Root.ts` as the `Agents` components already are.
2. **Template-master files.** Put hand-written types under `.sdk/tm/ts/src/` and
   `.sdk/tm/go/entity/`. Simpler, but the types then no longer track the model —
   adding a field to `planet.aontu` would silently not update them.
3. **Upstream in sdkgen.** Typed entity data is a general SDK-quality feature,
   not a solardemo-specific one. If sdkgen grows it, this document becomes a
   requirements note rather than a plan.

Secondary open questions, all deferred until the route above is chosen:

- **Naming.** `PlanetData` vs `Planet` — the design picks `PlanetData` to avoid
  colliding with the existing entity class/struct names. Fine, but a generated
  solution should take the name from a model setting rather than a hardcoded
  suffix.
- **`diameter` type in Go.** The design chooses `float64` because
  `encoding/json` unmarshals numbers into `float64`. The model says
  `` `$NUMBER` ``, which does not distinguish integer from float — so a
  generator cannot do better than `float64` without a model change.
- **Optional-field representation in Go.** The design uses pointer types
  (`*bool`, `*string`) to separate "unset" from zero. That is right for `update`
  but noisy for read paths; a generator may want both a strict and a loose
  struct, or `omitempty` value types.
- **Scope.** The design deliberately covers only data shapes, leaving method
  signatures `any` / `map[string]any`. Worth confirming that is still the
  intent, since it limits how much the types actually help a consumer.
