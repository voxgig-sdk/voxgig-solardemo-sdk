# Solardemo Go SDK

The Go SDK for the Solardemo API. Provides an entity-oriented interface
using standard Go conventions — no generics required, data flows as
`map[string]any`.


## Install

```bash
go get voxgigsolardemosdk
```

The module uses a local `replace` directive for the struct utility:

```
require github.com/voxgig/struct v0.0.0
replace github.com/voxgig/struct => ./utility/struct
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing planets, and
loading a specific moon.

### 1. Create a client

```go
package main

import (
    "fmt"
    "os"

    sdk "voxgigsolardemosdk"
    "voxgigsolardemosdk/core"
)

func main() {
    client := sdk.NewSolardemoSDK(map[string]any{
        "apikey": os.Getenv("SOLARDEMO_APIKEY"),
    })
```

### 2. List planets

```go
    result, err := client.Planet(nil).List(nil, nil)
    if err != nil {
        panic(err)
    }

    rm := core.ToMapAny(result)
    if rm["ok"] == true {
        for _, item := range rm["data"].([]any) {
            p := core.ToMapAny(item)
            fmt.Println(p["id"], p["name"])
        }
    }
```

### 3. Load a moon

Moon is nested under Planet, so provide the `planet_id`:

```go
    moon := client.Moon(nil)
    result, err = moon.Load(
        map[string]any{"planet_id": "earth", "id": "luna"}, nil,
    )
    if err != nil {
        panic(err)
    }

    rm = core.ToMapAny(result)
    if rm["ok"] == true {
        fmt.Println(rm["data"])
    }
}
```

### 4. Create, update, and remove

```go
// Create
created, _ := client.Moon(nil).Create(
    map[string]any{"planet_id": "earth", "name": "Deimos"}, nil,
)
cm := core.ToMapAny(created)
newID := core.ToMapAny(cm["data"])["id"]

// Update
client.Moon(nil).Update(
    map[string]any{"planet_id": "earth", "id": newID, "name": "Deimos-Renamed"}, nil,
)

// Remove
client.Moon(nil).Remove(
    map[string]any{"planet_id": "earth", "id": newID}, nil,
)
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```go
result, err := client.Direct(map[string]any{
    "path":   "/api/planet/{id}",
    "method": "GET",
    "params": map[string]any{"id": "mars"},
})
if err != nil {
    panic(err)
}

if result["ok"] == true {
    fmt.Println(result["status"]) // 200
    fmt.Println(result["data"])   // response body
}
```

### Prepare a request without sending it

```go
fetchdef, err := client.Prepare(map[string]any{
    "path":   "/api/planet/{id}",
    "method": "DELETE",
    "params": map[string]any{"id": "mars"},
})
if err != nil {
    panic(err)
}

fmt.Println(fetchdef["url"])
fmt.Println(fetchdef["method"])
fmt.Println(fetchdef["headers"])
```

### Use test mode

Create a mock client for unit testing — no server required:

```go
client := sdk.TestSDK(nil, nil)

result, err := client.Planet(nil).Load(
    map[string]any{"id": "test01"}, nil,
)
// result contains mock response data
```

### Use a custom fetch function

Replace the HTTP transport with your own function:

```go
mockFetch := func(url string, init map[string]any) (map[string]any, error) {
    return map[string]any{
        "status":     200,
        "statusText": "OK",
        "headers":    map[string]any{},
        "json": (func() any)(func() any {
            return map[string]any{"id": "mock01"}
        }),
    }, nil
}

client := sdk.NewSolardemoSDK(map[string]any{
    "base": "http://localhost:8080",
    "system": map[string]any{
        "fetch": (func(string, map[string]any) (map[string]any, error))(mockFetch),
    },
})
```

### Run live tests

Create a `.env.local` file at the project root:

```
SOLARDEMO_TEST_LIVE=TRUE
SOLARDEMO_APIKEY=<your-key>
SOLARDEMO_TEST_MOON_ENTID={"planet01":"earth"}
SOLARDEMO_TEST_PLANET_ENTID={}
```

Then run:

```bash
cd go && go test ./test/...
```


## Reference

### NewSolardemoSDK

```go
func NewSolardemoSDK(options map[string]any) *SolardemoSDK
```

Creates a new SDK client.

| Option | Type | Description |
| --- | --- | --- |
| `"apikey"` | `string` | API key for authentication. |
| `"base"` | `string` | Base URL of the API server. |
| `"prefix"` | `string` | URL path prefix prepended to all requests. |
| `"suffix"` | `string` | URL path suffix appended to all requests. |
| `"feature"` | `map[string]any` | Feature activation flags. |
| `"extend"` | `[]any` | Additional Feature instances to load. |
| `"system"` | `map[string]any` | System overrides (e.g. custom `"fetch"` function). |

### TestSDK

```go
func TestSDK(testopts map[string]any, sdkopts map[string]any) *SolardemoSDK
```

Creates a test-mode client with mock transport. Both arguments may be `nil`.

### SolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `OptionsMap` | `() map[string]any` | Deep copy of current SDK options. |
| `GetUtility` | `() *Utility` | Copy of the SDK utility object. |
| `Prepare` | `(fetchargs map[string]any) (map[string]any, error)` | Build an HTTP request definition without sending. |
| `Direct` | `(fetchargs map[string]any) (map[string]any, error)` | Build and send an HTTP request. |
| `Moon` | `(data map[string]any) SolardemoEntity` | Create a Moon entity instance. |
| `Planet` | `(data map[string]any) SolardemoEntity` | Create a Planet entity instance. |

