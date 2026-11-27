# Solar System API

The Solar System API.

## Start here

This guide introduces the API, the client libraries, and the companion tools in this repository. Start with the API capabilities, choose a client for your application, and use the linked reference when you need exact request and response details.

The selected API surface contains 2 entities and 12 HTTP routes. There are 24 SDK targets and 3 companion tools.

An entity groups related API operations. An operation can have several routes with different inputs or authentication requirements. The SDK exposes the entity and its operations using the conventions of the selected language.

## What the API provides

### Moon

Results: Created; OK; No Content.

SDK operations: `create`, `list`, `load`, `remove`, `update`.

### Planet

Results: OK; Created; No Content.

SDK operations: `create`, `list`, `load`, `remove`, `update`.

Key fields to recognise:

- `forbidReason`: Why the planet is forbidden, carried from the forbid action&#39;s `why`. Absent while the planet is allowed.
- `forbidState`: Set by the forbid action, and absent until it first runs. One of allowed or forbidden.
- `terraformState`: Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.

### Route map

Use this map to locate a capability. Consult the entity reference before supplying request data; routes for the same operation can require different fields.

| Entity | SDK operation | HTTP route | Authentication |
| --- | --- | --- | --- |
| Moon | `create` | `POST /api/planet/{planet_id}/moon` | See reference |
| Moon | `list` | `GET /api/planet/{planet_id}/moon` | See reference |
| Moon | `load` | `GET /api/planet/{planet_id}/moon/{moon_id}` | See reference |
| Moon | `remove` | `DELETE /api/planet/{planet_id}/moon/{moon_id}` | See reference |
| Moon | `update` | `PUT /api/planet/{planet_id}/moon/{moon_id}` | See reference |
| Planet | `create` | `POST /api/planet/{planet_id}/forbid` | See reference |
| Planet | `create` | `POST /api/planet/{planet_id}/terraform` | See reference |
| Planet | `create` | `POST /api/planet` | See reference |
| Planet | `list` | `GET /api/planet` | See reference |
| Planet | `load` | `GET /api/planet/{planet_id}` | See reference |
| Planet | `remove` | `DELETE /api/planet/{planet_id}` | See reference |
| Planet | `update` | `PUT /api/planet/{planet_id}` | See reference |

## Connect to the API

- API server: `http://localhost:8901`

Check authentication for the route you plan to call. A route that declares no authentication can be used without credentials; this does not change the requirements of other routes. Keep credentials in environment variables or a configured secret provider, and keep them out of source control and logs.

## Make a first request

1. Choose the API server and an operation that matches your task.
2. Check the operation’s required input and authentication. Use values valid for your account and environment.
3. Send one request and inspect the returned data before adding retries, concurrency, or a larger batch.

For an SDK call, install or build the chosen client, create a client instance with its documented configuration, and call the required entity operation. Language references describe the argument shape, asynchronous behaviour, and returned values.

## Choose an SDK

Choose the language already used by your application or service. The clients represent the same API model, while package setup, naming, and return types follow each language. Check the selected client’s reference and tests before integrating it into an existing application.

| Client | Repository directory | Distribution |
| --- | --- | --- |
| C | `c/` | Build from source |
| Clojure | `clojure/` | Build from source |
| C++ | `cpp/` | Build from source |
| C# | `csharp/` | Build from source |
| Dart | `dart/` | Build from source |
| Elixir | `elixir/` | Build from source |
| Go | `go/` | Build from source |
| Haskell | `haskell/` | Build from source |
| Java | `java/` | Build from source |
| JavaScript | `js/` | Build from source |
| Kotlin | `kotlin/` | Build from source |
| Lean | `lean/` | Build from source |
| Lua | `lua/` | Build from source |
| OCaml | `ocaml/` | Build from source |
| Perl | `perl/` | Build from source |
| PHP | `php/` | Build from source |
| Python | `py/` | Build from source |
| Ruby | `rb/` | Build from source |
| Rust | `rust/` | Build from source |
| Scala | `scala/` | Build from source |
| Seneca Provider | `seneca-provider/` | Build from source |
| Swift | `swift/` | Build from source |
| TypeScript | `ts/` | Build from source |
| Zig | `zig/` | Build from source |

Build-from-source entries are not marked as published in the project model. Follow the build instructions in that target’s README, then consume the resulting package using your language’s local dependency mechanism. Published entries give the installation command recorded for that client.

## Companion tools

These targets provide another way to use the API. Their available commands or tools can cover a smaller set of operations than the client libraries.

### Go CLI

Use the command-line interface for shell-based tasks and scripts.

Repository directory: `go-cli/`. Not published. Build from the go-cli directory.


### Go MCP server

Use the MCP server to expose supported API operations to an MCP client.

Repository directory: `go-mcp/`. Not published. Build from the go-mcp directory.

- `voxgig-solardemo_list`: List records for an entity. Supported entities: `moon`, `planet`.
- `voxgig-solardemo_load`: Load one record for an entity. Supported entities: `moon`, `planet`.

### Python Data

Use the data integration for analysis and notebook workflows.

Repository directory: `py-data/`. Not published. Build from the py-data directory.


## Operational features

Features supply behaviour around API calls, such as request handling, diagnostics, or local testing. Inclusion in this project does not mean a feature is enabled at runtime. Check the selected SDK’s supported features and configuration defaults, then enable the behaviour your application needs.

- `debug`: Request/response capture ring buffer for debugging
- `idempotency`: Idempotency keys for safe retries of mutating operations
- `metrics`: Statistics capture: per-operation counters and latency
- `paging`: Pagination signals for list operations
- `ratelimit`: Client-side rate limiting via a token bucket
- `retry`: Automatic retry of transient failures with exponential backoff
- `secrets`: Secret access: resolve the API credential through a provider chain, and exchange a refresh token for short-lived access tokens
- `test`: In-memory mock transport for testing without a live server
- `timeout`: Per-request timeout with transport abort

Start with the default client configuration. Add request limits and diagnostics as needed, test error paths, and review retry behaviour before using operations that change data. A retry can repeat an operation unless the API provides a suitable guarantee.

## Continue with the documentation

- Follow the first-call guide for the setup sequence.
- Read the authentication guide before using protected routes.
- Use the API reference for request schemas, response formats, and status codes.
- Check the chosen SDK or companion tool reference for its configuration and supported operations.

