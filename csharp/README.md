# Solardemo C# SDK



The C# SDK for the Solardemo API — an entity-oriented client following idiomatic C# conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `client.Moon()` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to NuGet. Install it from the GitHub
release tag (`csharp/vX.Y.Z`, see [Releases](https://github.com/voxgig-sdk/solardemo-sdk/releases)) or
from a source checkout — build the library and add a project reference:

```bash
cd csharp && dotnet build SolardemoSDK.csproj
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```csharp
using SolardemoSdk;

var client = new SolardemoSDK();
```

### 2. List moon records

`List(null)` returns an aggregate list of records (as `object?`) and raises
on error.

```csharp
try
{
    var moonList = client.Moon().List(null);
    Console.WriteLine(moonList);
}
catch (Exception err)
{
    Console.WriteLine($"list failed: {err.Message}");
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`Load()` returns the bare record (as `object?`) and raises on error.

```csharp
try
{
    var moon = client.Moon().Load(new Dictionary<string, object?> { ["planet_id"] = "example_planet_id", ["id"] = "example_id" });
    Console.WriteLine(moon);
}
catch (Exception err)
{
    Console.WriteLine($"load failed: {err.Message}");
}
```

### 4. Create, update, and remove

```csharp
// Create — returns the bare created record (as object?)
var created = client.Moon().Create(new Dictionary<string, object?> { ["planet_id"] = "example_planet_id", ["diameter"] = 1.0, ["id"] = "example_id", ["kind"] = "example_kind", ["name"] = "example_name" });

// Update — supply the id in the match/data
client.Moon().Update(new Dictionary<string, object?> { ["id"] = "example_id", ["planet_id"] = "example_planet_id", ["diameter"] = 1.0 });

// Remove
client.Moon().Remove(new Dictionary<string, object?> { ["id"] = "example_id", ["planet_id"] = "example_planet_id" });
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

```csharp
var result = client.Direct(new Dictionary<string, object?>
{
    ["path"] = "/api/resource/{id}",
    ["method"] = "GET",
    ["params"] = new Dictionary<string, object?> { ["id"] = "example" },
});

if (Equals(result["ok"], true))
{
    Console.WriteLine(result["status"]);  // 200
    Console.WriteLine(result["data"]);    // response body
}
else
{
    // A non-2xx response carries status + data (the error body); a
    // transport-level failure carries err instead. Only one is present, so
    // read both with TryGetValue rather than indexing a key that may be absent.
    result.TryGetValue("status", out var status);
    result.TryGetValue("err", out var err);
    Console.WriteLine($"{status} {err}");
}
```

### Prepare a request without sending it

```csharp
// Prepare() returns the fetch definition and raises on error.
var fetchdef = client.Prepare(new Dictionary<string, object?>
{
    ["path"] = "/api/resource/{id}",
    ["method"] = "DELETE",
    ["params"] = new Dictionary<string, object?> { ["id"] = "example" },
});

Console.WriteLine(fetchdef["url"]);
Console.WriteLine(fetchdef["method"]);
Console.WriteLine(fetchdef["headers"]);
```

### Use test mode

Create a mock client for unit testing — no server required:

```csharp
var client = SolardemoSDK.TestSDK(null, null);

// Entity ops return the bare record and raise on error.
var moon = client.Moon().List(null);
// moon holds the mock response record
Console.WriteLine(moon);
```

### Use a custom fetch function

Replace the HTTP transport with your own delegate:

```csharp
Func<string, Dictionary<string, object?>, Dictionary<string, object?>> mockFetch =
    (url, init) => new Dictionary<string, object?>
    {
        ["status"] = 200,
        ["statusText"] = "OK",
        ["headers"] = new Dictionary<string, object?>(),
        ["json"] = (Func<object?>)(() => new Dictionary<string, object?> { ["id"] = "mock01" }),
    };

var client = new SolardemoSDK(new Dictionary<string, object?>
{
    ["base"] = "http://localhost:8080",
    ["system"] = new Dictionary<string, object?>
    {
        ["fetch"] = mockFetch,
    },
});
```

### Run live tests

Create a `.env.local` file at the project root:

```
SOLARDEMO_TEST_LIVE=TRUE
```

Then run:

```bash
cd csharp && dotnet test
```


## Reference

### SolardemoSDK

```csharp
using SolardemoSdk;

var client = new SolardemoSDK(options);
```

Creates a new SDK client. `options` is a `Dictionary<string, object?>`.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `feature` | `Dictionary` | Feature activation flags. |
| `extend` | `List` | Additional Feature instances to load. |
| `system` | `Dictionary` | System overrides (e.g. custom `fetch` delegate). |

### TestSDK

```csharp
var client = SolardemoSDK.TestSDK(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be `null`.

### SolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `OptionsMap` | `() -> Dictionary` | Deep copy of current SDK options. |
| `GetUtility` | `() -> Utility` | Copy of the SDK utility object. |
| `Prepare` | `(fetchargs) -> Dictionary` | Build an HTTP request definition without sending. Raises on error. |
| `Direct` | `(fetchargs) -> Dictionary` | Build and send an HTTP request. Returns a result dictionary (branch on `ok`). |
| `Moon` | `(entopts) -> SolardemoEntityBase` | Create a Moon entity instance. |
| `Planet` | `(entopts) -> SolardemoEntityBase` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `Load` | `(reqmatch, ctrl) -> object?` | Load a single entity by match criteria. Raises on error. |
| `List` | `(reqmatch, ctrl) -> object?` | List entities matching the criteria (an aggregate list). Raises on error. |
| `Create` | `(reqdata, ctrl) -> object?` | Create a new entity. Raises on error. |
| `Update` | `(reqdata, ctrl) -> object?` | Update an existing entity. Raises on error. |
| `Remove` | `(reqmatch, ctrl) -> object?` | Remove an entity. Raises on error. |
| `Data` | `(newdata) -> object?` | Get or set entity data. |
| `Match` | `(newmatch) -> object?` | Get or set entity match criteria. |
| `Make` | `() -> IEntity` | Create a new instance with the same options. |
| `GetName` | `() -> string` | Return the entity name. |

### Result shape

Entity operations return the bare result data (a `Dictionary` for
single-entity ops, an aggregate list for `List`) as `object?` and raise on
error. Wrap calls in `try`/`catch` to handle failures.

The `Direct()` escape hatch never raises — it returns a result
`Dictionary<string, object?>` you branch on via `result["ok"]`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `bool` | `true` if the HTTP status is 2xx. |
| `status` | `int` | HTTP status code. |
| `headers` | `Dictionary` | Response headers. |
| `data` | `object?` | Parsed JSON response body. |

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

Operations: Create, List, Load, Remove, Update.

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

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/forbid`



## Entities


### Moon

Create an instance: `var moon = client.Moon();`

#### Operations

| Method | Description |
| --- | --- |
| `Create(data)` | Create a new entity with the given data. |
| `List(null)` | List entities, optionally matching the given criteria. |
| `Load(match)` | Load a single entity by match criteria. |
| `Remove(match)` | Remove the matching entity. |
| `Update(data)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `planet_id` | `string` |  |

#### Example: Load

```csharp
var moon = client.Moon().Load(new Dictionary<string, object?> { ["id"] = "moon_id", ["planet_id"] = "planet_id" });
```

#### Example: List

```csharp
var moonList = client.Moon().List(null);
```

#### Example: Create

```csharp
var moon = client.Moon().Create(new Dictionary<string, object?>
{
    ["planet_id"] = "example_planet_id",  // string
    ["diameter"] = 1.0,  // double
    ["id"] = "example_id",  // string
    ["kind"] = "example_kind",  // string
    ["name"] = "example_name",  // string
});
```


### Planet

Create an instance: `var planet = client.Planet();`

#### Operations

| Method | Description |
| --- | --- |
| `Create(data)` | Create a new entity with the given data. |
| `List(null)` | List entities, optionally matching the given criteria. |
| `Load(match)` | Load a single entity by match criteria. |
| `Remove(match)` | Remove the matching entity. |
| `Update(data)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `forbid` | `bool` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `ok` | `bool` |  |
| `start` | `bool` |  |
| `state` | `string` |  |
| `stop` | `bool` |  |
| `why` | `string` |  |

#### Example: Load

```csharp
var planet = client.Planet().Load(new Dictionary<string, object?> { ["id"] = "planet_id" });
```

#### Example: List

```csharp
var planetList = client.Planet().List(null);
```

#### Example: Create

```csharp
var planet = client.Planet().Create(new Dictionary<string, object?>
{
    ["diameter"] = 1.0,  // double
    ["id"] = "example_id",  // string
    ["kind"] = "example_kind",  // string
    ["name"] = "example_name",  // string
});
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

### Data as dictionaries

The C# SDK uses a loose object model — `Dictionary<string, object?>`
throughout — rather than a bespoke typed class per endpoint. This mirrors
the dynamic nature of the API and keeps the SDK flexible: no regeneration is
needed when the API schema changes.

Use `Helpers.ToMapAny(value)` to safely coerce a value to a
`Dictionary<string, object?>`. A `SolardemoTypes.cs` module of
reference `record` types is also generated for editor documentation.

### Project structure

```
csharp/
├── SolardemoSDK.csproj    -- Library project (compiles everything except test/)
├── core/                       -- Main SDK client, config, entity base, error type
├── entity/                     -- Entity implementations
├── feature/                    -- Built-in features (Base, Test, Log, ...)
├── utility/                    -- Utility functions and the vendored struct library
└── test/                       -- xUnit test suites
```

The main client class (`SolardemoSDK`, namespace
`SolardemoSdk`) exposes the entity accessors. Reference entity or
utility types directly only when needed.

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
