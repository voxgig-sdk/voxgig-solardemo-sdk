# Design: Entity Type Definitions

## Context

The SDK currently uses `any` (TypeScript) and `map[string]any` (Go) for all entity
data throughout the public API. SDK consumers have no type information about what
fields a Planet or Moon entity contains. The entity field definitions exist in
`.sdk/model/entity/planet.jsonic` and `.sdk/model/entity/moon.jsonic` but are not
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

1. **TypeScript**: `cd ts && npm run build && npm test` -- compilation succeeds, all
   tests pass, `dist/SolardemoSDK.d.ts` includes new type exports.
2. **Go**: `cd go && go build ./... && go test ./...` -- compilation succeeds, all
   tests pass.