### Entity interface (SolardemoEntity)

All entities implement the `SolardemoEntity` interface.

| Method | Signature | Description |
| --- | --- | --- |
| `Load` | `(reqmatch, ctrl map[string]any) (any, error)` | Load a single entity by match criteria. |
| `List` | `(reqmatch, ctrl map[string]any) (any, error)` | List entities matching the criteria. |
| `Create` | `(reqdata, ctrl map[string]any) (any, error)` | Create a new entity. |
| `Update` | `(reqdata, ctrl map[string]any) (any, error)` | Update an existing entity. |
| `Remove` | `(reqmatch, ctrl map[string]any) (any, error)` | Remove an entity. |
| `Data` | `(args ...any) any` | Get or set entity data. |
| `Match` | `(args ...any) any` | Get or set entity match criteria. |
| `Make` | `() Entity` | Create a new instance with the same options. |
| `GetName` | `() string` | Return the entity name. |

### Result shape

Entity operations return `(any, error)`. The `any` value is a
`map[string]any` with these keys:

| Key | Type | Description |
| --- | --- | --- |
| `"ok"` | `bool` | `true` if the HTTP status is 2xx. |
| `"status"` | `int` | HTTP status code. |
| `"headers"` | `map[string]any` | Response headers. |
| `"data"` | `any` | Parsed JSON response body. |

On error, `"ok"` is `false` and `"err"` contains the error value.

### Direct result shape

`Direct()` returns `(map[string]any, error)` with the same keys as
entity results: `"ok"`, `"status"`, `"headers"`, `"data"`.

### FetchDef shape

`Prepare()` returns `(map[string]any, error)`. The map contains:

| Key | Type | Description |
| --- | --- | --- |
| `"url"` | `string` | Fully resolved URL. |
| `"method"` | `string` | HTTP method. |
| `"headers"` | `map[string]any` | Request headers. |
| `"body"` | `any` | Request body (may be nil). |

### Entities

#### Planet

| Field | Description |
| --- | --- |
| `"id"` | Unique planet identifier. |

Operations: Load, List, Create, Update, Remove.

API path: `/api/planet/{id}`

#### Moon

| Field | Description |
| --- | --- |
| `"id"` | Unique moon identifier. |
| `"planet_id"` | Parent planet identifier (required for all operations). |

Operations: Load, List, Create, Update, Remove.

API path: `/api/planet/{planet_id}/moon/{id}`

### Type exports

The root package re-exports all core types for convenience:

```go
type SolardemoSDK = core.SolardemoSDK
type Context = core.Context
type Utility = core.Utility
type Feature = core.Feature
type Entity = core.Entity
type SolardemoEntity = core.SolardemoEntity
type Spec = core.Spec
type Result = core.Result
type Response = core.Response
type Operation = core.Operation
type Control = core.Control
type SolardemoError = core.SolardemoError
type BaseFeature = feature.BaseFeature
```

### Helper functions

| Function | Package | Description |
| --- | --- | --- |
| `core.ToMapAny(v)` | core | Safely cast `any` to `map[string]any`. |
| `core.ToInt(v)` | core | Safely cast `any` to `int`. |


## Explanation

### The operation pipeline

Every entity operation follows a six-stage pipeline. Each stage fires
a feature hook before executing:

```
PrePoint → PreSpec → PreRequest → PreResponse → PreResult → PreDone
```

- **PrePoint**: Resolves which API endpoint to call based on the
  operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body —
  from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here
  to replace the transport (as TestFeature does with mocks).
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity
  state (match, data) is updated here.

If any stage returns an error, the pipeline short-circuits and the
error is returned to the caller. An unexpected panic triggers the
`PreUnexpected` hook.

### Features and hooks

Features are the extension mechanism. A feature implements the
`Feature` interface and provides hooks — functions keyed by pipeline
stage names.

The SDK ships with three built-in features:

- **BaseFeature**: Core request/response logic. Always active.
- **TestFeature**: Replaces the real HTTP fetcher with an in-memory
  mock. Activated when `feature.test.active` is `true`.
- **LogFeature**: Adds logging at each pipeline stage.

Features initialize in order. Hooks fire in the order features were
added, so later features can override earlier ones.

### Data as maps

The Go SDK uses `map[string]any` throughout rather than typed structs.
This mirrors the dynamic nature of the API and keeps the SDK
flexible — no code generation is needed when the API schema changes.

Use `core.ToMapAny()` to safely cast results and nested data.

### Entity state

Entity instances are stateful. After a successful `Load`, the entity
stores the returned data and match criteria internally.

```go
moon := client.Moon(nil)
moon.Load(map[string]any{"planet_id": "earth", "id": "luna"}, nil)

// moon.Data() now returns the loaded moon data
// moon.Match() returns the last match criteria
```

Call `Make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

`Direct()` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `Prepare()` builds the request without sending it — useful
for debugging or custom transport.

### Package structure

```
voxgigsolardemosdk/
├── solardemo.go        # Root package — type aliases and constructors
├── core/               # SDK core — client, types, pipeline
├── entity/             # Entity implementations (Moon, Planet)
├── feature/            # Built-in features (Base, Test, Log)
├── utility/            # Utility functions and struct library
└── test/               # Test suites
```

The root package (`voxgigsolardemosdk`) re-exports everything needed
for normal use. Import sub-packages only when you need specific types
like `core.ToMapAny`.
