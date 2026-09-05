# Solardemo C# SDK Reference

Complete API reference for the Solardemo C# SDK.


## SolardemoSDK

### Constructor

```csharp
using SolardemoSdk;

var client = new SolardemoSDK(options);
```

Create a new SDK client instance. `options` is a
`Dictionary<string, object?>`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `Dictionary` | SDK configuration options. |
| `options["base"]` | `string` | Base URL for API requests. |
| `options["prefix"]` | `string` | URL prefix appended after base. |
| `options["suffix"]` | `string` | URL suffix appended after path. |
| `options["headers"]` | `Dictionary` | Custom headers for all requests. |
| `options["feature"]` | `Dictionary` | Feature configuration. |
| `options["system"]` | `Dictionary` | System overrides (e.g. custom fetch). |


### Static Methods

#### `SolardemoSDK.TestSDK(testopts = null, sdkopts = null)`

Create a test client with mock features active. Both arguments may be `null`.

```csharp
var client = SolardemoSDK.TestSDK(null, null);
```


### Instance Methods

#### `Moon(entopts = null)`

Create a new `Moon` entity instance (returns
`SolardemoEntityBase`). Pass `null` for no initial options.

#### `Planet(entopts = null)`

Create a new `Planet` entity instance (returns
`SolardemoEntityBase`). Pass `null` for no initial options.

#### `OptionsMap() -> Dictionary`

Return a deep copy of the current SDK options.

#### `GetUtility() -> Utility`

Return a copy of the SDK utility object.

#### `Direct(fetchargs = null) -> Dictionary`

Make a direct HTTP request to any API endpoint. Returns a result
`Dictionary<string, object?>` with `ok`, `status`, `headers`, and `data`
(or `err` on failure). This escape hatch never raises — branch on
`result["ok"]`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `string` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `string` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `Dictionary` | Path parameter values. |
| `fetchargs["query"]` | `Dictionary` | Query string parameters. |
| `fetchargs["headers"]` | `Dictionary` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `object?` | Request body (dictionaries are JSON-serialized). |

**Returns:** `Dictionary<string, object?>`

#### `Prepare(fetchargs = null) -> Dictionary`

Prepare a fetch definition without sending. Returns the `fetchdef` and raises on error.


---

## Moon

```csharp
var moon = client.Moon();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `planet_id` | `string` | Yes |  |

### Operations

#### `Create(reqdata, ctrl = null) -> object?`

Create a new entity with the given data. Returns the created entity data and raises on error.

```csharp
var result = client.Moon().Create(new Dictionary<string, object?>
{
    ["planet_id"] = "example_planet_id",  // string
    ["diameter"] = 1.0,  // double
    ["id"] = "example_id",  // string
    ["kind"] = "example_kind",  // string
    ["name"] = "example_name",  // string
});
```

#### `List(reqmatch, ctrl = null) -> object?`

List entities matching the given criteria. The match is optional — call `List(null)` to list all records. Returns an aggregate list and raises on error.

```csharp
var results = client.Moon().List(null);
Console.WriteLine(results);
```

#### `Load(reqmatch, ctrl = null) -> object?`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```csharp
var result = client.Moon().Load(new Dictionary<string, object?> { ["id"] = "moon_id", ["planet_id"] = "planet_id" });
```

#### `Remove(reqmatch, ctrl = null) -> object?`

Remove the entity matching the given criteria. Raises on error.

```csharp
var result = client.Moon().Remove(new Dictionary<string, object?> { ["id"] = "moon_id", ["planet_id"] = "planet_id" });
```

#### `Update(reqdata, ctrl = null) -> object?`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```csharp
var result = client.Moon().Update(new Dictionary<string, object?>
{
    ["id"] = "moon_id",
    ["planet_id"] = "planet_id",
    // Fields to update
});
```

### Common Methods

#### `Data(newdata = null) -> object?`

Get or set the entity data.

#### `Match(newmatch = null) -> object?`

Get or set the entity match criteria.

#### `Make() -> IEntity`

Create a new `Moon` entity instance with the same options.

#### `GetName() -> string`

Return the entity name.


---

## Planet

```csharp
var planet = client.Planet();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `forbid` | `bool` | No |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `ok` | `bool` | No |  |
| `start` | `bool` | No |  |
| `state` | `string` | No |  |
| `stop` | `bool` | No |  |
| `why` | `string` | No |  |

### Operations

#### `Create(reqdata, ctrl = null) -> object?`

Create a new entity with the given data. Returns the created entity data and raises on error.

```csharp
var result = client.Planet().Create(new Dictionary<string, object?>
{
    ["diameter"] = 1.0,  // double
    ["id"] = "example_id",  // string
    ["kind"] = "example_kind",  // string
    ["name"] = "example_name",  // string
});
```

#### `List(reqmatch, ctrl = null) -> object?`

List entities matching the given criteria. The match is optional — call `List(null)` to list all records. Returns an aggregate list and raises on error.

```csharp
var results = client.Planet().List(null);
Console.WriteLine(results);
```

#### `Load(reqmatch, ctrl = null) -> object?`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```csharp
var result = client.Planet().Load(new Dictionary<string, object?> { ["id"] = "planet_id" });
```

#### `Remove(reqmatch, ctrl = null) -> object?`

Remove the entity matching the given criteria. Raises on error.

```csharp
var result = client.Planet().Remove(new Dictionary<string, object?> { ["id"] = "planet_id" });
```

#### `Update(reqdata, ctrl = null) -> object?`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```csharp
var result = client.Planet().Update(new Dictionary<string, object?>
{
    ["id"] = "planet_id",
    // Fields to update
});
```

### Common Methods

#### `Data(newdata = null) -> object?`

Get or set the entity data.

#### `Match(newmatch = null) -> object?`

Get or set the entity match criteria.

#### `Make() -> IEntity`

Create a new `Planet` entity instance with the same options.

#### `GetName() -> string`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `secrets` | 0.1.0 | Secret access: resolve the API credential through a provider chain, and exchange a refresh token for short-lived access tokens |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```csharp
var client = new SolardemoSDK(new Dictionary<string, object?>
{
    ["feature"] = new Dictionary<string, object?>
    {
        ["secrets"] = new Dictionary<string, object?> { ["active"] = true },
        ["test"] = new Dictionary<string, object?> { ["active"] = true },
    },
});
```


### Configuring features

Each feature is inactive until switched on, and an SDK with no feature
configured does no feature work at all. Every option below keeps its default
unless you name it.

The array form of \`feature\` is significant: several features wrap the
transport, and the order you list them in is the order they nest.

#### `test`

In-memory mock transport for testing without a live server.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |

Options above are those the model carries a default for. A feature may
also accept callback options — a `sink` to receive each record, for
instance — which have no default and are covered in the full feature
reference.

**Usage**

Set `feature.test.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Installs the BASE transport that the wrapping features wrap, so it must be
  activated before them.
- Inactive by default: leaving it out costs nothing at runtime.

