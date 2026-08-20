# AGENTS.md — Solardemo Go SDK

Entity-oriented client for the Solardemo API using standard Go conventions —
no generics; data flows as `map[string]any`.

## Install

```bash
go get github.com/voxgig-sdk/voxgig-solardemo-sdk/go
```

The module path is the repository path, so the Go proxy resolves it from the
published `go/vX.Y.Z` tags — no `replace` directive, and no local checkout
required:

```
// in the consumer's go.mod
require github.com/voxgig-sdk/voxgig-solardemo-sdk/go vX.Y.Z
```

## Create a client

```go
package main

import (
    "fmt"
    "os"

    sdk "github.com/voxgig-sdk/voxgig-solardemo-sdk/go"
    "github.com/voxgig-sdk/voxgig-solardemo-sdk/go/core"
)

func main() {
    client := sdk.NewSolardemoSDK(map[string]any{
        "base":   os.Getenv("SOLARDEMO_BASE_URL"), // API server base URL
        "apikey": os.Getenv("SOLARDEMO_APIKEY"),
    })
```

The SDK is **server-agnostic**: set `base` to whichever API endpoint you target.

## Minimal example

```go
    result, err := client.Planet(nil).List(nil, nil)
    if err != nil {
        panic(err)
    }

    rm := core.ToMapAny(result)
    if rm["ok"] == true {
        for _, item := range rm["data"].([]any) {
            row := core.ToMapAny(item)
            fmt.Println(row["id"], row["name"])
        }
    }
}
```

## Result shape

Operations return `(result, err)`. Convert the result with
`core.ToMapAny(result)`; it carries:

| Key | Meaning |
| --- | --- |
| `ok` | `true` when the HTTP status is 2xx |
| `status` | HTTP status code |
| `headers` | response headers |
| `data` | parsed JSON body (`map[string]any` or `[]any`) |

## Entities

### Moon

Handle: `client.Moon(nil)`

Fields:

| Field | Type | Required |
| --- | --- | --- |
| `diameter` | number | yes |
| `id` | string | yes |
| `kind` | string | yes |
| `name` | string | yes |
| `planet_id` | string | yes |

Operations:

| Operation | Method | Path |
| --- | --- | --- |
| `create` | POST | `/api/planet/{planet_id}/moon` |
| `list` | GET | `/api/planet/{planet_id}/moon` |
| `load` | GET | `/api/planet/{planet_id}/moon/{moon_id}` |
| `remove` | DELETE | `/api/planet/{planet_id}/moon/{moon_id}` |
| `update` | PUT | `/api/planet/{planet_id}/moon/{moon_id}` |

### Planet

Handle: `client.Planet(nil)`

Fields:

| Field | Type | Required |
| --- | --- | --- |
| `diameter` | number | yes |
| `forbid` | boolean | no |
| `id` | string | yes |
| `kind` | string | yes |
| `name` | string | yes |
| `ok` | boolean | no |
| `start` | boolean | no |
| `state` | string | no |
| `stop` | boolean | no |
| `why` | string | no |

Operations:

| Operation | Method | Path |
| --- | --- | --- |
| `create` | POST | `/api/planet` |
| `list` | GET | `/api/planet` |
| `load` | GET | `/api/planet/{planet_id}` |
| `remove` | DELETE | `/api/planet/{planet_id}` |
| `update` | PUT | `/api/planet/{planet_id}` |

## Conventions for agents

- Obtain a handle with `client.Planet(nil)`, then call an operation
  method (`List`, `Load`, `Create`, `Update`, `Remove`).
- Operation methods take `(args map[string]any, ctrl map[string]any)` and
  return `(any, error)`. Pass `nil` when you have no args.
- Use `core.ToMapAny` to read the result; branch on `rm["ok"]`.
- Full prose reference: [`README.md`](README.md) and [`REFERENCE.md`](REFERENCE.md).

## Building this SDK from source

This package is **generated** from `../.sdk`. Do not hand-edit files here.

```bash
cd go
go build ./...
go test ./...
```

To change behaviour, edit the model/templates in `../.sdk` and regenerate
(see [`../AGENTS.md`](../AGENTS.md)).
