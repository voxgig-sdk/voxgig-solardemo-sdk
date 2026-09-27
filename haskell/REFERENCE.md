# VoxgigSolardemo Haskell SDK Reference

Complete API reference for the VoxgigSolardemo Haskell SDK.


## Client

### Constructors

```haskell
import qualified SdkClient as Sdk
import VoxgigStruct (Value (..))
import SdkHelpers (jo)

makeClient :: IO Sdk.Client
makeClient = do
  opts <- jo [("base", VStr "https://api.example.com")]
  Sdk.newSdk opts
```

Construct a live SDK client.

**Functions:**

| Function | Signature | Description |
| --- | --- | --- |
| `newSdk` | `Value -> IO Client` | Construct a client from an options map. |
| `newSdk0` | `IO Client` | Construct a client with defaults. |

**Options (map keys):**

| Key | Type | Description |
| --- | --- | --- |
| `base` | `String` | Base URL for API requests. |
| `prefix` | `String` | URL prefix appended after base. |
| `suffix` | `String` | URL suffix appended after path. |
| `headers` | `Value` | Custom headers for all requests. |
| `feature` | `Value` | Feature configuration. |
| `system` | `Value` | System overrides (e.g. custom fetch). |


### Test constructors

```haskell
client <- Sdk.testSdk0
```

`testSdk :: Value -> Value -> IO Client` constructs a test client with mock
features active (`testSdk0 :: IO Client` for the no-argument form). Pass
`VNoval` for defaults.


### Entity accessors

#### `moon :: Client -> Value -> IO Entity`

Construct a `Moon` entity bound to the client. Pass `VNoval` for no initial options.

#### `planet :: Client -> Value -> IO Entity`

Construct a `Planet` entity bound to the client. Pass `VNoval` for no initial options.

### HTTP escape hatches

#### `direct :: Client -> Value -> IO Value` (module `SdkFeatures`)

Make a direct HTTP request to any API endpoint. Returns a result `Value` with
`ok`, `status`, `headers`, and `data` (or `err` on failure). This escape
hatch never raises — branch on `getp result "ok"`.

**Argument (map keys):**

| Key | Type | Description |
| --- | --- | --- |
| `path` | `String` | URL path with optional `{param}` placeholders. |
| `method` | `String` | HTTP method (default: `"GET"`). |
| `params` | `Value` | Path parameter values. |
| `query` | `Value` | Query string parameters. |
| `headers` | `Value` | Request headers (merged with defaults). |
| `body` | `Value` | Request body (maps are JSON-serialized). |

#### `prepare :: Client -> Value -> IO Value` (module `SdkFeatures`)

Prepare a fetch definition without sending. Returns the `fetchdef` and raises on error.


---

## Moon

```haskell
  ent <- Sdk.moon sdk VNoval
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

#### `eCreate ent data ctrl :: IO Entity`

Create a new entity with the given data. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.moon sdk VNoval
  d <- jo
    [ ("planet_id", VStr "example_planet_id")   -- String
    , ("diameter", VNum 1)   -- Double
    , ("id", VStr "example_id")   -- String
    , ("kind", VStr "example_kind")   -- String
    , ("name", VStr "example_name")   -- String
    ]
  ctrl <- emptyMap
  result <- Sdk.eCreate ent d ctrl   -- the ENTITY
  d2 <- Sdk.eDataGet result
```

#### `eList ent match ctrl :: IO [Entity]`

List entities matching the given criteria. The match is optional — pass an empty map to list all records. Resolves to one ENTITY per record and raises on error.

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- emptyMap
  ctrl <- emptyMap
  results <- Sdk.eList ent match ctrl   -- one ENTITY per record
  datas <- mapM Sdk.eDataGet results
```

#### `eLoad ent match ctrl :: IO Entity`

Load a single entity matching the given criteria. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- jo [("id", VStr "moon_id"), ("planet_id", VStr "planet_id")]
  ctrl <- emptyMap
  result <- Sdk.eLoad ent match ctrl
```

#### `eRemove ent match ctrl :: IO Entity`

Remove the entity matching the given criteria. Resolves to the ENTITY, marked deleted (`eDeleted`); it keeps the data it held. Raises on error.

