# Solardemo Rust SDK Reference

Complete API reference for the Solardemo Rust SDK.


## SolardemoSDK

### Constructor

```rust
use solardemo_sdk::{SolardemoSDK, Value};

let client = SolardemoSDK::new(options);
```

Create a new SDK client instance. `options` is a `Value` map
(`Value::Noval` for none).

**Parameters:**

| Key | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL for API requests. |
| `prefix` | `string` | URL prefix appended after base. |
| `suffix` | `string` | URL suffix appended after path. |
| `headers` | `map` | Custom headers for all requests. |
| `feature` | `map` | Feature configuration. |
| `system` | `map` | System overrides. |


### Static Functions

#### `test_sdk(testopts: Value, sdkopts: Value) -> Rc<SolardemoSDK>`

Create a test client with mock features active. Both arguments may be
`Value::Noval`.

```rust
use solardemo_sdk::{test_sdk, Value};

let client = test_sdk(Value::Noval, Value::Noval);
```


### Instance Methods

#### `moon(entopts: Value) -> Rc<MoonEntity>`

Create a new `MoonEntity` instance. Pass `Value::Noval` for no
initial options.

#### `planet(entopts: Value) -> Rc<PlanetEntity>`

Create a new `PlanetEntity` instance. Pass `Value::Noval` for no
initial options.

#### `options_map() -> Value`

Return a deep copy of the current SDK options.

#### `get_utility() -> Rc<Utility>`

Return a copy of the SDK utility object.

#### `direct(fetchargs: Value) -> Result<Value, SolardemoError>`

Make a direct HTTP request to any API endpoint. `Ok` is a result `Value::Map`
with `ok`, `status`, `headers`, and `data` (or `err` on failure). This
escape hatch resolves to `Ok` even on a non-2xx response — branch on
`getp(&result, "ok")`.

**Parameters (`fetchargs` map keys):**

| Key | Value type | Description |
| --- | --- | --- |
| `path` | `string` | URL path with optional `{param}` placeholders. |
| `method` | `string` | HTTP method (default: `"GET"`). |
| `params` | `map` | Path parameter values. |
| `query` | `map` | Query string parameters. |
| `headers` | `map` | Request headers (merged with defaults). |
| `body` | `any` | Request body (maps are JSON-serialized). |

#### `prepare(fetchargs: Value) -> Result<Value, SolardemoError>`

Prepare a fetch definition without sending. Returns the fetchdef on `Ok`.


---

## MoonEntity

```rust
let moon = client.moon(Value::Noval);
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `f64` | Yes |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `planet_id` | `String` | Yes |  |

### Operations

#### `create(reqdata: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Create a new entity with the given data. Returns the created entity data on `Ok` and `Err` on failure.

```rust
let result = client.moon(Value::Noval).create(jo(vec![
    ("planet_id", Value::str("example_planet_id")),  // String
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```

#### `list(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

List entities matching the given criteria. The match is optional — pass `Value::Noval` to list all records. `Ok` is a `Value::List`.

```rust
let results = client.moon(Value::Noval).list(Value::Noval, Value::Noval).unwrap();
if let Value::List(items) = &results {
    for moon in items.borrow().iter() {
        println!("{:?}", moon);
    }
}
```

#### `load(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Load a single entity matching the given criteria. Returns the entity data on `Ok` and `Err` on failure.

```rust
let result = client.moon(Value::Noval).load(jo(vec![("id", Value::str("moon_id")), ("planet_id", Value::str("planet_id"))]), Value::Noval).unwrap();
```

#### `remove(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Remove the entity matching the given criteria. `Err` on failure.

```rust
let result = client.moon(Value::Noval).remove(jo(vec![("id", Value::str("moon_id")), ("planet_id", Value::str("planet_id"))]), Value::Noval).unwrap();
```

#### `update(reqdata: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Update an existing entity. The data must include the entity id. Returns the updated entity data on `Ok`.

```rust
let result = client.moon(Value::Noval).update(jo(vec![
    ("id", Value::str("moon_id")),
    ("planet_id", Value::str("planet_id")),
    // Fields to update
]), Value::Noval).unwrap();
```

### Common Methods

#### `data(args: Option<&Value>) -> Value`

Get the entity data. Pass `Some(&map)` to set it.

#### `matchv(args: Option<&Value>) -> Value`

Get the entity match criteria. Pass `Some(&map)` to set it.

#### `make() -> Rc<dyn Entity>`

Create a new `MoonEntity` instance with the same options.

#### `get_name() -> String`

Return the entity name.


---

## PlanetEntity

```rust
let planet = client.planet(Value::Noval);
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `f64` | Yes |  |
| `forbid` | `bool` | No |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `ok` | `bool` | No |  |
| `start` | `bool` | No |  |
| `state` | `String` | No |  |
| `stop` | `bool` | No |  |
| `why` | `String` | No |  |

### Operations

#### `create(reqdata: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Create a new entity with the given data. Returns the created entity data on `Ok` and `Err` on failure.

```rust
let result = client.planet(Value::Noval).create(jo(vec![
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```

#### `list(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

List entities matching the given criteria. The match is optional — pass `Value::Noval` to list all records. `Ok` is a `Value::List`.

```rust
let results = client.planet(Value::Noval).list(Value::Noval, Value::Noval).unwrap();
if let Value::List(items) = &results {
    for planet in items.borrow().iter() {
        println!("{:?}", planet);
    }
}
```

#### `load(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Load a single entity matching the given criteria. Returns the entity data on `Ok` and `Err` on failure.

```rust
let result = client.planet(Value::Noval).load(jo(vec![("id", Value::str("planet_id"))]), Value::Noval).unwrap();
```

#### `remove(reqmatch: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Remove the entity matching the given criteria. `Err` on failure.

```rust
let result = client.planet(Value::Noval).remove(jo(vec![("id", Value::str("planet_id"))]), Value::Noval).unwrap();
```

#### `update(reqdata: Value, ctrl: Value) -> Result<Value, SolardemoError>`

Update an existing entity. The data must include the entity id. Returns the updated entity data on `Ok`.

```rust
let result = client.planet(Value::Noval).update(jo(vec![
    ("id", Value::str("planet_id")),
    // Fields to update
]), Value::Noval).unwrap();
```

### Common Methods

#### `data(args: Option<&Value>) -> Value`

Get the entity data. Pass `Some(&map)` to set it.

#### `matchv(args: Option<&Value>) -> Value`

Get the entity match criteria. Pass `Some(&map)` to set it.

#### `make() -> Rc<dyn Entity>`

Create a new `PlanetEntity` instance with the same options.

#### `get_name() -> String`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```rust
let client = SolardemoSDK::new(jo(vec![
    ("feature", jo(vec![
        ("test", jo(vec![("active", Value::Bool(true))])),
    ])),
]));
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

