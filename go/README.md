# VoxgigSolardemo Go SDK



The Go SDK for the VoxgigSolardemo API — an entity-oriented client using standard Go conventions. No generics required; data flows as `map[string]any`.

It exposes the API as capitalised, semantic **Entities** — e.g. `client.Moon(nil)` — each with the same small set of operations (`List`, `Load`, `Create`, `Update`, `Remove`) instead of raw URL paths and query strings. You call meaning, not endpoints, which keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
```bash
go get github.com/voxgig-sdk/voxgig-solardemo-sdk/go@latest
```

The Go module proxy resolves the version from the `go/vX.Y.Z` GitHub
release tag — see [Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags) for the available versions.

To vendor from a local checkout instead, clone this repo alongside your
project and add a `replace` directive pointing at the checked-out
`go/` directory:

```bash
go mod edit -replace github.com/voxgig-sdk/voxgig-solardemo-sdk/go=../voxgig-solardemo-sdk/go
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and loading a specific record.

### Quickstart

A complete program: create a client, then call the entity operations.
Each operation returns `(value, error)` — the value is the entity, and for
`List` a `[]any` of entities, one per record (there is no `{ok, data}`
wrapper), so check `err` and read a record through the entity's
`Data()`.

```go
package main

import (
    "fmt"
    sdk "github.com/voxgig-sdk/voxgig-solardemo-sdk/go"
)

func main() {
    client, err := sdk.New()
    if err != nil {
        panic(err)
    }

    // List moon records — the value is a []any of entities, one per record.
    moons, err := client.Moon(nil).List(map[string]any{"planet_id": "example"}, nil)
    if err != nil {
        panic(err)
    }
    for _, item := range moons.([]any) {
        fmt.Println(item.(sdk.Entity).Data())
    }

    // Load a single moon — the value is the entity; Data() reads its record.
    moon, err := client.Moon(nil).Load(map[string]any{"id": "example_id", "planet_id": "example_planet_id"}, nil)
    if err != nil {
        panic(err)
    }
    fmt.Println(moon.(sdk.Entity).Data())

    // Create a moon.
    created, err := client.Moon(nil).Create(map[string]any{"planet_id": "example_planet_id", "diameter": 1, "id": "example_id", "kind": "example_kind", "name": "example_name"}, nil)
    if err != nil {
        panic(err)
    }
    fmt.Println(created.(sdk.Entity).Data())

    // Update a moon.
    updated, err := client.Moon(nil).Update(map[string]any{"id": "example_id", "planet_id": "example_planet_id", "diameter": 1}, nil)
    if err != nil {
        panic(err)
    }
    fmt.Println(updated.(sdk.Entity).Data())

    // Remove a moon.
    removed, err := client.Moon(nil).Remove(map[string]any{"id": "example_id", "planet_id": "example_planet_id"}, nil)
    if err != nil {
        panic(err)
    }
    fmt.Println(removed.(sdk.Entity).Data())
}
```


## Error handling

Every entity operation returns `(value, error)`. Check `err` before
using the value — there is no exception to catch:

```go
planets, err := client.Planet(nil).List(nil, nil)
if err != nil {
    // handle err
    return
}
_ = planets
```

`Direct` follows the same `(value, error)` convention:

```go
result, err := client.Direct(map[string]any{
    "path":   "/api/planet/{planet_id}/moon",
    "method": "GET",
    "params": map[string]any{"planet_id": "example_id"},
})
if err != nil {
    // handle err
}
_ = result
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```go
result, err := client.Direct(map[string]any{
    "path":   "/api/planet/{planet_id}/moon",
    "method": "GET",
    "params": map[string]any{"planet_id": "example"},
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
    "path":   "/api/planet/{planet_id}/moon",
    "method": "GET",
    "params": map[string]any{"planet_id": "example"},
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
client := sdk.Test()

planets, err := client.Planet(nil).List(
    nil, nil,
)
if err != nil {
    panic(err)
}
// A []any of entities, one per mock record.
for _, item := range planets.([]any) {
    fmt.Println(item.(sdk.Entity).Data())
}
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

client, err := sdk.NewVoxgigSolardemoSDK(map[string]any{
    "base": "http://localhost:8080",
    "system": map[string]any{
        "fetch": (func(string, map[string]any) (map[string]any, error))(mockFetch),
    },
})
if err != nil {
    panic(err)
}
```

### Run live tests

