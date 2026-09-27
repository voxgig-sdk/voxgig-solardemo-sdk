# VoxgigSolardemo C# SDK Reference

Complete API reference for the VoxgigSolardemo C# SDK.


## VoxgigSolardemoSDK

### Constructor

```csharp
using VoxgigSolardemoSdk;

var client = new VoxgigSolardemoSDK(options);
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

#### `VoxgigSolardemoSDK.TestSDK(testopts = null, sdkopts = null)`

Create a test client with mock features active. Both arguments may be `null`.

```csharp
var client = VoxgigSolardemoSDK.TestSDK(null, null);
```


### Instance Methods

#### `Moon(entopts = null)`

Create a new `Moon` entity instance (returns
`VoxgigSolardemoEntityBase`). Pass `null` for no initial options.

#### `Planet(entopts = null)`

Create a new `Planet` entity instance (returns
`VoxgigSolardemoEntityBase`). Pass `null` for no initial options.

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
| `forbidReason` | `string` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `string` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `terraformState` | `string` | No | Set by the terraform action, and absent until it first runs. |

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
| `debug` | 0.0.1 | Debug capture |
| `idempotency` | 0.0.1 | Idempotency |
| `metrics` | 0.0.1 | Metrics |
| `paging` | 0.0.1 | Paging |
| `ratelimit` | 0.0.1 | Rate limiting |
| `retry` | 0.0.1 | Retry |
| `secrets` | 0.1.0 | Secrets |
| `test` | 0.0.1 | Test transport |
| `timeout` | 0.0.1 | Timeout |


Features are activated via the `feature` option:

```csharp
var client = new VoxgigSolardemoSDK(new Dictionary<string, object?>
{
    ["feature"] = new Dictionary<string, object?>
    {
        ["debug"] = new Dictionary<string, object?> { ["active"] = true },
        ["idempotency"] = new Dictionary<string, object?> { ["active"] = true },
        ["metrics"] = new Dictionary<string, object?> { ["active"] = true },
        ["paging"] = new Dictionary<string, object?> { ["active"] = true },
        ["ratelimit"] = new Dictionary<string, object?> { ["active"] = true },
        ["retry"] = new Dictionary<string, object?> { ["active"] = true },
        ["secrets"] = new Dictionary<string, object?> { ["active"] = true },
        ["test"] = new Dictionary<string, object?> { ["active"] = true },
        ["timeout"] = new Dictionary<string, object?> { ["active"] = true },
    },
});
```


### Configuring features

Each feature is inactive until switched on, and an SDK with no feature
configured does no feature work at all. Every option below keeps its default
unless you name it.

The array form of \`feature\` is significant: several features wrap the
transport, and the order you list them in is the order they nest.

#### Ordering

`ratelimit`, `retry`, `secrets`, `timeout` wrap the transport. Each
wraps whatever is already installed, so **activation order is nesting order**:
a feature activated later sits OUTSIDE one activated earlier, and sees the call
first.

That decides behaviour, not just sequence: a feature that short-circuits the
call, such as a cache serving a hit, stops every feature nested inside it from
ever seeing that call.

`debug`, `idempotency`, `metrics`, `paging`, `test` attach to pipeline hooks
rather than the transport, so their order does not affect what they observe.

#### `debug`

Debug capture.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `max` | `100` |
| `redact` | `['authorization', 'cookie', 'set-cookie', 'api-key', 'apikey', 'x-api-key', 'idempotency-key']` |

| Option | Type |
|---|---|
| `now` | function |
| `onEntry` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.debug.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Inactive by default: leaving it out costs nothing at runtime.

#### `idempotency`

Idempotency.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `header` | `'Idempotency-Key'` |
| `methods` | `['POST', 'PUT', 'PATCH', 'DELETE']` |
| `ops` | `['create', 'update', 'remove']` |

| Option | Type |
|---|---|
| `keygen` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.idempotency.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Inactive by default: leaving it out costs nothing at runtime.

#### `metrics`

Metrics.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |

| Option | Type |
|---|---|
| `now` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.metrics.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Inactive by default: leaving it out costs nothing at runtime.

#### `paging`

Paging.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `afterVar` | `'after'` |
| `cursorParam` | `'cursor'` |
| `firstVar` | `'first'` |
| `limitParam` | `'limit'` |
| `pageParam` | `'page'` |
| `startPage` | `1` |

| Option | Type |
|---|---|
| `limit` | number |
| `ops` | list |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.paging.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Inactive by default: leaving it out costs nothing at runtime.

#### `ratelimit`

Rate limiting.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `burst` | `5` |
| `rate` | `5` |

| Option | Type |
|---|---|
| `now` | function |
| `sleep` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.ratelimit.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Wraps the transport: its place in the activation order decides what it
  sees. See [Ordering](#ordering) above.
- Inactive by default: leaving it out costs nothing at runtime.

#### `retry`

Retry.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `factor` | `2` |
| `maxDelay` | `2000` |
| `minDelay` | `50` |
| `retries` | `2` |
| `statuses` | `[408, 425, 429, 500, 502, 503, 504]` |

| Option | Type |
|---|---|
| `jitter` | boolean |
| `sleep` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.retry.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Wraps the transport: its place in the activation order decides what it
  sees. See [Ordering](#ordering) above.
- Inactive by default: leaving it out costs nothing at runtime.

#### `secrets`

Secrets.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `cache` | `true` |
| `exchange` | `{active: false, method: 'POST', path: 'auth/token', refresh: '', request: 'refresh_token', response: 'access_token', retries: 1, statuses: [401]}` |
| `name` | `'apikey'` |
| `providers` | `[]` |

**Usage**

Set `feature.secrets.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Wraps the transport: its place in the activation order decides what it
  sees. See [Ordering](#ordering) above.
- Inactive by default: leaving it out costs nothing at runtime.

#### `test`

Test transport.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |

| Option | Type |
|---|---|
| `entity` | map |
| `net` | map |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.test.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Installs the BASE transport that the wrapping features wrap, so it must be
  activated before them.
- Inactive by default: leaving it out costs nothing at runtime.

#### `timeout`

Timeout.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |
| `ms` | `30000` |

| Option | Type |
|---|---|
| `clearTimer` | function |
| `setTimer` | function |

These take no default: the feature behaves one way when you supply them and
another when you do not.

**Usage**

Set `feature.timeout.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Wraps the transport: its place in the activation order decides what it
  sees. See [Ordering](#ordering) above.
- Inactive by default: leaving it out costs nothing at runtime.

