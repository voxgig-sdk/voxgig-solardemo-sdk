# VoxgigSolardemo C++ SDK Reference

Complete API reference for the VoxgigSolardemo C++ SDK.


## VoxgigSolardemoSDK

### Constructor

```cpp
#include "core/sdk.hpp"

using namespace sdk;

auto client = std::make_shared<VoxgigSolardemoSDK>(options);
```

Create a new SDK client instance. `options` is an `sdk::Value` map.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `Value` | SDK configuration options (a map). |
| `options["base"]` | `std::string` | Base URL for API requests. |
| `options["prefix"]` | `std::string` | URL prefix appended after base. |
| `options["suffix"]` | `std::string` | URL suffix appended after path. |
| `options["headers"]` | `Value` | Custom headers for all requests. |
| `options["feature"]` | `Value` | Feature configuration. |
| `options["system"]` | `Value` | System overrides. |


### Static Methods

#### `VoxgigSolardemoSDK::testSDK(testopts, sdkopts)`

Create a test client with mock features active. Both arguments may be
`Value::undef()`; a no-arg overload is also provided.

```cpp
auto client = VoxgigSolardemoSDK::testSDK();
```


### Instance Methods

#### `moon(entopts = Value::undef()) -> std::shared_ptr<MoonEntity>`

Create a new `MoonEntity` instance bound to this client.

#### `planet(entopts = Value::undef()) -> std::shared_ptr<PlanetEntity>`

Create a new `PlanetEntity` instance bound to this client.

#### `optionsMap() -> Value`

Return a deep copy of the current SDK options.

#### `getUtility() -> UtilityPtr`

Return a copy of the SDK utility object.

#### `direct(fetchargs) -> Value`

Make a direct HTTP request to any API endpoint. Returns a result `Value` with `ok`, `status`, `headers`, and `data` (or `err` on failure). This escape hatch never throws — branch on `getp(result, "ok")`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `std::string` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `std::string` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `Value` | Path parameter values. |
| `fetchargs["query"]` | `Value` | Query string parameters. |
| `fetchargs["headers"]` | `Value` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `Value` | Request body (maps are JSON-serialized). |

**Returns:** `Value` (result map)

#### `prepare(fetchargs) -> Value`

Prepare a fetch definition without sending. Returns the `fetchdef` and throws on error.


---

## MoonEntity

```cpp
auto moon = client->moon();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `id` | `std::string` | Yes |  |
| `kind` | `std::string` | Yes |  |
| `name` | `std::string` | Yes |  |
| `planet_id` | `std::string` | Yes |  |

### Operations

#### `create(reqdata, ctrl) -> Value`

Create a new entity with the given data. Returns the created entity data and throws on error.

```cpp
Value result = client->moon()->create(vmap({
    {"planet_id", Value("example_planet_id")},  // std::string
    {"diameter", Value(1)},  // double
    {"id", Value("example_id")},  // std::string
    {"kind", Value("example_kind")},  // std::string
    {"name", Value("example_name")},  // std::string
}), Value::undef());
```

#### `list(reqmatch, ctrl) -> Value`

List entities matching the given criteria. The match is optional — pass `Value::undef()` to list all records. Returns a Value list and throws on error.

```cpp
Value results = client->moon()->list(Value::undef(), Value::undef());
for (const auto& moon : *results.as_list()) {
  std::cout << Struct::jsonify(moon) << std::endl;
}
```

#### `load(reqmatch, ctrl) -> Value`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```cpp
Value result = client->moon()->load(vmap({{"id", Value("moon_id")}, {"planet_id", Value("planet_id")}}), Value::undef());
```

#### `remove(reqmatch, ctrl) -> Value`

Remove the entity matching the given criteria. Throws on error.

```cpp
Value result = client->moon()->remove(vmap({{"id", Value("moon_id")}, {"planet_id", Value("planet_id")}}), Value::undef());
```

#### `update(reqdata, ctrl) -> Value`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```cpp
Value result = client->moon()->update(vmap({
    {"id", Value("moon_id")},
    {"planet_id", Value("planet_id")},
    // Fields to update
}), Value::undef());
```

### Common Methods

#### `data(arg = Value::undef()) -> Value`

Get the entity data (no argument) or set it (with a map argument).

#### `match(arg = Value::undef()) -> Value`

Get the entity match criteria (no argument) or set it (with a map argument).

#### `make() -> EntityPtr`

Create a new `MoonEntity` instance with the same options.

#### `getName() -> std::string`

Return the entity name.


---

## PlanetEntity

```cpp
auto planet = client->planet();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `forbidReason` | `std::string` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `std::string` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `std::string` | Yes |  |
| `kind` | `std::string` | Yes |  |
| `name` | `std::string` | Yes |  |
| `terraformState` | `std::string` | No | Set by the terraform action, and absent until it first runs. |

### Operations

#### `create(reqdata, ctrl) -> Value`

Create a new entity with the given data. Returns the created entity data and throws on error.

```cpp
Value result = client->planet()->create(vmap({
    {"diameter", Value(1)},  // double
    {"id", Value("example_id")},  // std::string
    {"kind", Value("example_kind")},  // std::string
    {"name", Value("example_name")},  // std::string
}), Value::undef());
```

#### `list(reqmatch, ctrl) -> Value`

List entities matching the given criteria. The match is optional — pass `Value::undef()` to list all records. Returns a Value list and throws on error.

```cpp
Value results = client->planet()->list(Value::undef(), Value::undef());
for (const auto& planet : *results.as_list()) {
  std::cout << Struct::jsonify(planet) << std::endl;
}
```

#### `load(reqmatch, ctrl) -> Value`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```cpp
Value result = client->planet()->load(vmap({{"id", Value("planet_id")}}), Value::undef());
```

#### `remove(reqmatch, ctrl) -> Value`

Remove the entity matching the given criteria. Throws on error.

```cpp
Value result = client->planet()->remove(vmap({{"id", Value("planet_id")}}), Value::undef());
```

#### `update(reqdata, ctrl) -> Value`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```cpp
Value result = client->planet()->update(vmap({
    {"id", Value("planet_id")},
    // Fields to update
}), Value::undef());
```

### Common Methods

#### `data(arg = Value::undef()) -> Value`

Get the entity data (no argument) or set it (with a map argument).

#### `match(arg = Value::undef()) -> Value`

Get the entity match criteria (no argument) or set it (with a map argument).

#### `make() -> EntityPtr`

Create a new `PlanetEntity` instance with the same options.

#### `getName() -> std::string`

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

```cpp
auto client = std::make_shared<VoxgigSolardemoSDK>(vmap({
    {"feature", vmap({
        {"debug", vmap({{"active", Value(true)}})},
        {"idempotency", vmap({{"active", Value(true)}})},
        {"metrics", vmap({{"active", Value(true)}})},
        {"paging", vmap({{"active", Value(true)}})},
        {"ratelimit", vmap({{"active", Value(true)}})},
        {"retry", vmap({{"active", Value(true)}})},
        {"secrets", vmap({{"active", Value(true)}})},
        {"test", vmap({{"active", Value(true)}})},
        {"timeout", vmap({{"active", Value(true)}})},
    })},
}));
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

