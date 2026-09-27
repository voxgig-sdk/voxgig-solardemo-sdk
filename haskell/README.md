# VoxgigSolardemo Haskell SDK



The Haskell SDK for the VoxgigSolardemo API — an entity-oriented client following idiomatic Haskell conventions (pure functions, explicit `IO`, and the dependency-free vendored `Value` struct model).

The SDK exposes the API as capitalised, semantic **Entities** — for example `moon sdk VNoval` — each
carrying a small, uniform set of operations (`eList`, `eLoad`, `eCreate`, `eUpdate`, `eRemove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to Hackage. Install it from the GitHub
release tag (`haskell/vX.Y.Z`, see [Releases](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/releases)) or
from a source checkout. The runtime has no third-party dependencies (only the
GHC boot libraries: `base`, `containers`, `array`, `time`), so the
bundled Makefile drives stock GHC with no cabal solve:

```bash
cd haskell && make test
```

A `.cabal` file is also generated for use with `cabal`/`stack`:

```bash
cd haskell && cabal build
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```haskell
import qualified SdkClient as Sdk
import VoxgigStruct (Value (..), emptyMap)
import SdkHelpers (jo)

main :: IO ()
main = do
  sdk <- Sdk.newSdk0
```

Entity operations raise on error (via `Control.Exception.throwIO`) and
return the bare result `Value`. Wrap a call in `Control.Exception.try`
to recover from failures.

### 2. List moon records

`eList ent match ctrl` resolves to one ENTITY per record and raises on
error. Read a record with `eDataGet`.

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- emptyMap
  ctrl <- emptyMap
  moons <- Sdk.eList ent match ctrl
  mapM_ (\en -> print =<< Sdk.eDataGet en) moons
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`eLoad` resolves to the ENTITY and raises on error; `eDataGet` gives the
record.

```haskell
  moonEnt <- Sdk.moon sdk VNoval
  m <- jo [("planet_id", VStr "example_planet_id"), ("id", VStr "example_id")]
  ctrl2 <- emptyMap
  moon <- Sdk.eLoad moonEnt m ctrl2
  print =<< Sdk.eDataGet moon
```

### 4. Create, update, and remove

```haskell
  createEnt <- Sdk.moon sdk VNoval
  d <- jo [("planet_id", VStr "example_planet_id"), ("diameter", VNum 1), ("id", VStr "example_id"), ("kind", VStr "example_kind"), ("name", VStr "example_name")]
  cctrl <- emptyMap
  created <- Sdk.eCreate createEnt d cctrl
  print =<< Sdk.eDataGet created
```

```haskell
  updateEnt <- Sdk.moon sdk VNoval
  upd <- jo [("id", VStr "example_id"), ("planet_id", VStr "example_planet_id"), ("diameter", VNum 1)]
  uctrl <- emptyMap
  updated <- Sdk.eUpdate updateEnt upd uctrl
  print =<< Sdk.eDataGet updated
```

```haskell
  removeEnt <- Sdk.moon sdk VNoval
  rm <- jo [("id", VStr "example_id"), ("planet_id", VStr "example_planet_id")]
  rctrl <- emptyMap
  -- Resolves to the entity, marked deleted; it keeps the data it held.
  removed <- Sdk.eRemove removeEnt rm rctrl
  print =<< readIORef (Sdk.eDeleted removed)
```


## Error handling

Entity operations reject on failure, so wrap them in `try` / `catch`:

```ts
try {
  const moons = await client.Moon().list()
  console.log(moons)
} catch (err) {
  console.error('list failed:', err)
}
```

The low-level `direct()` method does **not** throw — it returns the
value or an `Error`, so check the result before using it:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (result instanceof Error) {
  throw result
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity accessors, use `direct` — it never
raises and returns a result `Value` you branch on via its `ok` field:

```haskell
import qualified SdkClient as Sdk
import qualified SdkFeatures as F
import VoxgigStruct (Value (..))
import SdkHelpers (jo, getp)

main :: IO ()
main = do
  sdk <- Sdk.newSdk0
  params <- jo [("id", VStr "example")]
  args <- jo [("path", VStr "/api/resource/{id}"), ("method", VStr "GET"), ("params", params)]
  result <- F.direct sdk args
  ok <- getp result "ok"
  case ok of
    VBool True -> do
      status <- getp result "status"   -- e.g. VNum 200
      body <- getp result "data"       -- the response body
      print (status, body)
    _ -> do
      -- A non-2xx response carries status + data (the error body); a
      -- transport-level failure carries err instead.
      status <- getp result "status"
      err <- getp result "err"
      print (status, err)
```

### Prepare a request without sending it

```haskell
import qualified SdkClient as Sdk
import qualified SdkFeatures as F
import VoxgigStruct (Value (..))
import SdkHelpers (jo, getp)

main :: IO ()
main = do
  sdk <- Sdk.newSdk0
  params <- jo [("id", VStr "example")]
  args <- jo [("path", VStr "/api/resource/{id}"), ("method", VStr "DELETE"), ("params", params)]
  -- prepare returns the fetch definition and raises on error.
  fetchdef <- F.prepare sdk args
  url <- getp fetchdef "url"
  method <- getp fetchdef "method"
  print (url, method)
```

### Use test mode

Create a mock client for unit testing — no server required:

```haskell
import qualified SdkClient as Sdk
import qualified SdkFeatures as F
import VoxgigStruct (Value (..), emptyMap)
import SdkHelpers (jo)

main :: IO ()
main = do
  sdk <- Sdk.testSdk0
  ent <- Sdk.moon sdk VNoval
  arg <- emptyMap
  ctrl <- emptyMap
  -- Entity ops return the bare record and raise on error.
  moon <- Sdk.eList ent arg ctrl
  print moon
```

### Use a custom fetch function

Replace the HTTP transport with your own `VFunc` under `system.fetch`:

```haskell
import qualified SdkClient as Sdk
import VoxgigStruct (Value (..))
import SdkHelpers (jo, jsonThunk)

customClient :: IO Sdk.Client
customClient = do
  let mockFetch = VFunc (\_ _ _ _ -> do
        body <- jo [("id", VStr "mock01")]
        jo [("status", VNum 200), ("statusText", VStr "OK"), ("json", jsonThunk body)])
  sys <- jo [("fetch", mockFetch)]
  opts <- jo [("base", VStr "http://localhost:8080"), ("system", sys)]
  Sdk.newSdk opts
```

### Run live tests

Create a `.env.local` file at the project root:

```
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Then run the suite (stock GHC, no third-party dependencies):

```bash
cd haskell && make test
```


## Reference

### Client constructors

```haskell
import qualified SdkClient as Sdk
import VoxgigStruct (Value (..))
import SdkHelpers (jo)

makeClient :: IO Sdk.Client
makeClient = do
  opts <- jo [("base", VStr "https://api.example.com")]
  Sdk.newSdk opts
```

`newSdk :: Value -> IO Client` constructs a client from an options map;
`newSdk0 :: IO Client` is the no-argument convenience form.

| Option (map key) | Type | Description |
| --- | --- | --- |
| `base` | `String` | Base URL of the API server. |
| `prefix` | `String` | URL path prefix prepended to all requests. |
| `suffix` | `String` | URL path suffix appended to all requests. |
| `headers` | `Value` | Custom headers for all requests. |
| `feature` | `Value` | Feature activation flags. |
| `system` | `Value` | System overrides (e.g. custom `fetch` function). |

### Test client

```haskell
client <- Sdk.testSdk testopts sdkopts
```

`testSdk :: Value -> Value -> IO Client` constructs a test-mode client with
mock transport (`testSdk0 :: IO Client` for the no-argument form). Pass
`VNoval` for defaults.

### Client functions

| Function | Signature | Description |
| --- | --- | --- |
| `newSdk` | `Value -> IO Client` | Construct a live client from options. |
| `newSdk0` | `IO Client` | Construct a live client with defaults. |
| `testSdk` | `Value -> Value -> IO Client` | Construct a test-mode client. |
| `prepare` | `Client -> Value -> IO Value` | Build an HTTP request definition without sending. Raises on error. |
| `direct` | `Client -> Value -> IO Value` | Build and send an HTTP request. Returns a result `Value` (branch on `ok`). |
| `moon` | `Client -> Value -> IO Entity` | Create a Moon entity instance. |
| `planet` | `Client -> Value -> IO Entity` | Create a Planet entity instance. |

### Entity interface

All entities share the same record interface (fields of the `Entity` type).

| Field | Signature | Description |
| --- | --- | --- |
| `eLoad` | `Value -> Value -> IO Entity` | Load a single entity by match criteria. Resolves to the entity. Raises on error. |
| `eList` | `Value -> Value -> IO [Entity]` | List entities matching the criteria. Resolves to one entity per record. Raises on error. |
| `eCreate` | `Value -> Value -> IO Entity` | Create a new entity. Resolves to the entity. Raises on error. |
| `eUpdate` | `Value -> Value -> IO Entity` | Update an existing entity. Resolves to the entity. Raises on error. |
| `eRemove` | `Value -> Value -> IO Entity` | Remove an entity. Resolves to the entity, marked deleted. Raises on error. |
| `eDataGet` | `IO Value` | Get entity data. |
| `eDataSet` | `Value -> IO ()` | Set entity data. |
| `eStream` | `String -> Value -> Value -> IO [Value]` | Run an op as a lazy stream of items. |
| `eMake` | `IO Entity` | Create a new instance with the same options. |
| `eName` | `String` | The entity name. |

### Result shape

Entity operations resolve to the ENTITY, not the raw record — `eList` to
one entity per record — and raise on error. The record is reached through
`eDataGet`, which returns the entity's data container. `eRemove` resolves to
the entity marked deleted (`eDeleted`); it keeps the data it held. Wrap calls
in `Control.Exception.try` to handle failures.

The `direct` escape hatch never raises — it returns a result `Value`
you branch on via its `ok` field (read with `getp result "ok"`):

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `Bool` | `True` if the HTTP status is 2xx. |
| `status` | `Int` | HTTP status code. |
| `headers` | `Value` | Response headers. |
| `data` | `Value` | Parsed JSON response body. |

On error, `ok` is `False` and `err` carries the error value.

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

Create an instance: `moon <- Sdk.moon sdk VNoval`

#### Operations

| Method | Description |
| --- | --- |
| `eCreate ent data ctrl` | Create a new entity with the given data. Resolves to the entity. |
| `eList ent match ctrl` | List entities, optionally matching the given criteria. Resolves to one entity per record. |
| `eLoad ent match ctrl` | Load a single entity by match criteria. Resolves to the entity. |
| `eRemove ent match ctrl` | Remove the matching entity. Resolves to the entity, marked deleted. |
| `eUpdate ent data ctrl` | Update an existing entity. Resolves to the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `Double` |  |
| `id` | `String` |  |
| `kind` | `String` |  |
| `name` | `String` |  |
| `planet_id` | `String` |  |

#### Example: Load

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- jo [("id", VStr "moon_id"), ("planet_id", VStr "planet_id")]
  ctrl <- emptyMap
  moon <- Sdk.eLoad ent match ctrl
  -- The op resolves to the ENTITY; the record is inside it.
  moonData <- Sdk.eDataGet moon
```

#### Example: List

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- emptyMap
  ctrl <- emptyMap
  -- One ENTITY per record.
  moons <- Sdk.eList ent match ctrl
  moonDatas <- mapM Sdk.eDataGet moons
```

#### Example: Create

```haskell
  ent <- Sdk.moon sdk VNoval
  d <- jo
    [ ("planet_id", VStr "example_planet_id")   -- String
    , ("diameter", VNum 1)   -- Double
    , ("id", VStr "example_id")   -- String
    , ("kind", VStr "example_kind")   -- String
    , ("name", VStr "example_name")   -- String
    ]
  ctrl <- emptyMap
  moon <- Sdk.eCreate ent d ctrl
  moonData <- Sdk.eDataGet moon
```


### Planet

Create an instance: `planet <- Sdk.planet sdk VNoval`

#### Operations

| Method | Description |
| --- | --- |
| `eCreate ent data ctrl` | Create a new entity with the given data. Resolves to the entity. |
| `eList ent match ctrl` | List entities, optionally matching the given criteria. Resolves to one entity per record. |
| `eLoad ent match ctrl` | Load a single entity by match criteria. Resolves to the entity. |
| `eRemove ent match ctrl` | Remove the matching entity. Resolves to the entity, marked deleted. |
| `eUpdate ent data ctrl` | Update an existing entity. Resolves to the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `Double` |  |
| `forbidReason` | `String` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `String` | Set by the forbid action, and absent until it first runs. |
| `id` | `String` |  |
| `kind` | `String` |  |
| `name` | `String` |  |
| `terraformState` | `String` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```haskell
  ent <- Sdk.planet sdk VNoval
  match <- jo [("id", VStr "planet_id")]
  ctrl <- emptyMap
  planet <- Sdk.eLoad ent match ctrl
  -- The op resolves to the ENTITY; the record is inside it.
  planetData <- Sdk.eDataGet planet
```

#### Example: List

```haskell
  ent <- Sdk.planet sdk VNoval
  match <- emptyMap
  ctrl <- emptyMap
  -- One ENTITY per record.
  planets <- Sdk.eList ent match ctrl
  planetDatas <- mapM Sdk.eDataGet planets
```

#### Example: Create

```haskell
  ent <- Sdk.planet sdk VNoval
  d <- jo
    [ ("diameter", VNum 1)   -- Double
    , ("id", VStr "example_id")   -- String
    , ("kind", VStr "example_kind")   -- String
    , ("name", VStr "example_name")   -- String
    ]
  ctrl <- emptyMap
  planet <- Sdk.eCreate ent d ctrl
  planetData <- Sdk.eDataGet planet
```

## Features

This SDK ships 8 optional features. Each is **inactive until you
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
| [`test`](#test) | Test transport |
| [`timeout`](#timeout) | Timeout |

> **Order matters for `ratelimit`, `retry`, `timeout`.** These wrap the
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
- **TestFeature**: Test transport
- **TimeoutFeature**: Timeout

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as struct Values

The Haskell SDK models every API record as the dynamic `Value` type (from
the vendored `VoxgigStruct` module) rather than bespoke Haskell records.
This mirrors the dynamic nature of the API and keeps the SDK flexible — no
new datatypes or code generation are needed when the API schema changes.

Build request maps with `jo [(key, value)]` and read fields back with
`getp value "field"`; scalars are the `VStr` / `VNum` / `VBool`
constructors, and `VNoval` stands for an absent property.

### Module structure

```
haskell/
├── src/
│   ├── VoxgigStruct.hs   -- vendored dependency-free struct library (Value)
│   ├── Vregex.hs         -- vendored regex support
│   ├── SdkTypes.hs       -- core types (Client, Entity, Feature)
│   ├── SdkHelpers.hs     -- helper functions (jo, getp, ...)
│   ├── SdkRuntime.hs     -- the generic operation pipeline
│   ├── SdkFeatures.hs    -- built-in features + makeEntity
│   ├── SdkConfig.hs      -- generated API configuration + feature factory
│   └── SdkClient.hs      -- generated public client (newSdk, entity accessors)
├── test/                 -- test suites
├── Makefile              -- stock-GHC build/test (no third-party deps)
└── voxgigsolardemo-sdk.cabal      -- package manifest (for Hackage)
```

The public module (`SdkClient`) exports the SDK constructors (`newSdk`,
`testSdk`) and one accessor per entity. Import `VoxgigStruct` for the
`Value` constructors and `SdkHelpers` for `jo` / `getp`.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally. Subsequent
calls on the same instance can rely on this state.

```ts
const moon = client.Moon()
await moon.list()

// moon.data() now returns the moon data from the last `list`
// moon.match() returns the last match criteria
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
