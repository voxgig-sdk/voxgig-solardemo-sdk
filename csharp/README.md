# VoxgigSolardemo C# SDK



The C# SDK for the VoxgigSolardemo API — an entity-oriented client following idiomatic C# conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `client.Moon()` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to NuGet. Install it from the GitHub
release tag (`csharp/vX.Y.Z`, see [Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags)) or
from a source checkout — build the library and add a project reference:

```bash
cd csharp && dotnet build VoxgigSolardemoSDK.csproj
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and loading a specific record.

### 1. Create a client

```csharp
using VoxgigSolardemoSdk;
using Voxgig.Struct;

var client = new VoxgigSolardemoSDK();
```

### 2. List moon records

`List(null)` returns a list of entities, one per record (as `object?`), and
raises on error; an entity's `Data()` reads its record.

```csharp
try
{
    var moonList = (List<object?>)client.Moon().List(new Dictionary<string, object?> { ["planet_id"] = "example" })!;
    foreach (var moonItem in moonList)
    {
        Console.WriteLine(StructUtils.Jsonify(((IEntity)moonItem!).Data()));
    }
}
catch (Exception err)
{
    Console.WriteLine($"list failed: {err.Message}");
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`Load()` returns the entity (as `object?`) and raises on error; an entity's
`Data()` reads its record.

```csharp
try
{
    var moon = (IEntity)client.Moon().Load(new Dictionary<string, object?> { ["planet_id"] = "example_planet_id", ["id"] = "example_id" })!;
    Console.WriteLine(StructUtils.Jsonify(moon.Data()));
}
catch (Exception err)
{
    Console.WriteLine($"load failed: {err.Message}");
}
```

### 4. Create, update, and remove

```csharp
// Create — returns the created entity (as object?)
var created = client.Moon().Create(new Dictionary<string, object?> { ["planet_id"] = "example_planet_id", ["diameter"] = 1.0, ["id"] = "example_id", ["kind"] = "example_kind", ["name"] = "example_name" });

// Update — supply the id in the match/data
client.Moon().Update(new Dictionary<string, object?> { ["id"] = "example_id", ["planet_id"] = "example_planet_id", ["diameter"] = 1.0 });

// Remove
client.Moon().Remove(new Dictionary<string, object?> { ["id"] = "example_id", ["planet_id"] = "example_planet_id" });
```


## Error handling

Entity operations throw on failure, so wrap them in `try` / `catch`:

```csharp
try
{
    var planetList = (List<object?>)client.Planet().List(null)!;
    foreach (var planetItem in planetList)
    {
        Console.WriteLine(StructUtils.Jsonify(((IEntity)planetItem!).Data()));
    }
}
catch (Exception err)
{
    Console.WriteLine($"list failed: {err.Message}");
}
```

`Direct()` does **not** throw — it
returns the result dictionary. Branch on `ok`; on failure `status` holds the HTTP
status (for error responses) and `err` holds a transport error:

```csharp
var result = client.Direct(new Dictionary<string, object?>
{
    ["path"] = "/api/planet/{planet_id}/moon",
    ["method"] = "GET",
    ["params"] = new Dictionary<string, object?> { ["planet_id"] = "example_id" },
});

if (!Equals(result["ok"], true))
{
    result.TryGetValue("status", out var status);
    result.TryGetValue("err", out var err);
    Console.WriteLine($"request failed: {status} {err}");
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```csharp
var result = client.Direct(new Dictionary<string, object?>
{
    ["path"] = "/api/planet/{planet_id}/moon",
    ["method"] = "GET",
    ["params"] = new Dictionary<string, object?> { ["planet_id"] = "example" },
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
    ["path"] = "/api/planet/{planet_id}/moon",
    ["method"] = "GET",
    ["params"] = new Dictionary<string, object?> { ["planet_id"] = "example" },
});

Console.WriteLine(fetchdef["url"]);
Console.WriteLine(fetchdef["method"]);
Console.WriteLine(fetchdef["headers"]);
```

### Use test mode

Create a mock client for unit testing — no server required:

```csharp
var client = VoxgigSolardemoSDK.TestSDK(null, null);

// List returns a list of entities, one per mock record; it raises on error.
var planetList = (List<object?>)client.Planet().List(null)!;
foreach (var planetItem in planetList)
{
    Console.WriteLine(StructUtils.Jsonify(((IEntity)planetItem!).Data()));
}
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

var client = new VoxgigSolardemoSDK(new Dictionary<string, object?>
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
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Each entity's tests also read `VOXGIG_SOLARDEMO_TEST_<ENTITY>_ENTID`, with the
entity's name in capitals: a JSON object of the ids of existing records, for
the tests that do not create their own.

Then run:

```bash
cd csharp && dotnet test
```


## Reference

### VoxgigSolardemoSDK

```csharp
using VoxgigSolardemoSdk;

var client = new VoxgigSolardemoSDK(options);
```

Creates a new SDK client. `options` is a `Dictionary<string, object?>`.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `headers` | `Dictionary` | Headers sent with every request. |
| `feature` | `Dictionary` | Feature activation flags. |
| `extend` | `List` | Additional feature instances to load. |
| `system` | `Dictionary` | System overrides, such as a custom fetch function. |

### TestSDK

```csharp
var client = VoxgigSolardemoSDK.TestSDK(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be `null`.

### VoxgigSolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `OptionsMap` | `() -> Dictionary` | Deep copy of current SDK options. |
| `GetUtility` | `() -> Utility` | Copy of the SDK utility object. |
| `Prepare` | `(fetchargs) -> Dictionary` | Build an HTTP request definition without sending. Raises on error. |
| `Direct` | `(fetchargs) -> Dictionary` | Build and send an HTTP request. Returns a result dictionary (branch on `ok`). |
| `Moon` | `(entopts) -> VoxgigSolardemoEntityBase` | Create a Moon entity instance. |
| `Planet` | `(entopts) -> VoxgigSolardemoEntityBase` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `Load` | `(reqmatch, ctrl) -> object?` | Load a single entity by match criteria, and return it. Raises on error. |
| `List` | `(reqmatch, ctrl) -> object?` | List entities matching the criteria, one per record. Raises on error. |
| `Create` | `(reqdata, ctrl) -> object?` | Create a new entity, and return it. Raises on error. |
| `Update` | `(reqdata, ctrl) -> object?` | Update an existing entity, and return it. Raises on error. |
| `Remove` | `(reqmatch, ctrl) -> object?` | Remove an entity, and return it marked as deleted. Raises on error. |
| `Data` | `(newdata) -> object?` | Get or set entity data. |
| `Match` | `(newmatch) -> object?` | Get or set entity match criteria. |
| `Make` | `() -> IEntity` | Create a new instance with the same options. |
| `GetName` | `() -> string` | Return the entity name. |

### Result shape

Entity operations return the entity, and `List` a list of entities, one per
record, as `object?`; an entity is an `IEntity`, whose `Data()` reads its
record. They raise on error, so wrap calls in `try`/`catch` to handle
failures.

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

Operations: List, Load, Create, Update, Remove.

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

Operations: List, Load, Create, Update, Remove.

API path: `/api/planet`



## Entities


### Moon

Create an instance: `var moon = client.Moon();`

#### Operations

| Method | Description |
| --- | --- |
| `List(null)` | List entities, optionally matching the given criteria. |
| `Load(match)` | Load a single entity by match criteria. |
| `Create(data)` | Create a new entity with the given data. |
| `Update(data)` | Update an existing entity. |
| `Remove(match)` | Remove the matching entity. |

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
var moonList = client.Moon().List(new Dictionary<string, object?> { ["planet_id"] = "example" });
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
| `List(null)` | List entities, optionally matching the given criteria. |
| `Load(match)` | Load a single entity by match criteria. |
| `Create(data)` | Create a new entity with the given data. |
| `Update(data)` | Update an existing entity. |
| `Remove(match)` | Remove the matching entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `forbidReason` | `string` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `string` | Set by the forbid action, and absent until it first runs. |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `terraformState` | `string` | Set by the terraform action, and absent until it first runs. |

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

Features are the extension mechanism. A feature is a C# class extending `BaseFeature`
with hook methods named after pipeline stages (e.g. `PrePoint`,
`PreSpec`). Each method receives the context.

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

### Data as dictionaries

The C# SDK uses a loose object model — `Dictionary<string, object?>`
throughout — rather than a bespoke typed class per endpoint. This mirrors
the dynamic nature of the API and keeps the SDK flexible: no regeneration is
needed when the API schema changes.

Use `Helpers.ToMapAny(value)` to safely coerce a value to a
`Dictionary<string, object?>`. A `VoxgigSolardemoTypes.cs` module of
reference `record` types is also generated for editor documentation.

### Project structure

```
csharp/
├── VoxgigSolardemoSDK.csproj    -- Library project (compiles everything except test/)
├── core/                       -- Main SDK client, config, entity base, error type
├── entity/                     -- Entity implementations
├── feature/                    -- Feature implementations
├── utility/                    -- Utility functions and the vendored struct library
└── test/                       -- xUnit test suites
```

The main client class (`VoxgigSolardemoSDK`, namespace
`VoxgigSolardemoSdk`) exposes the entity accessors. Reference entity or
utility types directly only when needed.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally.

```csharp
var planet = client.Planet();
planet.List(null);

// planet.Data() now returns the planet data from the last List
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
