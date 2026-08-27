# Solardemo Swift SDK Reference

Complete API reference for the Solardemo Swift SDK.


## SolardemoSDK

### Constructor

```swift
let client = SolardemoSDK(options)
```

Create a new SDK client instance. `options` is a `VMap` of `Value`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `VMap` | SDK configuration options. |
| `options["base"]` | `String` | Base URL for API requests. |
| `options["prefix"]` | `String` | URL prefix appended after base. |
| `options["suffix"]` | `String` | URL suffix appended after path. |
| `options["headers"]` | `VMap` | Custom headers for all requests. |
| `options["feature"]` | `VMap` | Feature configuration. |
| `options["system"]` | `VMap` | System overrides (e.g. custom fetch). |


### Static Methods

#### `SolardemoSDK.testSDK(testopts, sdkopts)`

Create a test client with mock features active. Both arguments may be `nil`.

```swift
let client = SolardemoSDK.testSDK(nil, nil)
```


### Instance Methods

#### `Moon(entopts)`

Create a new `Moon` entity instance. Pass `nil` for no initial
options.

#### `Planet(entopts)`

Create a new `Planet` entity instance. Pass `nil` for no initial
options.

#### `optionsMap() -> VMap`

Return a deep copy of the current SDK options.

#### `getUtility() -> Utility`

Return a copy of the SDK utility object.

#### `direct(fetchargs) -> VMap`

Make a direct HTTP request to any API endpoint. Returns a result `VMap`
with `ok`, `status`, `headers`, and `data` (or `err` on failure).
This escape hatch never throws — branch on `result.entries["ok"]`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `String` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `String` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `VMap` | Path parameter values. |
| `fetchargs["query"]` | `VMap` | Query string parameters. |
| `fetchargs["headers"]` | `VMap` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `Value` | Request body (maps are JSON-serialized). |

**Returns:** `VMap`

#### `prepare(fetchargs) throws -> VMap`

Prepare a fetch definition without sending. Returns the `fetchdef` and throws on error.


---

## Moon

```swift
let moon = client.Moon()
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `Double` | Yes |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `planet_id` | `String` | Yes |  |

### Operations

#### `create(reqdata, ctrl) throws -> Value`

Create a new entity with the given data. Returns the created entity data and throws on error.

```swift
let result = try client.Moon().create(VMap([
    ("planet_id", .string("example_planet_id")),  // String
    ("diameter", .double(1.0)),  // Double
    ("id", .string("example_id")),  // String
    ("kind", .string("example_kind")),  // String
    ("name", .string("example_name"))  // String
]), nil)
```

#### `list(reqmatch, ctrl) throws -> Value`

List entities matching the given criteria. The match is optional — call `list(nil, nil)` to list all records. Returns a Value list and throws on error.

```swift
let results = try client.Moon().list(nil, nil)
print(results)
```

#### `load(reqmatch, ctrl) throws -> Value`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```swift
let result = try client.Moon().load(VMap([("id", .string("moon_id")), ("planet_id", .string("planet_id"))]), nil)
```

#### `remove(reqmatch, ctrl) throws -> Value`

Remove the entity matching the given criteria. Throws on error.

```swift
let result = try client.Moon().remove(VMap([("id", .string("moon_id")), ("planet_id", .string("planet_id"))]), nil)
```

#### `update(reqdata, ctrl) throws -> Value`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```swift
let result = try client.Moon().update(VMap([
    ("id", .string("moon_id")),
    ("planet_id", .string("planet_id"))
]), nil)
```

### Common Methods

#### `data(newdata?) -> Value`

Get or set the entity data.

#### `matchv(newmatch?) -> Value`

Get or set the entity match criteria.

#### `make() -> Entity`

Create a new `Moon` entity instance with the same options.

#### `getName() -> String`

Return the entity name.


---

## Planet

```swift
let planet = client.Planet()
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `Double` | Yes |  |
| `forbid` | `Bool` | No |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `ok` | `Bool` | No |  |
| `start` | `Bool` | No |  |
| `state` | `String` | No |  |
| `stop` | `Bool` | No |  |
| `why` | `String` | No |  |

### Operations

#### `create(reqdata, ctrl) throws -> Value`

Create a new entity with the given data. Returns the created entity data and throws on error.

```swift
let result = try client.Planet().create(VMap([
    ("diameter", .double(1.0)),  // Double
    ("id", .string("example_id")),  // String
    ("kind", .string("example_kind")),  // String
    ("name", .string("example_name"))  // String
]), nil)
```

#### `list(reqmatch, ctrl) throws -> Value`

List entities matching the given criteria. The match is optional — call `list(nil, nil)` to list all records. Returns a Value list and throws on error.

```swift
let results = try client.Planet().list(nil, nil)
print(results)
```

#### `load(reqmatch, ctrl) throws -> Value`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```swift
let result = try client.Planet().load(VMap([("id", .string("planet_id"))]), nil)
```

#### `remove(reqmatch, ctrl) throws -> Value`

Remove the entity matching the given criteria. Throws on error.

```swift
let result = try client.Planet().remove(VMap([("id", .string("planet_id"))]), nil)
```

#### `update(reqdata, ctrl) throws -> Value`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```swift
let result = try client.Planet().update(VMap([
    ("id", .string("planet_id"))
]), nil)
```

### Common Methods

#### `data(newdata?) -> Value`

Get or set the entity data.

#### `matchv(newmatch?) -> Value`

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

```swift
let feature = VMap()
feature.entries["test"] = .map([("active", .bool(true))])
let options = VMap()
options.entries["feature"] = .map(feature)
let client = SolardemoSDK(options)
```

