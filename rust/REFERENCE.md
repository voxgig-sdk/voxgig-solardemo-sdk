# VoxgigSolardemo Rust SDK Reference

Complete API reference for the VoxgigSolardemo Rust SDK.


## VoxgigSolardemoSDK

### Constructor

```rust
use voxgig_solardemo_sdk::{jo, VoxgigSolardemoEntityBase, VoxgigSolardemoSDK, Entity, Value};

let client = VoxgigSolardemoSDK::new(options).expect("valid client options");
```

Create a new SDK client instance. `options` is a `Value` map
(`Value::Noval` for none).

**Parameters:**

| Key | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `headers` | `map` | Headers sent with every request. |
| `feature` | `map` | Feature activation flags. |
| `system` | `map` | System overrides, such as a custom fetch function. |


### Static Functions

#### `test_sdk(testopts: Value, sdkopts: Value) -> Rc<VoxgigSolardemoSDK>`

Create a test client with mock features active. Both arguments may be
`Value::Noval`.

```rust
use voxgig_solardemo_sdk::{test_sdk, Value};

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

#### `direct(fetchargs: Value) -> Result<Value, VoxgigSolardemoError>`

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

#### `prepare(fetchargs: Value) -> Result<Value, VoxgigSolardemoError>`

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

#### `list(reqmatch: Value, ctrl: Value) -> Result<Vec<Rc<Self>>, VoxgigSolardemoError>`

List entities matching the given criteria. The match must include `planet_id`. `Ok` is a `Vec` of entities, one per record.

```rust
let results = client.moon(Value::Noval).list(jo(vec![("planet_id", Value::str("example"))]), Value::Noval).unwrap();
for moon in &results {
    println!("{:?}", moon.data(None));
}
```

#### `load(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Load a single entity matching the given criteria. `Ok` is the entity, whose record `data(None)` reads, and `Err` a failure.

```rust
let result = client.moon(Value::Noval).load(jo(vec![("id", Value::str("moon_id")), ("planet_id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", result.data(None));
```

#### `create(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Create a new entity with the given data. `Ok` is the created entity, and `Err` a failure.

```rust
let result = client.moon(Value::Noval).create(jo(vec![
    ("planet_id", Value::str("example_planet_id")),  // String
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```

#### `update(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Update an existing entity. The data must include the entity `id`. `Ok` is the updated entity.

```rust
let result = client.moon(Value::Noval).update(jo(vec![
    ("id", Value::str("moon_id")),
    ("planet_id", Value::str("planet_id")),
    // Fields to update
]), Value::Noval).unwrap();
```

#### `remove(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Remove the entity matching the given criteria. `Ok` is the entity, marked as deleted, and `Err` a failure.

```rust
let result = client.moon(Value::Noval).remove(jo(vec![("id", Value::str("moon_id")), ("planet_id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", result.data(None));
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
| `forbidReason` | `String` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `String` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `terraformState` | `String` | No | Set by the terraform action, and absent until it first runs. |

### Operations

#### `list(reqmatch: Value, ctrl: Value) -> Result<Vec<Rc<Self>>, VoxgigSolardemoError>`

List entities matching the given criteria. The match is optional — pass `Value::Noval` to list all records. `Ok` is a `Vec` of entities, one per record.

```rust
let results = client.planet(Value::Noval).list(Value::Noval, Value::Noval).unwrap();
for planet in &results {
    println!("{:?}", planet.data(None));
}
```

#### `load(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Load a single entity matching the given criteria. `Ok` is the entity, whose record `data(None)` reads, and `Err` a failure.

```rust
let result = client.planet(Value::Noval).load(jo(vec![("id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", result.data(None));
```

#### `create(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Create a new entity with the given data. `Ok` is the created entity, and `Err` a failure.

```rust
let result = client.planet(Value::Noval).create(jo(vec![
    ("diameter", Value::Num(1.0)),  // f64
    ("id", Value::str("example_id")),  // String
    ("kind", Value::str("example_kind")),  // String
    ("name", Value::str("example_name")),  // String
]), Value::Noval).unwrap();
```

#### `update(reqdata: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Update an existing entity. The data must include the entity `id`. `Ok` is the updated entity.

```rust
let result = client.planet(Value::Noval).update(jo(vec![
    ("id", Value::str("planet_id")),
    // Fields to update
]), Value::Noval).unwrap();
```

#### `remove(reqmatch: Value, ctrl: Value) -> Result<Rc<Self>, VoxgigSolardemoError>`

Remove the entity matching the given criteria. `Ok` is the entity, marked as deleted, and `Err` a failure.

```rust
let result = client.planet(Value::Noval).remove(jo(vec![("id", Value::str("planet_id"))]), Value::Noval).unwrap();
println!("{:?}", result.data(None));
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

```rust
let client = VoxgigSolardemoSDK::new(jo(vec![
    ("feature", jo(vec![
        ("debug", jo(vec![("active", Value::Bool(true))])),
        ("idempotency", jo(vec![("active", Value::Bool(true))])),
        ("metrics", jo(vec![("active", Value::Bool(true))])),
        ("paging", jo(vec![("active", Value::Bool(true))])),
        ("ratelimit", jo(vec![("active", Value::Bool(true))])),
        ("retry", jo(vec![("active", Value::Bool(true))])),
        ("secrets", jo(vec![("active", Value::Bool(true))])),
        ("test", jo(vec![("active", Value::Bool(true))])),
        ("timeout", jo(vec![("active", Value::Bool(true))])),
    ])),
]))
.expect("valid client options");
```


### Configuring features

Each feature is inactive until switched on, and an SDK with no feature
configured does no feature work at all.
Every option below keeps its default unless you name it.

The array form of `feature` is significant: several features wrap the
transport, and the order you list them in is the order they nest.

#### Ordering

`ratelimit`, `retry`, `secrets`, `timeout` wrap the transport. Each
wraps whatever is already installed, so **activation order is nesting order**:
a feature activated later sits OUTSIDE one activated earlier, and sees the call
first.

That decides behaviour, not just sequence: a feature that short-circuits the
call stops every feature nested inside it from
ever seeing that call.

`debug`, `idempotency`, `metrics`, `paging` attach to pipeline hooks
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
| `exchange` | `{active: false, method: 'POST', path: 'auth/token', redirect: 'refuse', refresh: '', request: 'refresh_token', response: 'access_token', retries: 1, statuses: [401]}` |
| `name` | `'apikey'` |
| `providers` | `[]` |

**Usage**

Set `feature.secrets.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Wraps the transport: its place in the activation order decides what it
  sees. See [Ordering](#ordering) above.
- Also attaches to pipeline hooks.
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

- Installs the BASE transport that the wrapping features wrap, so it must be
  activated before them.
- Also attaches to pipeline hooks.
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
| `now` | function |
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

