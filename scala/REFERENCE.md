# Solardemo Scala SDK Reference

Complete API reference for the Solardemo Scala SDK.


## SolardemoSDK

### Constructor

```scala
val client = new SolardemoSDK(options)
```

Create a new SDK client instance. `options` is a `java.util.Map[String, Object]`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `Map` | SDK configuration options. |
| `options["base"]` | `String` | Base URL for API requests. |
| `options["prefix"]` | `String` | URL prefix appended after base. |
| `options["suffix"]` | `String` | URL suffix appended after path. |
| `options["headers"]` | `Map` | Custom headers for all requests. |
| `options["feature"]` | `Map` | Feature configuration. |
| `options["system"]` | `Map` | System overrides (e.g. custom fetch). |


### Static Methods

#### `SolardemoSDK.testSDK(testopts, sdkopts)`

Create a test client with mock features active. Both arguments may be `null`.

```scala
val client = SolardemoSDK.testSDK(null, null)
```


### Instance Methods

#### `moon(entopts)`

Create a new `Moon` entity instance (returns `SdkEntity`). Pass
`null` for no initial options.

#### `planet(entopts)`

Create a new `Planet` entity instance (returns `SdkEntity`). Pass
`null` for no initial options.

#### `optionsMap() -> Map`

Return a deep copy of the current SDK options.

#### `getUtility() -> Utility`

Return a copy of the SDK utility object.

#### `direct(fetchargs) -> Map`

Make a direct HTTP request to any API endpoint. Returns a result
`java.util.Map[String, Object]` with `ok`, `status`, `headers`, and
`data` (or `err` on failure). This escape hatch never raises — branch on
`result.get("ok")`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `String` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `String` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `Map` | Path parameter values. |
| `fetchargs["query"]` | `Map` | Query string parameters. |
| `fetchargs["headers"]` | `Map` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `Object` | Request body (maps are JSON-serialized). |

**Returns:** `java.util.Map[String, Object]`

#### `prepare(fetchargs) -> Map`

Prepare a fetch definition without sending. Returns the `fetchdef` and raises on error.


---

## Moon

```scala
val moon = client.moon(null)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `java.lang.Double` | Yes |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `planet_id` | `String` | Yes |  |

### Operations

#### `create(reqdata, ctrl) -> Object`

Create a new entity with the given data. Returns the created entity data and raises on error.

```scala
val result = client.moon(null).create(java.util.Map.of(
    "planet_id", "example_planet_id",  // String
    "diameter", 1.0,  // java.lang.Double
    "id", "example_id",  // String
    "kind", "example_kind",  // String
    "name", "example_name"  // String
), null)
```

#### `list(reqmatch, ctrl) -> Object`

List entities matching the given criteria. The match is optional — call `list(null, null)` to list all records. Returns an aggregate list and raises on error.

```scala
val results = client.moon(null).list(null, null)
println(results)
```

#### `load(reqmatch, ctrl) -> Object`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```scala
val result = client.moon(null).load(java.util.Map.of("id", "moon_id", "planet_id", "planet_id"), null)
```

#### `remove(reqmatch, ctrl) -> Object`

Remove the entity matching the given criteria. Raises on error.

```scala
val result = client.moon(null).remove(java.util.Map.of("id", "moon_id", "planet_id", "planet_id"), null)
```

#### `update(reqdata, ctrl) -> Object`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```scala
val result = client.moon(null).update(java.util.Map.of(
    "id", "moon_id",
    "planet_id", "planet_id"
), null)
```

### Common Methods

#### `data(newdata*) -> Object`

Get or set the entity data.

#### `matchArgs(newmatch*) -> Object`

Get or set the entity match criteria.

#### `make() -> Entity`

Create a new `Moon` entity instance with the same options.

#### `getName() -> String`

Return the entity name.


---

## Planet

```scala
val planet = client.planet(null)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `java.lang.Double` | Yes |  |
| `forbid` | `java.lang.Boolean` | No |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `ok` | `java.lang.Boolean` | No |  |
| `start` | `java.lang.Boolean` | No |  |
| `state` | `String` | No |  |
| `stop` | `java.lang.Boolean` | No |  |
| `why` | `String` | No |  |

### Operations

#### `create(reqdata, ctrl) -> Object`

Create a new entity with the given data. Returns the created entity data and raises on error.

```scala
val result = client.planet(null).create(java.util.Map.of(
    "diameter", 1.0,  // java.lang.Double
    "id", "example_id",  // String
    "kind", "example_kind",  // String
    "name", "example_name"  // String
), null)
```

#### `list(reqmatch, ctrl) -> Object`

List entities matching the given criteria. The match is optional — call `list(null, null)` to list all records. Returns an aggregate list and raises on error.

```scala
val results = client.planet(null).list(null, null)
println(results)
```

#### `load(reqmatch, ctrl) -> Object`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```scala
val result = client.planet(null).load(java.util.Map.of("id", "planet_id"), null)
```

#### `remove(reqmatch, ctrl) -> Object`

Remove the entity matching the given criteria. Raises on error.

```scala
val result = client.planet(null).remove(java.util.Map.of("id", "planet_id"), null)
```

#### `update(reqdata, ctrl) -> Object`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```scala
val result = client.planet(null).update(java.util.Map.of(
    "id", "planet_id"
), null)
```

### Common Methods

#### `data(newdata*) -> Object`

Get or set the entity data.

#### `matchArgs(newmatch*) -> Object`

Get or set the entity match criteria.

#### `make() -> Entity`

Create a new `Planet` entity instance with the same options.

#### `getName() -> String`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```scala
val feature = new java.util.LinkedHashMap[String, Object]()
feature.put("test", java.util.Map.of("active", true))
val options = new java.util.LinkedHashMap[String, Object]()
options.put("feature", feature)
val client = new SolardemoSDK(options)
```