Create a `.env.local` file at the project root:

```
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Each entity's tests also read `VOXGIG_SOLARDEMO_TEST_<ENTITY>_ENTID`, with the
entity's name in capitals: a JSON object of the ids of existing records, for
the tests that do not create their own.

Then run:

```bash
cd go && go test ./test/...
```


## Reference

### NewVoxgigSolardemoSDK

```go
func NewVoxgigSolardemoSDK(options map[string]any) (*VoxgigSolardemoSDK, error)
```

Creates a new SDK client.

| Option | Type | Description |
| --- | --- | --- |
| `"base"` | `string` | Base URL of the API server. |
| `"prefix"` | `string` | URL path prefix prepended to all requests. |
| `"suffix"` | `string` | URL path suffix appended to all requests. |
| `"headers"` | `map[string]any` | Headers sent with every request. |
| `"feature"` | `map[string]any` | Feature activation flags. |
| `"extend"` | `[]any` | Additional feature instances to load. |
| `"system"` | `map[string]any` | System overrides, such as a custom fetch function. |

### TestSDK

```go
func TestSDK(testopts map[string]any, sdkopts map[string]any) *VoxgigSolardemoSDK
```

Creates a test-mode client with mock transport. Both arguments may be `nil`.

### VoxgigSolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `OptionsMap` | `() map[string]any` | Deep copy of current SDK options. |
| `GetUtility` | `() *Utility` | Copy of the SDK utility object. |
| `Prepare` | `(fetchargs map[string]any) (map[string]any, error)` | Build an HTTP request definition without sending. |
| `Direct` | `(fetchargs map[string]any) (map[string]any, error)` | Build and send an HTTP request. |
| `Moon` | `(data map[string]any) VoxgigSolardemoEntityBase` | Create a Moon entity instance. |
| `Planet` | `(data map[string]any) VoxgigSolardemoEntityBase` | Create a Planet entity instance. |

### Entity interface (VoxgigSolardemoEntityBase)

All entities implement the `VoxgigSolardemoEntityBase` interface.

| Method | Signature | Description |
| --- | --- | --- |
| `Load` | `(reqmatch, ctrl map[string]any) (any, error)` | Load a single entity by match criteria, and return it. |
| `List` | `(reqmatch, ctrl map[string]any) (any, error)` | List entities matching the criteria, one per record. |
| `Create` | `(reqdata, ctrl map[string]any) (any, error)` | Create a new entity, and return it. |
| `Update` | `(reqdata, ctrl map[string]any) (any, error)` | Update an existing entity, and return it. |
| `Remove` | `(reqmatch, ctrl map[string]any) (any, error)` | Remove an entity, and return it marked as deleted. |
| `Data` | `(args ...any) any` | Get or set entity data. |
| `Match` | `(args ...any) any` | Get or set entity match criteria. |
| `Make` | `() Entity` | Create a new instance with the same options. |
| `GetName` | `() string` | Return the entity name. |

### Result shape

Entity operations return `(value, error)`. The `value` is the entity
itself — there is no wrapper:

| Operation | `value` |
| --- | --- |
| `Load` / `Create` / `Update` / `Remove` | the entity, whose `Data()` reads its record (`map[string]any`) |
| `List` | a `[]any` of entities, one per record |

Check `err` first, then use the value directly (or the typed
`...Typed` variants, which return the entity's model struct and a typed
slice):

    moon, err := client.Moon(nil).List(map[string]any{"planet_id": "example"}, nil)
    if err != nil { /* handle */ }
    // moon is a []any of entities, one per record

Only `Direct()` returns a response envelope — a `map[string]any` with
`"ok"`, `"status"`, `"headers"`, and `"data"` keys.

### Entities

#### Moon

| Field | Description |
| --- | --- |
| `"diameter"` |  |
| `"id"` |  |
| `"kind"` |  |
| `"name"` |  |
| `"planet_id"` |  |

Operations: List, Load, Create, Update, Remove.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `"diameter"` |  |
| `"forbidReason"` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `"forbidState"` | Set by the forbid action, and absent until it first runs. |
| `"id"` |  |
| `"kind"` |  |
| `"name"` |  |
| `"terraformState"` | Set by the terraform action, and absent until it first runs. |

Operations: List, Load, Create, Update, Remove.

API path: `/api/planet`



## Entities


### Moon

Create an instance: `moon := client.Moon(nil)`

#### Operations

| Method | Description |
| --- | --- |
| `List(match, ctrl)` | List entities matching the criteria. |
| `Load(match, ctrl)` | Load a single entity by match criteria. |
| `Create(data, ctrl)` | Create a new entity with the given data. |
| `Update(data, ctrl)` | Update an existing entity. |
| `Remove(match, ctrl)` | Remove the matching entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `float64` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `planet_id` | `string` |  |

#### Example: Load

```go
moon, err := client.Moon(nil).Load(map[string]any{"id": "moon_id", "planet_id": "planet_id"}, nil)
if err != nil {
    panic(err)
}
fmt.Println(moon.(sdk.Entity).Data()) // the loaded entity's record
```

#### Example: List

```go
moons, err := client.Moon(nil).List(map[string]any{"planet_id": "example"}, nil)
if err != nil {
    panic(err)
}
// A []any of entities, one per record.
for _, item := range moons.([]any) {
    fmt.Println(item.(sdk.Entity).Data())
}
```

#### Example: Create

```go
result, err := client.Moon(nil).Create(map[string]any{
    "planet_id": "example_planet_id",
    "diameter": 1,
    "id": "example_id",
    "kind": "example_kind",
    "name": "example_name",
}, nil)
if err != nil {
    panic(err)
}
fmt.Println(result.(sdk.Entity).Data()) // the created entity's record
```


### Planet

Create an instance: `planet := client.Planet(nil)`

#### Operations

| Method | Description |
| --- | --- |
| `List(match, ctrl)` | List entities matching the criteria. |
| `Load(match, ctrl)` | Load a single entity by match criteria. |
| `Create(data, ctrl)` | Create a new entity with the given data. |
| `Update(data, ctrl)` | Update an existing entity. |
| `Remove(match, ctrl)` | Remove the matching entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `float64` |  |
| `forbidReason` | `string` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `string` | Set by the forbid action, and absent until it first runs. |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `terraformState` | `string` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```go
planet, err := client.Planet(nil).Load(map[string]any{"id": "planet_id"}, nil)
if err != nil {
    panic(err)
}
fmt.Println(planet.(sdk.Entity).Data()) // the loaded entity's record
```

#### Example: List

```go
planets, err := client.Planet(nil).List(nil, nil)
if err != nil {
    panic(err)
}
// A []any of entities, one per record.
for _, item := range planets.([]any) {
    fmt.Println(item.(sdk.Entity).Data())
}
```

#### Example: Create

```go
result, err := client.Planet(nil).Create(map[string]any{
    "diameter": 1,
    "id": "example_id",
    "kind": "example_kind",
    "name": "example_name",
}, nil)
if err != nil {
    panic(err)
}
fmt.Println(result.(sdk.Entity).Data()) // the created entity's record
```

## Features

This SDK ships 9 optional features.
Each is **inactive until you switch it on**, so an SDK you have not
configured behaves exactly as if none of them existed, with no measurable overhead.

Activate a feature by name in the `feature` client option:

| Feature | What it does |
|---|---|
| [`debug`](#debug) | Debug capture |
| [`idempotency`](#idempotency) | Idempotency |
| [`metrics`](#metrics) | Metrics |
| [`paging`](#paging) | Paging |
| [`ratelimit`](#ratelimit) | Rate limiting |
| [`retry`](#retry) | Retry |
| [`secrets`](#secrets) | Secrets |
| [`test`](#test) | Test transport |
| [`timeout`](#timeout) | Timeout |

> **Order matters for `ratelimit`, `retry`, `secrets`, `timeout`.** These wrap the
> transport, so each one wraps whatever is already installed: the order you
> activate them in IS the nesting order. Activating them as an ordered list
> rather than a map is what fixes that order.

### debug

Debug capture.

| Option | Default |
|---|---|
| `active` | `false` |
| `max` | `100` |
| `redact` | `['authorization', 'cookie', 'set-cookie', 'api-key', 'apikey', 'x-api-key', 'idempotency-key']` |

Set `feature.debug.active` to enable it, then override any of the options above.

### idempotency

Idempotency.

| Option | Default |
|---|---|
| `active` | `false` |
| `header` | `'Idempotency-Key'` |
| `methods` | `['POST', 'PUT', 'PATCH', 'DELETE']` |
| `ops` | `['create', 'update', 'remove']` |

Set `feature.idempotency.active` to enable it, then override any of the options above.

### metrics

Metrics.

| Option | Default |
|---|---|
| `active` | `false` |

Set `feature.metrics.active` to enable it, then override any of the options above.

### paging

Paging.

| Option | Default |
|---|---|
| `active` | `false` |
| `afterVar` | `'after'` |
| `cursorParam` | `'cursor'` |
| `firstVar` | `'first'` |
| `limitParam` | `'limit'` |
| `pageParam` | `'page'` |
| `startPage` | `1` |

Set `feature.paging.active` to enable it, then override any of the options above.

### ratelimit

Rate limiting.

| Option | Default |
|---|---|
| `active` | `false` |
| `burst` | `5` |
| `rate` | `5` |

Set `feature.ratelimit.active` to enable it, then override any of the options above.

`ratelimit` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### retry

Retry.

| Option | Default |
|---|---|
| `active` | `false` |
| `factor` | `2` |
| `maxDelay` | `2000` |
| `minDelay` | `50` |
| `retries` | `2` |
| `statuses` | `[408, 425, 429, 500, 502, 503, 504]` |

Set `feature.retry.active` to enable it, then override any of the options above.

`retry` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### secrets

Secrets.

| Option | Default |
|---|---|
| `active` | `false` |
| `cache` | `true` |
| `exchange` | `{active: false, method: 'POST', path: 'auth/token', redirect: 'refuse', refresh: '', request: 'refresh_token', response: 'access_token', retries: 1, statuses: [401]}` |
| `name` | `'apikey'` |
| `providers` | `[]` |

Set `feature.secrets.active` to enable it, then override any of the options above.

`secrets` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### test

Test transport.

| Option | Default |
|---|---|
| `active` | `false` |

Set `feature.test.active` to enable it, then override any of the options above.

### timeout

Timeout.

| Option | Default |
|---|---|
| `active` | `false` |
| `ms` | `30000` |

Set `feature.timeout.active` to enable it, then override any of the options above.

`timeout` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.


## Advanced

> The sections above cover everyday use. The material below explains the
> SDK's internals — useful when extending it with custom features, but not
> needed for normal use.

### The operation pipeline

Every entity operation follows a six-stage pipeline. Each stage fires a
feature hook before executing:

```
PrePoint → PreSpec → PreRequest → PreResponse → PreResult → PreDone
```

- **PrePoint**: Resolves which API endpoint to call based on the operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body — from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here to replace the transport.
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity state (match, data) is updated here.

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature implements the
`Feature` interface and provides hooks — functions keyed by pipeline
stage names.

The SDK ships with built-in features:

- **DebugFeature**: Debug capture
- **IdempotencyFeature**: Idempotency
- **MetricsFeature**: Metrics
- **PagingFeature**: Paging
- **RatelimitFeature**: Rate limiting
- **RetryFeature**: Retry
- **SecretsFeature**: Secrets
- **TestFeature**: Test transport
- **TimeoutFeature**: Timeout

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as maps

The Go SDK uses `map[string]any` throughout rather than typed structs.
This mirrors the dynamic nature of the API and keeps the SDK
flexible: code that works with the maps needs no regeneration when the
API schema changes. The typed models in `entity/types.go` follow the
schema only when the SDK is regenerated.

An operation returns the entity, and its `Data()` returns the record. Use
`core.ToMapAny()` to safely cast that record, or data nested in it, to
`map[string]any`: it returns `nil` for anything else, an entity included.

### Package structure

```
github.com/voxgig-sdk/voxgig-solardemo-sdk/go/
├── voxgig-solardemo.go        # Root package — type aliases and constructors
├── core/               # SDK core — client, types, pipeline
├── entity/             # Entity implementations
├── feature/            # Feature implementations
├── utility/            # Utility functions and struct library
└── test/               # Test suites
```

The root package (`github.com/voxgig-sdk/voxgig-solardemo-sdk/go`) re-exports everything needed
for normal use. Import sub-packages only when you need specific types
like `core.ToMapAny`.

### Entity state

Entity instances are stateful. After a successful `List`, the entity
stores the returned data and match criteria internally.

```go
planet := client.Planet(nil)
planet.List(nil, nil)

// planet.Data() now returns the planet data from the last list
// planet.Match() returns the last match criteria
```

Call `Make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for the operations each
entity declares.

`Direct()` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `Prepare()` builds the request without sending it — useful
for debugging or custom transport.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
