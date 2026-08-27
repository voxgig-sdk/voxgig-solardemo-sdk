# Solardemo OCaml SDK



The OCaml SDK for the Solardemo API — an entity-oriented client
following idiomatic OCaml conventions (a dependency-free library that compiles
with the stock `ocamlc`).

The SDK exposes the API as capitalised, semantic **Entities** — for example `Sdk_client.moon client Noval` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to the opam registry. Install it from the
GitHub release tag (`ocaml/vX.Y.Z`, see [Releases](https://github.com/voxgig-sdk/solardemo-sdk/releases))
or from a source checkout. The SDK is dependency-free and compiles with the
stock `ocamlc` — no opam packages, no dune:

```bash
cd ocaml && make build
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```ocaml
open Voxgig_struct
open Sdk_helpers

let client = Sdk_client.make0 ()
```

### 2. List moon records

`e_list` resolves to one ENTITY per record and raises on error. Read a
record with `e_data_get`.

```ocaml
(try
   let moons = (Sdk_client.moon client Noval).e_list (empty_map ()) Noval in
   List.iter (fun e -> print_endline (stringify (e.e_data_get ()))) moons
 with Sdk_error.E err -> Printf.eprintf "list failed: %s\n" (Sdk_error.message err))
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`e_load` resolves to the ENTITY and raises on error; `e_data_get` gives the
record.

```ocaml
(try
   let moon = (Sdk_client.moon client Noval).e_load (jo [("planet_id", (Str "example_planet_id")); ("id", (Str "example_id"))]) Noval in
   print_endline (stringify (moon.e_data_get ()))
 with Sdk_error.E err -> Printf.eprintf "load failed: %s\n" (Sdk_error.message err))
```

### 4. Create, update, and remove

```ocaml
(* Create — resolves to the ENTITY; e_data_get gives the record *)
let created = (Sdk_client.moon client Noval).e_create (jo [("planet_id", (Str "example_planet_id")); ("diameter", (Num 1.)); ("id", (Str "example_id")); ("kind", (Str "example_kind")); ("name", (Str "example_name"))]) Noval in
print_endline (stringify (created.e_data_get ()));

(* Update *)
ignore ((Sdk_client.moon client Noval).e_update (jo [("id", (getp created "id")); ("planet_id", (Str "example_planet_id")); ("diameter", (Num 1.))]) Noval);

(* Remove — resolves to the entity, marked deleted; it keeps its data *)
let removed = (Sdk_client.moon client Noval).e_remove (jo [("id", (getp created "id")); ("planet_id", (Str "example_planet_id"))]) Noval in
Printf.printf "deleted: %b\n" removed.e_deleted
```


## Error handling

Entity operations reject on failure, so wrap them in `try` / `catch`:

```ts
try {
  const moons = await client.Moon().list()
  console.log(moons)
} catch (err) {
  console.error('list failed:', err)
}
```

The low-level `direct()` method does **not** throw — it returns the
value or an `Error`, so check the result before using it:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (result instanceof Error) {
  throw result
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```ocaml
let result = Sdk_client.direct client (jo [
    ("path", Str "/api/resource/{id}");
    ("method", Str "GET");
    ("params", jo [("id", Str "example")]);
]) in
(match getp result "ok" with
 | Bool true ->
   print_endline (stringify (getp result "status"));  (* 200 *)
   print_endline (stringify (getp result "data"))      (* response body *)
 | _ ->
   (* A non-2xx response carries status + data (the error body); a transport
      failure carries err instead. Read whichever is present. *)
   print_endline (stringify (getp result "status"));
   print_endline (stringify (getp result "err")))
```

### Prepare a request without sending it

```ocaml
(* prepare returns the fetch definition and raises on error. *)
let fetchdef = Sdk_client.prepare client (jo [
    ("path", Str "/api/resource/{id}");
    ("method", Str "DELETE");
    ("params", jo [("id", Str "example")]);
]) in
print_endline (stringify (getp fetchdef "url"));
print_endline (stringify (getp fetchdef "method"));
print_endline (stringify (getp fetchdef "headers"))
```

### Use test mode

Create a mock client for unit testing — no server required:

```ocaml
let () =
  let client = Sdk_client.test () in
  (* Entity ops resolve to the ENTITY (list: one per record) and raise on error. *)
  let moons = (Sdk_client.moon client Noval).e_list (empty_map ()) Noval in
  List.iter (fun e -> print_endline (stringify (e.e_data_get ()))) moons  (* the mock records *)
```

### Use a custom fetch function

Replace the HTTP transport with your own function:

```ocaml
let mock_fetch = Func (fun _ _args _ _ ->
    jo [("status", Num 200.); ("statusText", Str "OK"); ("headers", empty_map ());
        ("json", json_thunk (jo [("id", Str "mock01")]))]) in
let client = Sdk_client.make (jo [
    ("base", Str "http://localhost:8080");
    ("system", jo [("fetch", mock_fetch)]);
]) in
ignore client
```

### Run live tests

Create a `.env.local` file at the project root:

```
SOLARDEMO_TEST_LIVE=TRUE
```

Then run:

```bash
cd ocaml && make test
```


## Reference

### Sdk_client

```ocaml
open Voxgig_struct
open Sdk_helpers

let client = Sdk_client.make options
```

Creates a new SDK client from a `value` options map. Use `Sdk_client.make0 ()`
for defaults.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `feature` | `map` | Feature activation flags. |
| `extend` | `list` | Additional feature instances to load. |
| `system` | `map` | System overrides (e.g. custom `fetch` function). |

### Sdk_client.test

```ocaml
let client = Sdk_client.test_with testopts sdkopts
```

Creates a test-mode client with mock transport. Both arguments may be `Noval`
(`Sdk_client.test ()` uses defaults).

### Sdk_client functions

| Function | Signature | Description |
| --- | --- | --- |
| `make` | `value -> sdk_client` | Construct a client from options. |
| `make0` | `unit -> sdk_client` | Construct a client with defaults. |
| `prepare` | `sdk_client -> value -> value` | Build an HTTP request definition without sending. Raises on error. |
| `direct` | `sdk_client -> value -> value` | Build and send an HTTP request. Returns a result map (branch on `ok`). |
| `moon` | `sdk_client -> value -> entity_obj` | A Moon entity accessor. |
| `planet` | `sdk_client -> value -> entity_obj` | A Planet entity accessor. |

### Entity interface

All entities are `entity_obj` records sharing the same fields.

| Field | Signature | Description |
| --- | --- | --- |
| `e_load` | `value -> value -> entity_obj` | Load a single entity by match criteria. Resolves to the entity. Raises on error. |
| `e_list` | `value -> value -> entity_obj list` | List entities matching the criteria. Resolves to one entity per record. Raises on error. |
| `e_create` | `value -> value -> entity_obj` | Create a new entity. Resolves to the entity. Raises on error. |
| `e_update` | `value -> value -> entity_obj` | Update an existing entity. Resolves to the entity. Raises on error. |
| `e_remove` | `value -> value -> entity_obj` | Remove an entity. Resolves to the entity, marked deleted. Raises on error. |
| `e_data_get` | `unit -> value` | Get entity data. |
| `e_data_set` | `value -> unit` | Set entity data. |
| `e_match_get` | `unit -> value` | Get entity match criteria. |
| `e_match_set` | `value -> unit` | Set entity match criteria. |
| `e_make` | `unit -> entity_obj` | Create a new instance with the same options. |
| `e_name` | `string` | The entity name. |

### Result shape

Entity operations resolve to the ENTITY, not the raw record — `e_list` to
one entity per record — and raise `Sdk_error.E` on error. The record is
reached through `e_data_get`, which returns the entity's data container.
`e_remove` resolves to the entity marked deleted (`e_deleted`); it keeps the
data it held. Wrap calls in `try`/`with` to handle failures.

The `direct` escape hatch never raises — it returns a result `value` map
you branch on via `getp result "ok"`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `Bool` | `Bool true` if the HTTP status is 2xx. |
| `status` | `Num` | HTTP status code. |
| `headers` | `Map` | Response headers. |
| `data` | `value` | Parsed JSON response body. |

On error, `ok` is `Bool false` and `err` carries the error value.

### Entities

#### Moon

| Field | Description |
| --- | --- |
| `diameter` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `planet_id` |  |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `diameter` |  |
| `forbid` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `ok` |  |
| `start` |  |
| `state` |  |
| `stop` |  |
| `why` |  |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/forbid`



## Entities


### Moon

Create an instance: `let moon = Sdk_client.moon client Noval`

#### Operations

| Method | Description |
| --- | --- |
| `e_create reqdata ctrl` | Create a new entity with the given data. Resolves to the entity. |
| `e_list reqmatch ctrl` | List entities, optionally matching the given criteria. Resolves to one entity per record. |
| `e_load reqmatch ctrl` | Load a single entity by match criteria. Resolves to the entity. |
| `e_remove reqmatch ctrl` | Remove the matching entity. Resolves to the entity, marked deleted. |
| `e_update reqdata ctrl` | Update an existing entity. Resolves to the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `float` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `planet_id` | `string` |  |

#### Example: Load

```ocaml
(* The op resolves to the ENTITY; the record is inside it. *)
let moon = (Sdk_client.moon client Noval).e_load (jo [("id", (Str "moon_id")); ("planet_id", (Str "planet_id"))]) Noval
let moon_data = moon.e_data_get ()
```

#### Example: List

```ocaml
(* One ENTITY per record. *)
let moons = (Sdk_client.moon client Noval).e_list (empty_map ()) Noval
let moon_datas = List.map (fun e -> e.e_data_get ()) moons
```

#### Example: Create

```ocaml
let moon = (Sdk_client.moon client Noval).e_create (jo [
    ("planet_id", (Str "example_planet_id"));  (* string *)
    ("diameter", (Num 1.));  (* float *)
    ("id", (Str "example_id"));  (* string *)
    ("kind", (Str "example_kind"));  (* string *)
    ("name", (Str "example_name"));  (* string *)
]) Noval
let moon_data = moon.e_data_get ()
```


### Planet

Create an instance: `let planet = Sdk_client.planet client Noval`

#### Operations

| Method | Description |
| --- | --- |
| `e_create reqdata ctrl` | Create a new entity with the given data. Resolves to the entity. |
| `e_list reqmatch ctrl` | List entities, optionally matching the given criteria. Resolves to one entity per record. |
| `e_load reqmatch ctrl` | Load a single entity by match criteria. Resolves to the entity. |
| `e_remove reqmatch ctrl` | Remove the matching entity. Resolves to the entity, marked deleted. |
| `e_update reqdata ctrl` | Update an existing entity. Resolves to the entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `float` |  |
| `forbid` | `bool` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `ok` | `bool` |  |
| `start` | `bool` |  |
| `state` | `string` |  |
| `stop` | `bool` |  |
| `why` | `string` |  |

#### Example: Load

```ocaml
(* The op resolves to the ENTITY; the record is inside it. *)
let planet = (Sdk_client.planet client Noval).e_load (jo [("id", (Str "planet_id"))]) Noval
let planet_data = planet.e_data_get ()
```

#### Example: List

```ocaml
(* One ENTITY per record. *)
let planets = (Sdk_client.planet client Noval).e_list (empty_map ()) Noval
let planet_datas = List.map (fun e -> e.e_data_get ()) planets
```

#### Example: Create

```ocaml
let planet = (Sdk_client.planet client Noval).e_create (jo [
    ("diameter", (Num 1.));  (* float *)
    ("id", (Str "example_id"));  (* string *)
    ("kind", (Str "example_kind"));  (* string *)
    ("name", (Str "example_name"));  (* string *)
]) Noval
let planet_data = planet.e_data_get ()
```


## Advanced

> The sections above cover everyday use. The material below explains the
> SDK's internals — useful when extending it with custom features, but not
> needed for normal use.

### The operation pipeline

Every entity operation follows a six-stage pipeline. Each stage fires a
feature hook before executing:

```
PrePoint → PreSpec → PreRequest → PreResponse → PreResult → PreDone
```

- **PrePoint**: Resolves which API endpoint to call based on the
  operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body —
  from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here
  to replace the transport (as TestFeature does with mocks).
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity
  state (match, data) is updated here.

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature is an object with a
`hooks` map. Each hook key is a pipeline stage name, and the value is
a function that receives the context.

The SDK ships with built-in features:

- **TestFeature**: In-memory mock transport for testing without a live server

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as `value`

The OCaml SDK uses a single dynamic `value` type throughout rather than a
typed record per entity. `value` is the vendored voxgig struct port (a
JSON-shaped variant: `Str`, `Num`, `Bool`, `List`, `Map`, `Null`,
`Noval`). This mirrors the dynamic nature of the API and keeps the SDK
flexible — no code generation is needed when the API schema changes.

Build request maps with the `jo` / `ja` helpers and read fields back with
`getp`; use `to_map` to safely coerce a value to a map.

### Module structure

```
ocaml/
├── sdk_client.ml               -- Main SDK client (constructors + accessors)
├── sdk_config.ml               -- Embedded API config + feature factory
├── sdk_error.ml                -- Branded error re-exports
├── sdk_entity_*.ml             -- Per-entity implementations (one each)
├── sdk_types.ml                -- Core pipeline types
├── sdk_helpers.ml              -- jo / ja / getp and friends
├── sdk_runtime.ml              -- Operation pipeline runner
├── sdk_features.ml             -- Built-in features (base, test, log)
├── utility/                    -- Vendored voxgig struct port
└── test/                       -- Test suites
```

The public surface lives in `Sdk_client` (the constructors and per-entity
accessors); `Sdk_helpers` carries the `jo` / `ja` / `getp` value
helpers. Open the runtime modules directly only when needed.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally. Subsequent
calls on the same instance can rely on this state.

```ts
const moon = client.Moon()
await moon.list()

// moon.data() now returns the moon data from the last `list`
// moon.match() returns the last match criteria
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

The `direct` method gives full control over the HTTP request. Use it
for non-standard endpoints, bulk operations, or any path not modelled
as an entity. The `prepare` method is useful for debugging — it
shows exactly what `direct` would send.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
