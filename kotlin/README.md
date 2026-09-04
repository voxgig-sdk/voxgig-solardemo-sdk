# Solardemo Kotlin SDK



The Kotlin SDK for the Solardemo API — an entity-oriented client following idiomatic Kotlin conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `client.moon(null)` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to Maven Central. Install it from the GitHub
release tag (`kotlin/vX.Y.Z`, see [Releases](https://github.com/voxgig-sdk/solardemo-sdk/releases)) or
from a source checkout — build the library with Gradle:

```bash
cd kotlin && gradle build
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```kotlin
import voxgig.solardemosdk.core.SolardemoSDK

val client = SolardemoSDK()
```

### 2. List moon records

`list(null, null)` returns an aggregate list of records (as `Any?`, an
aggregate list) and raises on error.

```kotlin
try {
    val moonList = client.moon(null).list(null, null)
    println(moonList)
}
catch (err: RuntimeException) {
    println("list failed: " + err.message)
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the ENTITY — call data() for the record — and raises on error.

```kotlin
try {
    val moon = client.moon(null).load(mutableMapOf<String, Any?>("planet_id" to "example_planet_id", "id" to "example_id"), null)
    println(moon)
}
catch (err: RuntimeException) {
    println("load failed: " + err.message)
}
```

### 4. Create, update, and remove

```kotlin
// Create — returns the ENTITY (call data() for the record)
val created = client.moon(null).create(mutableMapOf<String, Any?>("planet_id" to "example_planet_id", "diameter" to 1.0, "id" to "example_id", "kind" to "example_kind", "name" to "example_name"), null)

// Update — supply the id in the match/data
client.moon(null).update(mutableMapOf<String, Any?>("id" to "example_id", "planet_id" to "example_planet_id", "diameter" to 1.0), null)

// Remove
client.moon(null).remove(mutableMapOf<String, Any?>("id" to "example_id", "planet_id" to "example_planet_id"), null)
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

For endpoints not covered by entity methods:

```kotlin
val result = client.direct(mutableMapOf<String, Any?>(
    "path" to "/api/resource/{id}",
    "method" to "GET",
    "params" to mapOf("id" to "example")))

if (result["ok"] == true) {
    println(result["status"])  // 200
    println(result["data"])    // response body
}
else {
    // A non-2xx response carries status + data (the error body); a
    // transport-level failure carries err instead. Only one is present, so
    // an absent key simply reads as null.
    println("" + result["status"] + " " + result["err"])
}
```

### Prepare a request without sending it

```kotlin
// prepare() returns the fetch definition and raises on error.
val fetchdef = client.prepare(mutableMapOf<String, Any?>(
    "path" to "/api/resource/{id}",
    "method" to "DELETE",
    "params" to mapOf("id" to "example")))

println(fetchdef["url"])
println(fetchdef["method"])
println(fetchdef["headers"])
```

### Use test mode

Create a mock client for unit testing — no server required:

```kotlin
val client = SolardemoSDK.testSDK(null, null)

// Entity ops return the ENTITY and raises on error;
// call data() for the record.
val moon = client.moon(null).list(null, null)
// moon holds the mock response record
println(moon)
```

### Use a custom fetch function

Replace the HTTP transport with your own `BiFunction`:

```kotlin
val mockFetch = java.util.function.BiFunction<String, MutableMap<String, Any?>, Any?> { url, init ->
    mutableMapOf<String, Any?>(
        "status" to 200,
        "statusText" to "OK",
        "headers" to mutableMapOf<String, Any?>(),
        "json" to java.util.function.Supplier<Any?> { mapOf("id" to "mock01") },
    )
}

val client = SolardemoSDK(mutableMapOf<String, Any?>(
    "base" to "http://localhost:8080",
    "system" to mapOf("fetch" to mockFetch),
))
```

### Run live tests

Create a `.env.local` file at the project root:

```
SOLARDEMO_TEST_LIVE=TRUE
```

Then run:

```bash
cd kotlin && gradle test
```


## Reference

### SolardemoSDK

```kotlin
val client = SolardemoSDK(options)
```

Creates a new SDK client. `options` is a `MutableMap<String, Any?>`.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `String` | Base URL of the API server. |
| `prefix` | `String` | URL path prefix prepended to all requests. |
| `suffix` | `String` | URL path suffix appended to all requests. |
| `feature` | `Map` | Feature activation flags. |
| `extend` | `List` | Additional Feature instances to load. |
| `system` | `Map` | System overrides (e.g. custom `fetch` function). |

### testSDK

```kotlin
val client = SolardemoSDK.testSDK(testopts, sdkopts)
```

Creates a test-mode client with mock transport. Both arguments may be `null`.

### SolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `optionsMap` | `() -> MutableMap` | Deep copy of current SDK options. |
| `getUtility` | `() -> Utility` | Copy of the SDK utility object. |
| `prepare` | `(fetchargs) -> MutableMap` | Build an HTTP request definition without sending. Raises on error. |
| `direct` | `(fetchargs) -> MutableMap` | Build and send an HTTP request. Returns a result map (branch on `ok`). |
| `moon` | `(entopts) -> SdkEntity` | Create a Moon entity instance. |
| `planet` | `(entopts) -> SdkEntity` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `(reqmatch, ctrl) -> Any?` | Load a single entity by match criteria. Raises on error. |
| `list` | `(reqmatch, ctrl) -> Any?` | List entities matching the criteria (an aggregate list). Raises on error. |
| `create` | `(reqdata, ctrl) -> Any?` | Create a new entity. Raises on error. |
| `update` | `(reqdata, ctrl) -> Any?` | Update an existing entity. Raises on error. |
| `remove` | `(reqmatch, ctrl) -> Any?` | Remove an entity. Raises on error. |
| `data` | `(vararg newdata) -> Any?` | Get or set entity data. |
| `match` | `(vararg newmatch) -> Any?` | Get or set entity match criteria. |
| `make` | `() -> Entity` | Create a new instance with the same options. |
| `name` | `val: String` | The entity name. |

### Result shape

Entity operations return the ENTITY (call data() for the record) (a `Map` for single-entity
ops, an aggregate `List` for `list`) as `Any?` and raise on error. Wrap
calls in `try`/`catch` to handle failures.

The `direct()` escape hatch never raises — it returns a result
`MutableMap<String, Any?>` you branch on via `result["ok"]`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `Boolean` | `true` if the HTTP status is 2xx. |
| `status` | `Int` | HTTP status code. |
| `headers` | `Map` | Response headers. |
| `data` | `Any?` | Parsed JSON response body. |

On error, `ok` is `false` and `err` contains the error value.

### Entities

#### Moon

| Field | Description |
| --- | --- |
| `diameter` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `planet_id` |  |

Operations: create, list, load, remove, update.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `diameter` |  |
| `forbid` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `ok` |  |
| `start` |  |
| `state` |  |
| `stop` |  |
| `why` |  |

Operations: create, list, load, remove, update.

API path: `/api/planet/{planet_id}/forbid`



## Entities


### Moon

Create an instance: `val moon = client.moon(null)`

#### Operations

| Method | Description |
| --- | --- |
| `create(data, null)` | Create a new entity with the given data. |
| `list(null, null)` | List entities, optionally matching the given criteria. |
| `load(match, null)` | Load a single entity by match criteria. |
| `remove(match, null)` | Remove the matching entity. |
| `update(data, null)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `Double?` |  |
| `id` | `String?` |  |
| `kind` | `String?` |  |
| `name` | `String?` |  |
| `planet_id` | `String?` |  |

#### Example: Load

```kotlin
val moon = client.moon(null).load(mutableMapOf<String, Any?>("id" to "moon_id", "planet_id" to "planet_id"), null)
```

#### Example: List

```kotlin
val moonList = client.moon(null).list(null, null)
```

#### Example: Create

```kotlin
val moon = client.moon(null).create(mutableMapOf<String, Any?>(
    "planet_id" to "example_planet_id",  // String?
    "diameter" to 1.0,  // Double?
    "id" to "example_id",  // String?
    "kind" to "example_kind",  // String?
    "name" to "example_name"  // String?
), null)
```


### Planet

Create an instance: `val planet = client.planet(null)`

#### Operations

| Method | Description |
| --- | --- |
| `create(data, null)` | Create a new entity with the given data. |
| `list(null, null)` | List entities, optionally matching the given criteria. |
| `load(match, null)` | Load a single entity by match criteria. |
| `remove(match, null)` | Remove the matching entity. |
| `update(data, null)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `Double?` |  |
| `forbid` | `Boolean?` |  |
| `id` | `String?` |  |
| `kind` | `String?` |  |
| `name` | `String?` |  |
| `ok` | `Boolean?` |  |
| `start` | `Boolean?` |  |
| `state` | `String?` |  |
| `stop` | `Boolean?` |  |
| `why` | `String?` |  |

#### Example: Load

```kotlin
val planet = client.planet(null).load(mutableMapOf<String, Any?>("id" to "planet_id"), null)
```

#### Example: List

```kotlin
val planetList = client.planet(null).list(null, null)
```

#### Example: Create

```kotlin
val planet = client.planet(null).create(mutableMapOf<String, Any?>(
    "diameter" to 1.0,  // Double?
    "id" to "example_id",  // String?
    "kind" to "example_kind",  // String?
    "name" to "example_name"  // String?
), null)
```

## Features

This SDK ships 1 optional features. Each is **inactive until you
switch it on**, so an SDK you have not configured behaves exactly as if none of
them existed — no retries, no cache, no logging, no measurable overhead.

Activate a feature by name in the client options, alongside the options shown
above:

| Feature | What it does |
|---|---|
| [`test`](#test) | In-memory mock transport for testing without a live server |

### test

In-memory mock transport for testing without a live server.

| Option | Default |
|---|---|
| `active` | `false` |

Set `feature.test.active` to enable it, then override any of the options above.


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

- **TestFeature**: In-memory mock transport for testing without a live server

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as maps

The Kotlin SDK uses a loose object model — `MutableMap<String, Any?>`
throughout — rather than a bespoke typed class per endpoint. This mirrors the
dynamic nature of the API and keeps the SDK flexible: no regeneration is
needed when the API schema changes.

Use `Helpers.toMapAny(value)` to safely coerce a value to a
`MutableMap<String, Any?>`. A `SolardemoTypes.kt` module of
reference `data class` types is also generated for editor documentation.

### Project structure

```
kotlin/
├── build.gradle.kts            -- Gradle build (compiles core/, utility/, feature/, entity/)
├── settings.gradle.kts         -- Gradle project settings
├── core/                       -- Main SDK client, config, entity base, error type
├── entity/                     -- Entity implementations
├── feature/                    -- Built-in features (Base, Test, Log, ...)
├── utility/                    -- Utility functions and the vendored struct library
└── test/                       -- JUnit test suites
```

The main client class (`SolardemoSDK`, package `voxgig.solardemosdk.core`)
exposes the entity accessors. Reference entity or utility types directly only
when needed.

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
