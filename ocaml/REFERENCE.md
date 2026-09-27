# VoxgigSolardemo OCaml SDK Reference

Complete API reference for the VoxgigSolardemo OCaml SDK.


## Sdk_client

### Constructor

```ocaml
open Voxgig_struct
open Sdk_helpers

let client = Sdk_client.make options
```

Create a new SDK client instance from a `value` options map. Use
`Sdk_client.make0 ()` for defaults.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `value` | SDK configuration options (a Map). |
| `base` | `string` | Base URL for API requests. |
| `prefix` | `string` | URL prefix appended after base. |
| `suffix` | `string` | URL suffix appended after path. |
| `headers` | `map` | Custom headers for all requests. |
| `feature` | `map` | Feature configuration. |
| `system` | `map` | System overrides (e.g. custom fetch). |


### Static constructors

#### `Sdk_client.test testopts sdkopts`

Create a test client with mock features active. Both arguments may be `Noval`
(`Sdk_client.test ()` uses defaults, `Sdk_client.test_with` takes explicit
options).

```ocaml
let client = Sdk_client.test ()
```


### Instance functions

#### `Sdk_client.moon client entopts : entity_obj`

Create a `Moon` entity accessor. Pass `Noval` for no initial options.

#### `Sdk_client.planet client entopts : entity_obj`

Create a `Planet` entity accessor. Pass `Noval` for no initial options.

#### `Sdk_client.direct client fetchargs : value`

Make a direct HTTP request to any API endpoint. Returns a result `value` map
with `ok`, `status`, `headers`, and `data` (or `err` on failure). This
escape hatch never raises — branch on `getp result "ok"`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `path` | `string` | URL path with optional `{param}` placeholders. |
| `method` | `string` | HTTP method (default: `"GET"`). |
| `params` | `map` | Path parameter values. |
| `query` | `map` | Query string parameters. |
| `headers` | `map` | Request headers (merged with defaults). |
| `body` | `value` | Request body (Maps are JSON-serialized). |

**Returns:** a result `value` map.

#### `Sdk_client.prepare client fetchargs : value`

Prepare a fetch definition without sending. Returns the `fetchdef` and raises
on error.


---

## Moon

```ocaml
let moon = Sdk_client.moon client Noval
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `float` | Yes |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `planet_id` | `string` | Yes |  |

### Operations

#### `e_create reqdata ctrl : entity_obj`

Create a new entity with the given data. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.moon client Noval).e_create (jo [
    ("planet_id", (Str "example_planet_id"));  (* string *)
    ("diameter", (Num 1.));  (* float *)
    ("id", (Str "example_id"));  (* string *)
    ("kind", (Str "example_kind"));  (* string *)
    ("name", (Str "example_name"));  (* string *)
]) Noval
let result_data = result.e_data_get ()
```

#### `e_list reqmatch ctrl : entity_obj list`

List entities matching the given criteria. The match is optional — pass `(empty_map ())` to list all records. Resolves to one ENTITY per record and raises on error.

```ocaml
(* One ENTITY per record; the record is reached with e_data_get. *)
let results = (Sdk_client.moon client Noval).e_list (empty_map ()) Noval in
List.iter (fun e -> print_endline (stringify (e.e_data_get ()))) results
```

#### `e_load reqmatch ctrl : entity_obj`

Load a single entity matching the given criteria. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.moon client Noval).e_load (jo [("id", (Str "moon_id")); ("planet_id", (Str "planet_id"))]) Noval
let result_data = result.e_data_get ()
```

#### `e_remove reqmatch ctrl : entity_obj`

Remove the entity matching the given criteria. Resolves to the ENTITY, marked deleted (`e_deleted`); it keeps the data it held. Raises on error.

```ocaml
let result = (Sdk_client.moon client Noval).e_remove (jo [("id", (Str "moon_id")); ("planet_id", (Str "planet_id"))]) Noval
let result_data = result.e_data_get ()
```

#### `e_update reqdata ctrl : entity_obj`

Update an existing entity. The data must include the entity `id`. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.moon client Noval).e_update (jo [
    ("id", (Str "moon_id"));
    ("planet_id", (Str "planet_id"));
    (* Fields to update *)
]) Noval
let result_data = result.e_data_get ()
```

### Common Fields

#### `e_data_get : unit -> value`

Get the entity data.

#### `e_data_set : value -> unit`

Set the entity data.

#### `e_match_get : unit -> value`

Get the entity match criteria.

#### `e_match_set : value -> unit`

Set the entity match criteria.

#### `e_make : unit -> entity_obj`

Create a new `Moon` entity accessor with the same options.

#### `e_name : string`

The entity name.


---

## Planet

```ocaml
let planet = Sdk_client.planet client Noval
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `float` | Yes |  |
| `forbidReason` | `string` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `string` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `terraformState` | `string` | No | Set by the terraform action, and absent until it first runs. |

### Operations

#### `e_create reqdata ctrl : entity_obj`

Create a new entity with the given data. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.planet client Noval).e_create (jo [
    ("diameter", (Num 1.));  (* float *)
    ("id", (Str "example_id"));  (* string *)
    ("kind", (Str "example_kind"));  (* string *)
    ("name", (Str "example_name"));  (* string *)
]) Noval
let result_data = result.e_data_get ()
```

#### `e_list reqmatch ctrl : entity_obj list`

List entities matching the given criteria. The match is optional — pass `(empty_map ())` to list all records. Resolves to one ENTITY per record and raises on error.

```ocaml
(* One ENTITY per record; the record is reached with e_data_get. *)
let results = (Sdk_client.planet client Noval).e_list (empty_map ()) Noval in
List.iter (fun e -> print_endline (stringify (e.e_data_get ()))) results
```

#### `e_load reqmatch ctrl : entity_obj`

Load a single entity matching the given criteria. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.planet client Noval).e_load (jo [("id", (Str "planet_id"))]) Noval
let result_data = result.e_data_get ()
```

#### `e_remove reqmatch ctrl : entity_obj`

Remove the entity matching the given criteria. Resolves to the ENTITY, marked deleted (`e_deleted`); it keeps the data it held. Raises on error.

```ocaml
let result = (Sdk_client.planet client Noval).e_remove (jo [("id", (Str "planet_id"))]) Noval
let result_data = result.e_data_get ()
```

#### `e_update reqdata ctrl : entity_obj`

Update an existing entity. The data must include the entity `id`. Resolves to the ENTITY (read the record with `e_data_get`) and raises on error.

```ocaml
let result = (Sdk_client.planet client Noval).e_update (jo [
    ("id", (Str "planet_id"));
    (* Fields to update *)
]) Noval
let result_data = result.e_data_get ()
```

### Common Fields

#### `e_data_get : unit -> value`

Get the entity data.

#### `e_data_set : value -> unit`

Set the entity data.

#### `e_match_get : unit -> value`

Get the entity match criteria.

#### `e_match_set : value -> unit`

Set the entity match criteria.

#### `e_make : unit -> entity_obj`

Create a new `Planet` entity accessor with the same options.

#### `e_name : string`

The entity name.


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

```ocaml
let client = Sdk_client.make (jo [
    ("feature", jo [
        ("debug", jo [("active", Bool true)]);
        ("idempotency", jo [("active", Bool true)]);
        ("metrics", jo [("active", Bool true)]);
        ("paging", jo [("active", Bool true)]);
        ("ratelimit", jo [("active", Bool true)]);
        ("retry", jo [("active", Bool true)]);
        ("secrets", jo [("active", Bool true)]);
        ("test", jo [("active", Bool true)]);
        ("timeout", jo [("active", Bool true)]);
    ]);
])
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

