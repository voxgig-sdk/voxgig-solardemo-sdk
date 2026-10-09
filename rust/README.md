# VoxgigSolardemo Rust SDK



The Rust SDK for the VoxgigSolardemo API — an entity-oriented client following idiomatic Rust conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `client.moon(Value::Noval)` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This crate is not yet published to crates.io. Depend on it from the GitHub
release tag (`rust/vX.Y.Z`, see [Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags)) or
from a source checkout by adding it to your `Cargo.toml`:

```toml
[dependencies]
# From a source checkout:
voxgig-voxgig-solardemo-sdk = { path = "../rust" }

# Or from the git release tag:
# voxgig-voxgig-solardemo-sdk = { git = "<repo-url>", tag = "rust/vX.Y.Z" }
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```rust
use voxgig_solardemo_sdk::{getp, jo, VoxgigSolardemoEntity, VoxgigSolardemoSDK, Entity, Value};

let client = VoxgigSolardemoSDK::new(Value::Noval);
```

### 2. List moon records

`list()` returns one entity per record, and `Err` on failure — match on
the `Result`. `data(None)` reads an entity's record.

```rust
match client.moon(Value::Noval).list(jo(vec![("planet_id", Value::str("example"))]), Value::Noval) {
    Ok(moons) => {
        for moon in &moons {
            println!("{:?}", moon.data(None));
        }
    }
    Err(err) => eprintln!("list failed: {}", err),
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the entity, and `Err` on failure; `data(None)` reads its
record.

```rust
match client.moon(Value::Noval).load(jo(vec![("planet_id", Value::str("example_planet_id")), ("id", Value::str("example_id"))]), Value::Noval) {
    Ok(moon) => println!("{:?}", moon.data(None)),
    Err(err) => eprintln!("load failed: {}", err),
}
```

### 4. Create, update, and remove

```rust
// Create — returns the created entity
let created = client.moon(Value::Noval).create(jo(vec![("planet_id", Value::str("example_planet_id")), ("diameter", Value::Num(1.0)), ("id", Value::str("example_id")), ("kind", Value::str("example_kind")), ("name", Value::str("example_name"))]), Value::Noval).unwrap();

// Update
client.moon(Value::Noval).update(jo(vec![("id", getp(&created.data(None), "id")), ("planet_id", Value::str("example_planet_id")), ("diameter", Value::Num(1.0))]), Value::Noval).unwrap();

// Remove
client.moon(Value::Noval).remove(jo(vec![("id", getp(&created.data(None), "id")), ("planet_id", Value::str("example_planet_id"))]), Value::Noval).unwrap();
```


## Error handling

Entity operations reject on failure, so wrap them in `try` / `catch`:

```ts
try {
  const planets = await client.Planet().list()
  console.log(planets.map((item) => item.data()))
} catch (err) {
  console.error('list failed:', err)
}
```

The low-level `direct()` method does **not** throw — it returns the
result envelope. Branch on `ok`; on failure `status` holds the HTTP status
(for error responses) and `err` holds the error:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (!result.ok) {
  console.error('request failed:', result.status, result.err)
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```rust
let result = client.direct(jo(vec![
    ("path", Value::str("/api/resource/{id}")),
    ("method", Value::str("GET")),
    ("params", jo(vec![("id", Value::str("example"))])),
])).unwrap();

if getp(&result, "ok") == Value::Bool(true) {
    println!("{:?}", getp(&result, "status"));  // 200
    println!("{:?}", getp(&result, "data"));    // response body
} else {
    // A non-2xx response carries status + data (the error body); a
    // transport-level failure carries err instead. Only one is present.
    println!("{:?} {:?}", getp(&result, "status"), getp(&result, "err"));
}
```

### Prepare a request without sending it

```rust
// prepare() returns the fetch definition on Ok and Err on failure.
let fetchdef = client.prepare(jo(vec![
    ("path", Value::str("/api/resource/{id}")),
    ("method", Value::str("DELETE")),
    ("params", jo(vec![("id", Value::str("example"))])),
])).unwrap();

println!("{:?}", getp(&fetchdef, "url"));
println!("{:?}", getp(&fetchdef, "method"));
println!("{:?}", getp(&fetchdef, "headers"));
```

### Use test mode

Create a mock client for unit testing — no server required:

```rust
use voxgig_solardemo_sdk::{jo, test_sdk, VoxgigSolardemoEntity, Entity, Value};

let client = test_sdk(Value::Noval, Value::Noval);

// list returns one entity per mock record on Ok, and Err on failure.
for planet in client.planet(Value::Noval).list(Value::Noval, Value::Noval).unwrap() {
    println!("{:?}", planet.data(None));
}
```

### Point at a different server

Override the base URL to reach a local or staging server:

```rust
let client = VoxgigSolardemoSDK::new(jo(vec![
    ("base", Value::str("http://localhost:8080")),
]));
```

### Run live tests

Create a `.env.local` file at the crate root:

```
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Then run:

```bash
cd rust && cargo test
```


## Reference

### VoxgigSolardemoSDK

```rust
use voxgig_solardemo_sdk::{VoxgigSolardemoSDK, Value};

let client = VoxgigSolardemoSDK::new(options);
```

Creates a new SDK client. `options` is a `Value` map (`Value::Noval` for
none) carrying any of the following keys:

| Option | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `feature` | `map` | Feature activation flags. |
| `system` | `map` | System overrides (e.g. a custom fetcher). |

### test_sdk

```rust
use voxgig_solardemo_sdk::{test_sdk, Value};

let client = test_sdk(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be
`Value::Noval`.

### VoxgigSolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `options_map` | `() -> Value` | Deep copy of the current SDK options. |
| `get_utility` | `() -> Rc<Utility>` | Copy of the SDK utility object. |
| `prepare` | `(fetchargs: Value) -> Result<Value, VoxgigSolardemoError>` | Build an HTTP request definition without sending. |
| `direct` | `(fetchargs: Value) -> Result<Value, VoxgigSolardemoError>` | Build and send an HTTP request. `Ok` is a result map (branch on `ok`). |
| `moon` | `(entopts: Value) -> Rc<MoonEntity>` | Create a Moon entity instance. |
| `planet` | `(entopts: Value) -> Rc<PlanetEntity>` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>` | Load a single entity by match criteria. |
| `list` | `(reqmatch: Value, ctrl: Value) -> Result<Vec<Rc<Self>>, VoxgigSolardemoError>` | List entities matching the criteria, one per record. |
| `create` | `(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>` | Create a new entity. |
| `update` | `(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>` | Update an existing entity. |
| `remove` | `(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>` | Remove an entity, which is returned marked as deleted. |
| `data` | `(args: Option<&Value>) -> Value` | Get entity data (pass `Some(&map)` to set). |
| `matchv` | `(args: Option<&Value>) -> Value` | Get entity match criteria (pass `Some(&map)` to set). |
| `make` | `() -> Rc<dyn Entity>` | Create a new instance with the same options. |
| `get_name` | `() -> String` | Return the entity name. |

### Result shape

Entity operations return the entity on `Ok`, and `list` a `Vec` of
entities, one per record; `data(None)` reads an entity's record. `Err` is
the branded error. The operations are methods of the
`VoxgigSolardemoEntity` trait and `data` of the `Entity` trait, so
import both.

The `direct()` escape hatch resolves to `Ok` even on a non-2xx response —
it returns a result `Value::Map` you branch on via `getp(&result, "ok")`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `bool` | `true` if the HTTP status is 2xx. |
| `status` | `number` | HTTP status code. |
| `headers` | `map` | Response headers. |
| `data` | `any` | Parsed JSON response body. |

On error, `ok` is `false` and `err` carries the error value.

### Entities

#### Moon

| Field | Description |
| --- | --- |
| `diameter` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `planet_id` |  |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `diameter` |  |
| `forbidReason` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | Set by the forbid action, and absent until it first runs. |
| `id` |  |
| `kind` |  |
| `name` |  |
| `terraformState` | Set by the terraform action, and absent until it first runs. |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/forbid`



## Entities


### Moon

Create an instance: `let moon = client.moon(Value::Noval);`

#### Operations

| Method | Description |
| --- | --- |
| `create(reqdata, ctrl)` | Create a new entity with the given data. `Ok` is the entity. |
| `list(reqmatch, ctrl)` | List entities, optionally matching the given criteria. `Ok` is a `Vec` of entities, one per record. |
| `load(reqmatch, ctrl)` | Load a single entity by match criteria. `Ok` is the entity. |
| `remove(reqmatch, ctrl)` | Remove the matching entity. `Ok` is the entity, marked as deleted. |
| `update(reqdata, ctrl)` | Update an existing entity. `Ok` is the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `f64` |  |
| `id` | `String` |  |
| `kind` | `String` |  |
| `name` | `String` |  |
| `planet_id` | `String` |  |

#### Example: Load

```rust
let moon = client.moon(Value::Noval).load(jo(vec![("id", Value::str("moon_id")), ("planet_id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", moon.data(None));
```

#### Example: List

```rust
let moons = client.moon(Value::Noval).list(jo(vec![("planet_id", Value::str("example"))]), Value::Noval).unwrap();
for moon in &moons {
    println!("{:?}", moon.data(None));
}
```

#### Example: Create

```rust
let moon = client.moon(Value::Noval).create(jo(vec![
    ("planet_id", Value::str("example_planet_id")),  // String
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```


### Planet

Create an instance: `let planet = client.planet(Value::Noval);`

#### Operations

| Method | Description |
| --- | --- |
| `create(reqdata, ctrl)` | Create a new entity with the given data. `Ok` is the entity. |
| `list(reqmatch, ctrl)` | List entities, optionally matching the given criteria. `Ok` is a `Vec` of entities, one per record. |
| `load(reqmatch, ctrl)` | Load a single entity by match criteria. `Ok` is the entity. |
| `remove(reqmatch, ctrl)` | Remove the matching entity. `Ok` is the entity, marked as deleted. |
| `update(reqdata, ctrl)` | Update an existing entity. `Ok` is the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `f64` |  |
| `forbidReason` | `String` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `String` | Set by the forbid action, and absent until it first runs. |
| `id` | `String` |  |
| `kind` | `String` |  |
| `name` | `String` |  |
| `terraformState` | `String` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```rust
let planet = client.planet(Value::Noval).load(jo(vec![("id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", planet.data(None));
```

#### Example: List

```rust
let planets = client.planet(Value::Noval).list(Value::Noval, Value::Noval).unwrap();
for planet in &planets {
    println!("{:?}", planet.data(None));
}
```

#### Example: Create

```rust
let planet = client.planet(Value::Noval).create(jo(vec![
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```

## Features

This SDK ships 9 optional features. Each is **inactive until you
switch it on**, so an SDK you have not configured behaves exactly as if none of
them existed — no retries, no cache, no logging, no measurable overhead.

Activate a feature by name in the client options, alongside the options shown
above:

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
| `exchange` | `{active: false, method: 'POST', path: 'auth/token', refresh: '', request: 'refresh_token', response: 'access_token', retries: 1, statuses: [401]}` |
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

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature is an object with a
`hooks` map. Each hook key is a pipeline stage name, and the value is
a function that receives the context.

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

### Data as `Value`

The Rust SDK uses a single dynamic `Value` type throughout rather than a
typed struct per entity. `Value` is the vendored voxgig struct port (a
JSON-shaped enum: `Str`, `Num`, `Bool`, `List`, `Map`, `Null`,
`Noval`). This mirrors the dynamic nature of the API and keeps the SDK
flexible — no code generation is needed when the API schema changes.

Build request maps with the `jo` / `ja` helpers and read fields back with
`getp`; use `to_map` to safely coerce a value to a map.

### Crate structure

```
rust/
├── lib.rs                       -- Crate root (module decls + re-exports)
├── core/                        -- Pipeline types, config, client (sdk.rs)
├── entity/                      -- Per-entity clients (one module each)
├── feature/                     -- Built-in features (base, test, log)
└── utility/                     -- Utilities + the vendored voxgig struct port
```

The public API is re-exported from the crate root, so `use voxgig_solardemo_sdk::{...}`
reaches the SDK client, `Value`, and the `jo` / `ja` / `getp` helpers
directly. Import entity or utility modules only when needed.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally. Subsequent
calls on the same instance can rely on this state.

```ts
const planet = client.Planet()
await planet.list()

// planet.data() now returns the planet data from the last `list`
// planet.match() returns the last match criteria
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

The `direct` method gives full control over the HTTP request. Use it
for non-standard endpoints, bulk operations, or any path not modelled
as an entity. The `prepare` method is useful for debugging — it
shows exactly what `direct` would send.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