```haskell
  ent <- Sdk.moon sdk VNoval
  match <- jo [("id", VStr "moon_id"), ("planet_id", VStr "planet_id")]
  ctrl <- emptyMap
  result <- Sdk.eRemove ent match ctrl
```

#### `eUpdate ent data ctrl :: IO Entity`

Update an existing entity. The data must include the entity `id`. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.moon sdk VNoval
  d <- jo
    [ ("id", VStr "moon_id")
    , ("planet_id", VStr "planet_id")
    ]  -- fields to update
  ctrl <- emptyMap
  result <- Sdk.eUpdate ent d ctrl   -- the ENTITY
  d2 <- Sdk.eDataGet result
```

### Common Fields

#### `eDataGet :: IO Value`

Get the entity data.

#### `eDataSet :: Value -> IO ()`

Set the entity data.

#### `eStream :: String -> Value -> Value -> IO [Value]`

Run an operation as a lazy stream of result items.

#### `eMake :: IO Entity`

Create a new `Moon` entity with the same options.

#### `eName :: String`

The entity name.


---

## Planet

```haskell
  ent <- Sdk.planet sdk VNoval
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `Double` | Yes |  |
| `forbidReason` | `String` | No | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `String` | No | Set by the forbid action, and absent until it first runs. |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `terraformState` | `String` | No | Set by the terraform action, and absent until it first runs. |

### Operations

#### `eCreate ent data ctrl :: IO Entity`

Create a new entity with the given data. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.planet sdk VNoval
  d <- jo
    [ ("diameter", VNum 1)   -- Double
    , ("id", VStr "example_id")   -- String
    , ("kind", VStr "example_kind")   -- String
    , ("name", VStr "example_name")   -- String
    ]
  ctrl <- emptyMap
  result <- Sdk.eCreate ent d ctrl   -- the ENTITY
  d2 <- Sdk.eDataGet result
```

#### `eList ent match ctrl :: IO [Entity]`

List entities matching the given criteria. The match is optional — pass an empty map to list all records. Resolves to one ENTITY per record and raises on error.

```haskell
  ent <- Sdk.planet sdk VNoval
  match <- emptyMap
  ctrl <- emptyMap
  results <- Sdk.eList ent match ctrl   -- one ENTITY per record
  datas <- mapM Sdk.eDataGet results
```

#### `eLoad ent match ctrl :: IO Entity`

Load a single entity matching the given criteria. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.planet sdk VNoval
  match <- jo [("id", VStr "planet_id")]
  ctrl <- emptyMap
  result <- Sdk.eLoad ent match ctrl
```

#### `eRemove ent match ctrl :: IO Entity`

Remove the entity matching the given criteria. Resolves to the ENTITY, marked deleted (`eDeleted`); it keeps the data it held. Raises on error.

```haskell
  ent <- Sdk.planet sdk VNoval
  match <- jo [("id", VStr "planet_id")]
  ctrl <- emptyMap
  result <- Sdk.eRemove ent match ctrl
```

#### `eUpdate ent data ctrl :: IO Entity`

Update an existing entity. The data must include the entity `id`. Resolves to the ENTITY (read the record with `eDataGet`) and raises on error.

```haskell
  ent <- Sdk.planet sdk VNoval
  d <- jo
    [ ("id", VStr "planet_id")
    ]  -- fields to update
  ctrl <- emptyMap
  result <- Sdk.eUpdate ent d ctrl   -- the ENTITY
  d2 <- Sdk.eDataGet result
```

### Common Fields

#### `eDataGet :: IO Value`

Get the entity data.

#### `eDataSet :: Value -> IO ()`

Set the entity data.

#### `eStream :: String -> Value -> Value -> IO [Value]`

Run an operation as a lazy stream of result items.

#### `eMake :: IO Entity`

Create a new `Planet` entity with the same options.

#### `eName :: String`

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

```haskell
  active <- jo [("active", VBool True)]
  featureCfg <- jo
    [ ("debug", active)
    , ("idempotency", active)
    , ("metrics", active)
    , ("paging", active)
    , ("ratelimit", active)
    , ("retry", active)
    , ("secrets", active)
    , ("test", active)
    , ("timeout", active)
    ]
  opts <- jo [("feature", featureCfg)]
  client <- Sdk.newSdk opts
```

