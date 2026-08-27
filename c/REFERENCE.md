# Solardemo C SDK Reference

Complete API reference for the Solardemo C SDK.


## SolardemoSDK

### Constructor

```c
#include "core/api.h"

SolardemoSDK* client = solardemo_sdk_new(options);
```

Create a new SDK client instance. `options` is a `voxgig_value*` map
(`NULL` for none).

**Parameters (`options` map keys):**

| Key | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL for API requests. |
| `prefix` | `string` | URL prefix appended after base. |
| `suffix` | `string` | URL suffix appended after path. |
| `headers` | `map` | Custom headers for all requests. |
| `feature` | `map` | Feature configuration. |
| `system` | `map` | System overrides. |


### Test Constructor

#### `SolardemoSDK* test_sdk(voxgig_value* testopts, voxgig_value* sdkopts)`

Create a test client with mock features active. Both arguments may be
`NULL`.

```c
SolardemoSDK* client = test_sdk(NULL, NULL);
```


### Entity Accessors

#### `Entity* solardemo_moon(SolardemoSDK* client, voxgig_value* entopts)`

Create a new `Moon` entity instance. Pass `NULL` for no initial
options.

#### `Entity* solardemo_planet(SolardemoSDK* client, voxgig_value* entopts)`

Create a new `Planet` entity instance. Pass `NULL` for no initial
options.

#### `voxgig_value* sdk_direct(SolardemoSDK* client, voxgig_value* fetchargs, PNError** err)`

Make a direct HTTP request to any API endpoint. Returns a result map with
`ok`, `status`, `headers`, and `data` (or `err` on failure). This escape
hatch never sets `*err` for a non-2xx response — branch on
`getp(result, "ok")`.

**Parameters (`fetchargs` map keys):**

| Key | Value type | Description |
| --- | --- | --- |
| `path` | `string` | URL path with optional `{param}` placeholders. |
| `method` | `string` | HTTP method (default: `"GET"`). |
| `params` | `map` | Path parameter values. |
| `query` | `map` | Query string parameters. |
| `headers` | `map` | Request headers (merged with defaults). |
| `body` | `any` | Request body (maps are JSON-serialized). |

#### `voxgig_value* sdk_prepare(SolardemoSDK* client, voxgig_value* fetchargs, PNError** err)`

Prepare a fetch definition without sending. Returns the fetchdef and sets
`*err` on failure.


---

## Moon

