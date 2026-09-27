# VoxgigSolardemo Elixir SDK Reference

Complete API reference for the VoxgigSolardemo Elixir SDK.


## VoxgigSolardemo

### Constructor

```elixir
sdk = VoxgigSolardemo.new(options)
```

Create a new SDK client. `options` is a struct value node — build one from a
native map with `VoxgigSolardemo.Helpers.deep/1`.

**Options:**

| Name | Type | Description |
| --- | --- | --- |
| `base` | `String.t()` | Base URL for API requests. |
| `prefix` | `String.t()` | URL prefix appended after base. |
| `suffix` | `String.t()` | URL suffix appended after path. |
| `headers` | `map()` | Custom headers for all requests. |
| `feature` | `map()` | Feature configuration. |
| `system` | `map()` | System overrides (e.g. custom fetch). |


### Constructors

#### `VoxgigSolardemo.test(testopts \\ nil, sdkopts \\ nil)`

Create a test client with mock features active. Both arguments may be `nil`.

```elixir
sdk = VoxgigSolardemo.test()
```


### Functions

#### `VoxgigSolardemo.moon(client, entopts \\ nil)`

Create a `VoxgigSolardemo.Entity.Moon` handle.

#### `VoxgigSolardemo.planet(client, entopts \\ nil)`

Create a `VoxgigSolardemo.Entity.Planet` handle.

#### `options_map(client) :: map()`

Return a deep copy of the current SDK options.

#### `get_utility(client) :: map()`

Return the SDK utility node.

#### `direct(client, fetchargs) :: map()`

Make a direct HTTP request to any API endpoint. Returns a result node with
`ok`, `status`, `headers`, and `data` (or `err` on failure). This escape
hatch never raises — branch on `Voxgig.Struct.getprop(result, "ok")`.

**fetchargs keys:**

| Key | Type | Description |
| --- | --- | --- |
| `path` | `String.t()` | URL path with optional `{param}` placeholders. |
| `method` | `String.t()` | HTTP method (default: `"GET"`). |
| `params` | `map()` | Path parameter values. |
| `query` | `map()` | Query string parameters. |
| `headers` | `map()` | Request headers (merged with defaults). |
| `body` | `any()` | Request body (maps are JSON-serialized). |

#### `prepare(client, fetchargs) :: map()`

Prepare a fetch definition without sending. Returns the `fetchdef` and raises
on error.


---

## VoxgigSolardemo.Entity.Moon

```elixir
moon = VoxgigSolardemo.moon(sdk)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `float()` | Yes |  |
| `id` | `String.t()` | Yes |  |
| `kind` | `String.t()` | Yes |  |
| `name` | `String.t()` | Yes |  |
| `planet_id` | `String.t()` | Yes |  |

### Operations

#### `create(entity, reqdata, ctrl \\ nil) :: map()`

Create a new entity with the given data. Returns the created entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Moon.create(moon, VoxgigSolardemo.Helpers.deep(%{
  "planet_id" => "example_planet_id",  # String.t()
  "diameter" => 1,  # float()
  "id" => "example_id",  # String.t()
  "kind" => "example_kind",  # String.t()
  "name" => "example_name",  # String.t()
}))
```

#### `list(entity, reqmatch \\ nil, ctrl \\ nil) :: list()`

List entities matching the given criteria. The match is optional — call `list(entity)` to list all records. Returns a list and raises on error.

```elixir
records = VoxgigSolardemo.Entity.Moon.list(moon)
```

#### `load(entity, reqmatch, ctrl \\ nil) :: map()`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Moon.load(moon, VoxgigSolardemo.Helpers.deep(%{"id" => "moon_id", "planet_id" => "planet_id"}))
```

#### `remove(entity, reqmatch, ctrl \\ nil) :: map()`

Remove the entity matching the given criteria. Raises on error.

```elixir
record = VoxgigSolardemo.Entity.Moon.remove(moon, VoxgigSolardemo.Helpers.deep(%{"id" => "moon_id", "planet_id" => "planet_id"}))
```

#### `update(entity, reqdata, ctrl \\ nil) :: map()`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Moon.update(moon, VoxgigSolardemo.Helpers.deep(%{
  "id" => "moon_id",
  "planet_id" => "planet_id",
  # Fields to update
}))
```

### Common Functions

#### `data_get(entity) :: map()`

Get the entity data.

#### `data_set(entity, data)`

Set the entity data.

#### `match_get(entity) :: map()`

Get the entity match criteria.

#### `match_set(entity, match)`

Set the entity match criteria.

#### `make(entity) :: entity`

Create a new `VoxgigSolardemo.Entity.Moon` handle with the same options.

#### `get_name(entity) :: String.t()`

Return the entity name.


---

## VoxgigSolardemo.Entity.Planet

```elixir
planet = VoxgigSolardemo.planet(sdk)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `float()` | Yes |  |
| `forbidReason` | `String.t()` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `String.t()` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `String.t()` | Yes |  |
| `kind` | `String.t()` | Yes |  |
| `name` | `String.t()` | Yes |  |
| `terraformState` | `String.t()` | No | Set by the terraform action, and absent until it first runs. |

### Operations

#### `create(entity, reqdata, ctrl \\ nil) :: map()`

Create a new entity with the given data. Returns the created entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Planet.create(planet, VoxgigSolardemo.Helpers.deep(%{
  "diameter" => 1,  # float()
  "id" => "example_id",  # String.t()
  "kind" => "example_kind",  # String.t()
  "name" => "example_name",  # String.t()
}))
```

#### `list(entity, reqmatch \\ nil, ctrl \\ nil) :: list()`

List entities matching the given criteria. The match is optional — call `list(entity)` to list all records. Returns a list and raises on error.

```elixir
records = VoxgigSolardemo.Entity.Planet.list(planet)
```

#### `load(entity, reqmatch, ctrl \\ nil) :: map()`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Planet.load(planet, VoxgigSolardemo.Helpers.deep(%{"id" => "planet_id"}))
```

#### `remove(entity, reqmatch, ctrl \\ nil) :: map()`

Remove the entity matching the given criteria. Raises on error.

```elixir
record = VoxgigSolardemo.Entity.Planet.remove(planet, VoxgigSolardemo.Helpers.deep(%{"id" => "planet_id"}))
```

#### `update(entity, reqdata, ctrl \\ nil) :: map()`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```elixir
record = VoxgigSolardemo.Entity.Planet.update(planet, VoxgigSolardemo.Helpers.deep(%{
  "id" => "planet_id",
  # Fields to update
}))
```

### Common Functions

#### `data_get(entity) :: map()`

Get the entity data.

#### `data_set(entity, data)`

Set the entity data.

#### `match_get(entity) :: map()`

Get the entity match criteria.

#### `match_set(entity, match)`

Set the entity match criteria.

#### `make(entity) :: entity`

Create a new `VoxgigSolardemo.Entity.Planet` handle with the same options.

#### `get_name(entity) :: String.t()`

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

```elixir
sdk = VoxgigSolardemo.new(VoxgigSolardemo.Helpers.deep(%{
  "feature" => %{
    "debug" => %{"active" => true},
    "idempotency" => %{"active" => true},
    "metrics" => %{"active" => true},
    "paging" => %{"active" => true},
    "ratelimit" => %{"active" => true},
    "retry" => %{"active" => true},
    "secrets" => %{"active" => true},
    "test" => %{"active" => true},
    "timeout" => %{"active" => true},
  }
}))
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

