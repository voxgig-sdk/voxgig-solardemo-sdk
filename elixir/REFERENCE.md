# Solardemo Elixir SDK Reference

Complete API reference for the Solardemo Elixir SDK.


## Solardemo

### Constructor

```elixir
sdk = Solardemo.new(options)
```

Create a new SDK client. `options` is a struct value node — build one from a
native map with `Solardemo.Helpers.deep/1`.

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

#### `Solardemo.test(testopts \\ nil, sdkopts \\ nil)`

Create a test client with mock features active. Both arguments may be `nil`.

```elixir
sdk = Solardemo.test()
```


### Functions

#### `Solardemo.moon(client, entopts \\ nil)`

Create a `Solardemo.Entity.Moon` handle.

#### `Solardemo.planet(client, entopts \\ nil)`

Create a `Solardemo.Entity.Planet` handle.

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

## Solardemo.Entity.Moon

```elixir
moon = Solardemo.moon(sdk)
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
record = Solardemo.Entity.Moon.create(moon, Solardemo.Helpers.deep(%{
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
records = Solardemo.Entity.Moon.list(moon)
```

#### `load(entity, reqmatch, ctrl \\ nil) :: map()`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```elixir
record = Solardemo.Entity.Moon.load(moon, Solardemo.Helpers.deep(%{"id" => "moon_id", "planet_id" => "planet_id"}))
```

#### `remove(entity, reqmatch, ctrl \\ nil) :: map()`

Remove the entity matching the given criteria. Raises on error.

```elixir
record = Solardemo.Entity.Moon.remove(moon, Solardemo.Helpers.deep(%{"id" => "moon_id", "planet_id" => "planet_id"}))
```

#### `update(entity, reqdata, ctrl \\ nil) :: map()`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```elixir
record = Solardemo.Entity.Moon.update(moon, Solardemo.Helpers.deep(%{
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

Create a new `Solardemo.Entity.Moon` handle with the same options.

#### `get_name(entity) :: String.t()`

Return the entity name.


---

## Solardemo.Entity.Planet

```elixir
planet = Solardemo.planet(sdk)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `float()` | Yes |  |
| `forbid` | `boolean()` | No |  |
| `id` | `String.t()` | Yes |  |
| `kind` | `String.t()` | Yes |  |
| `name` | `String.t()` | Yes |  |
| `ok` | `boolean()` | No |  |
| `start` | `boolean()` | No |  |
| `state` | `String.t()` | No |  |
| `stop` | `boolean()` | No |  |
| `why` | `String.t()` | No |  |

### Operations

#### `create(entity, reqdata, ctrl \\ nil) :: map()`

Create a new entity with the given data. Returns the created entity data and raises on error.

```elixir
record = Solardemo.Entity.Planet.create(planet, Solardemo.Helpers.deep(%{
  "diameter" => 1,  # float()
  "id" => "example_id",  # String.t()
  "kind" => "example_kind",  # String.t()
  "name" => "example_name",  # String.t()
}))
```

#### `list(entity, reqmatch \\ nil, ctrl \\ nil) :: list()`

List entities matching the given criteria. The match is optional — call `list(entity)` to list all records. Returns a list and raises on error.

```elixir
records = Solardemo.Entity.Planet.list(planet)
```

#### `load(entity, reqmatch, ctrl \\ nil) :: map()`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```elixir
record = Solardemo.Entity.Planet.load(planet, Solardemo.Helpers.deep(%{"id" => "planet_id"}))
```

#### `remove(entity, reqmatch, ctrl \\ nil) :: map()`

Remove the entity matching the given criteria. Raises on error.

```elixir
record = Solardemo.Entity.Planet.remove(planet, Solardemo.Helpers.deep(%{"id" => "planet_id"}))
```

#### `update(entity, reqdata, ctrl \\ nil) :: map()`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```elixir
record = Solardemo.Entity.Planet.update(planet, Solardemo.Helpers.deep(%{
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

Create a new `Solardemo.Entity.Planet` handle with the same options.

#### `get_name(entity) :: String.t()`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```elixir
sdk = Solardemo.new(Solardemo.Helpers.deep(%{
  "feature" => %{
    "test" => %{"active" => true},
  }
}))
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

