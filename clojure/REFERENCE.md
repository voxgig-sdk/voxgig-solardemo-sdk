# Solardemo Clojure SDK Reference

Complete API reference for the Solardemo Clojure SDK.


## Client

### make-sdk

```clojure
(require '[sdk.api :as api]
         '[voxgig.struct :as vs])

(def client (api/make-sdk options))
```

Create a new SDK client instance. `options` is a `voxgig.struct` map.

**Options:**

| Key | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL for API requests. |
| `prefix` | `string` | URL prefix appended after base. |
| `suffix` | `string` | URL suffix appended after path. |
| `headers` | `map` | Custom headers for all requests. |
| `feature` | `map` | Feature configuration. |
| `system` | `map` | System overrides (e.g. custom fetch). |


### Test client

#### `(api/test-sdk testopts sdkopts)`

Create a test client with mock features active. Both arguments may be `nil`.

```clojure
(def client (api/test-sdk nil nil))
```


### Client functions

#### `(api/moon client data)`

Create a new `Moon` entity instance. Pass `nil` for no initial data.

#### `(api/planet client data)`

Create a new `Planet` entity instance. Pass `nil` for no initial data.

#### `(api/options-map client) -> map`

Return a deep copy of the current SDK options.

#### `(api/get-utility client) -> utility`

Return a copy of the SDK utility object.

#### `(api/direct client fetchargs) -> map`

Make a direct HTTP request to any API endpoint. Returns a result `map` with `ok`, `status`, `headers`, and `data` (or `err` on failure). This escape hatch never raises — branch on `(vs/getprop result "ok")`.

**Fetch args:**

| Key | Type | Description |
| --- | --- | --- |
| `path` | `string` | URL path with optional `{param}` placeholders. |
| `method` | `string` | HTTP method (default: `"GET"`). |
| `params` | `map` | Path parameter values. |
| `query` | `map` | Query string parameters. |
| `headers` | `map` | Request headers (merged with defaults). |
| `body` | `any` | Request body (maps are JSON-serialized). |

**Returns:** a result `map`.

#### `(api/prepare client fetchargs) -> map`

Prepare a fetch definition without sending. Returns the `fetchdef` and raises on error.


---

## Moon

```clojure
(require '[sdk.entity.moon :as e-moon])

(def moon (api/moon client nil))
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `planet_id` | `string` | Yes |  |

### Operations

#### `(create ent reqdata ctrl) -> map`

Create a new entity with the given data. Returns the created entity data and raises on error.

```clojure
(def result
  (e-moon/create (api/moon client nil)
    (vs/jm
      "planet_id" "example_planet_id"  ;; string
      "diameter" 1  ;; double
      "id" "example_id"  ;; string
      "kind" "example_kind"  ;; string
      "name" "example_name"  ;; string
      )
    nil))
```

#### `(list ent reqmatch ctrl) -> vector`

List entities matching the given criteria. The match is optional — call with `nil` to list all records. Returns a vector and raises on error.

```clojure
(doseq [moon (e-moon/list (api/moon client nil) nil nil)]
  (println moon))
```

#### `(load ent reqmatch ctrl) -> map`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```clojure
(def result (e-moon/load (api/moon client nil) (vs/jm "id" "moon_id" "planet_id" "planet_id") nil))
```

#### `(remove ent reqmatch ctrl) -> map`

Remove the entity matching the given criteria. Raises on error.

```clojure
(def result (e-moon/remove (api/moon client nil) (vs/jm "id" "moon_id" "planet_id" "planet_id") nil))
```

#### `(update ent reqdata ctrl) -> map`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```clojure
(def result
  (e-moon/update (api/moon client nil)
    (vs/jm
      "id" "moon_id"
      "planet_id" "planet_id"
      ;; Fields to update
      )
    nil))
```

### Common Members

State accessors are stored on the entity map and called via keyword lookup.

#### `((:data-get ent)) -> map`

Get the entity data.

#### `((:data-set ent) data)`

Set the entity data.

#### `((:match-get ent)) -> map`

Get the entity match criteria.

#### `((:match-set ent) match)`

Set the entity match criteria.

#### `((:make ent)) -> entity`

Create a new `Moon` entity instance with the same options.

#### `((:get-name ent)) -> string`

Return the entity name.


---

## Planet

```clojure
(require '[sdk.entity.planet :as e-planet])

(def planet (api/planet client nil))
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `double` | Yes |  |
| `forbid` | `boolean` | No |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `ok` | `boolean` | No |  |
| `start` | `boolean` | No |  |
| `state` | `string` | No |  |
| `stop` | `boolean` | No |  |
| `why` | `string` | No |  |

### Operations

#### `(create ent reqdata ctrl) -> map`

Create a new entity with the given data. Returns the created entity data and raises on error.

```clojure
(def result
  (e-planet/create (api/planet client nil)
    (vs/jm
      "diameter" 1  ;; double
      "id" "example_id"  ;; string
      "kind" "example_kind"  ;; string
      "name" "example_name"  ;; string
      )
    nil))
```

#### `(list ent reqmatch ctrl) -> vector`

List entities matching the given criteria. The match is optional — call with `nil` to list all records. Returns a vector and raises on error.

```clojure
(doseq [planet (e-planet/list (api/planet client nil) nil nil)]
  (println planet))
```

#### `(load ent reqmatch ctrl) -> map`

Load a single entity matching the given criteria. Returns the entity data and raises on error.

```clojure
(def result (e-planet/load (api/planet client nil) (vs/jm "id" "planet_id") nil))
```

#### `(remove ent reqmatch ctrl) -> map`

Remove the entity matching the given criteria. Raises on error.

```clojure
(def result (e-planet/remove (api/planet client nil) (vs/jm "id" "planet_id") nil))
```

#### `(update ent reqdata ctrl) -> map`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and raises on error.

```clojure
(def result
  (e-planet/update (api/planet client nil)
    (vs/jm
      "id" "planet_id"
      ;; Fields to update
      )
    nil))
```

### Common Members

State accessors are stored on the entity map and called via keyword lookup.

#### `((:data-get ent)) -> map`

Get the entity data.

#### `((:data-set ent) data)`

Set the entity data.

#### `((:match-get ent)) -> map`

Get the entity match criteria.

#### `((:match-set ent) match)`

Set the entity match criteria.

#### `((:make ent)) -> entity`

Create a new `Planet` entity instance with the same options.

#### `((:get-name ent)) -> string`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```clojure
(def client
  (api/make-sdk
    (vs/jm "feature"
      (vs/jm
        "test" (vs/jm "active" true)
        ))))
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