```c
Entity* moon = solardemo_moon(client, NULL);
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `id` | `char*` | Yes |  |
| `kind` | `char*` | Yes |  |
| `name` | `char*` | Yes |  |
| `planet_id` | `char*` | Yes |  |

### Operations

#### `vt->create(Entity* e, voxgig_value* reqdata, voxgig_value* ctrl, PNError** err)`

Create a new entity with the given data. Returns the created entity data and sets `*err` on failure.

```c
Entity* moon = solardemo_moon(client, NULL);
voxgig_value* result = moon->vt->create(moon, cmap(5,
    "planet_id", v_str("example_planet_id"),  // char*
    "diameter", v_num(1),  // double
    "id", v_str("example_id"),  // char*
    "kind", v_str("example_kind"),  // char*
    "name", v_str("example_name"))  // char*
, NULL, &err);
```

#### `vt->list(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

List entities matching the given criteria. The match is optional — pass `NULL` to list all records. Returns a List.

```c
Entity* moon = solardemo_moon(client, NULL);
voxgig_value* results = moon->vt->list(moon, NULL, NULL, &err);
for (size_t i = 0; i < (size_t)voxgig_size(results); i++) {
    printf("%s\n", voxgig_to_json(voxgig_getelem(results, v_int(i), NULL)));
}
```

#### `vt->load(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

Load a single entity matching the given criteria. Returns the entity data and sets `*err` on failure.

```c
Entity* moon = solardemo_moon(client, NULL);
voxgig_value* result = moon->vt->load(moon, cmap(2, "id", v_str("moon_id"), "planet_id", v_str("planet_id")), NULL, &err);
```

#### `vt->remove(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

Remove the entity matching the given criteria. Sets `*err` on failure.

```c
Entity* moon = solardemo_moon(client, NULL);
voxgig_value* result = moon->vt->remove(moon, cmap(2, "id", v_str("moon_id"), "planet_id", v_str("planet_id")), NULL, &err);
```

#### `vt->update(Entity* e, voxgig_value* reqdata, voxgig_value* ctrl, PNError** err)`

Update an existing entity. The data must include the entity id. Returns the updated entity data.

```c
Entity* moon = solardemo_moon(client, NULL);
voxgig_value* result = moon->vt->update(moon, cmap(2, "id", v_str("moon_id"), "planet_id", v_str("planet_id")), NULL, &err);
```

### Common Methods

#### `voxgig_value* vt->data(Entity* e, voxgig_value* args)`

Get the entity data. Pass a map to set it.

#### `voxgig_value* vt->matchv(Entity* e, voxgig_value* args)`

Get the entity match criteria. Pass a map to set it.

#### `Entity* vt->make(Entity* e)`

Create a new `Moon` entity instance with the same options.

#### `const char* vt->get_name(Entity* e)`

Return the entity name.


---

## Planet

```c
Entity* planet = solardemo_planet(client, NULL);
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `forbid` | `bool` | No |  |
| `id` | `char*` | Yes |  |
| `kind` | `char*` | Yes |  |
| `name` | `char*` | Yes |  |
| `ok` | `bool` | No |  |
| `start` | `bool` | No |  |
| `state` | `char*` | No |  |
| `stop` | `bool` | No |  |
| `why` | `char*` | No |  |

### Operations

#### `vt->create(Entity* e, voxgig_value* reqdata, voxgig_value* ctrl, PNError** err)`

Create a new entity with the given data. Returns the created entity data and sets `*err` on failure.

```c
Entity* planet = solardemo_planet(client, NULL);
voxgig_value* result = planet->vt->create(planet, cmap(4,
    "diameter", v_num(1),  // double
    "id", v_str("example_id"),  // char*
    "kind", v_str("example_kind"),  // char*
    "name", v_str("example_name"))  // char*
, NULL, &err);
```

#### `vt->list(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

List entities matching the given criteria. The match is optional — pass `NULL` to list all records. Returns a List.

```c
Entity* planet = solardemo_planet(client, NULL);
voxgig_value* results = planet->vt->list(planet, NULL, NULL, &err);
for (size_t i = 0; i < (size_t)voxgig_size(results); i++) {
    printf("%s\n", voxgig_to_json(voxgig_getelem(results, v_int(i), NULL)));
}
```

#### `vt->load(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

Load a single entity matching the given criteria. Returns the entity data and sets `*err` on failure.

```c
Entity* planet = solardemo_planet(client, NULL);
voxgig_value* result = planet->vt->load(planet, cmap(1, "id", v_str("planet_id")), NULL, &err);
```

#### `vt->remove(Entity* e, voxgig_value* reqmatch, voxgig_value* ctrl, PNError** err)`

Remove the entity matching the given criteria. Sets `*err` on failure.

```c
Entity* planet = solardemo_planet(client, NULL);
voxgig_value* result = planet->vt->remove(planet, cmap(1, "id", v_str("planet_id")), NULL, &err);
```

#### `vt->update(Entity* e, voxgig_value* reqdata, voxgig_value* ctrl, PNError** err)`

Update an existing entity. The data must include the entity id. Returns the updated entity data.

```c
Entity* planet = solardemo_planet(client, NULL);
voxgig_value* result = planet->vt->update(planet, cmap(1, "id", v_str("planet_id")), NULL, &err);
```

### Common Methods

#### `voxgig_value* vt->data(Entity* e, voxgig_value* args)`

Get the entity data. Pass a map to set it.

#### `voxgig_value* vt->matchv(Entity* e, voxgig_value* args)`

Get the entity match criteria. Pass a map to set it.

#### `Entity* vt->make(Entity* e)`

Create a new `Planet` entity instance with the same options.

#### `const char* vt->get_name(Entity* e)`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```c
SolardemoSDK* client = solardemo_sdk_new(cmap(1,
    "feature", cmap(1,
        "test", cmap(1, "active", v_bool(true)))
));
```

