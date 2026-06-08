
// go/AGENTS.md — how an AI coding agent uses the generated Go SDK.
// Server-agnostic: describes pointing the client at any compatible API.

import {
  cmp,
  File,
  Content,
} from '@voxgig/sdkgen'

import { sdkNames, entityInfo, rootEntity, claudeMd } from '../../AgentInfo'


const AgentsGo = cmp(function AgentsGo(props: any) {
  const { ctx$: { model } } = props

  const s = sdkNames(model)
  const entities = entityInfo(model)

  const example = rootEntity(entities)
  const exampleName = example ? example.Name : 'Entity'

  const entitySections = entities.map((e) => {
    const fieldRows = e.fields.length
      ? e.fields.map((f) =>
        `| \`${f.name}\` | ${f.type} | ${f.req ? 'yes' : 'no'} |`).join('\n')
      : '| _(none modelled)_ | | |'

    const opRows = e.ops.map((o) =>
      `| \`${o.name}\` | ${o.method || '—'} | \`${o.path || '—'}\` |`).join('\n')

    return `### ${e.Name}

Handle: \`client.${e.Name}(nil)\`${0 < e.ancestors.length
      ? ` (nested under ${e.ancestors[e.ancestors.length - 1]})` : ''}

Fields:

| Field | Type | Required |
| --- | --- | --- |
${fieldRows}

Operations:

| Operation | Method | Path |
| --- | --- | --- |
${opRows}
`
  }).join('\n')


  File({ name: 'AGENTS.md' }, () => {
    Content(`# AGENTS.md — ${s.Name} Go SDK

Entity-oriented client for the ${s.Name} API using standard Go conventions —
no generics; data flows as \`map[string]any\`.

## Module path

\`\`\`
${s.goModule}
\`\`\`

This module is distributed as source in this repository. The module path has
no remote host, so a downstream project consumes it with a \`replace\` directive
pointing at the SDK source:

\`\`\`
// in the consumer's go.mod
require ${s.goModule} v0.0.0
replace ${s.goModule} => /path/to/${s.goModule}
\`\`\`

## Create a client

\`\`\`go
package main

import (
    "fmt"
    "os"

    sdk "${s.goModule}"
    "${s.goModule}/core"
)

func main() {
    client := sdk.New${s.sdkClass}(map[string]any{
        "base":   os.Getenv("${s.NAME}_BASE_URL"), // API server base URL
        "apikey": os.Getenv("${s.NAME}_APIKEY"),
    })
\`\`\`

The SDK is **server-agnostic**: set \`base\` to whichever API endpoint you target.

## Minimal example

\`\`\`go
    result, err := client.${exampleName}(nil).List(nil, nil)
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
\`\`\`

## Result shape

Operations return \`(result, err)\`. Convert the result with
\`core.ToMapAny(result)\`; it carries:

| Key | Meaning |
| --- | --- |
| \`ok\` | \`true\` when the HTTP status is 2xx |
| \`status\` | HTTP status code |
| \`headers\` | response headers |
| \`data\` | parsed JSON body (\`map[string]any\` or \`[]any\`) |

## Entities

${entitySections}
## Conventions for agents

- Obtain a handle with \`client.${exampleName}(nil)\`, then call an operation
  method (\`List\`, \`Load\`, \`Create\`, \`Update\`, \`Remove\`).
- Operation methods take \`(args map[string]any, ctrl map[string]any)\` and
  return \`(any, error)\`. Pass \`nil\` when you have no args.
- Use \`core.ToMapAny\` to read the result; branch on \`rm["ok"]\`.
- Full prose reference: [\`README.md\`](README.md) and [\`REFERENCE.md\`](REFERENCE.md).

## Building this SDK from source

This package is **generated** from \`../.sdk\`. Do not hand-edit files here.

\`\`\`bash
cd go
go build ./...
go test ./...
\`\`\`

To change behaviour, edit the model/templates in \`../.sdk\` and regenerate
(see [\`../AGENTS.md\`](../AGENTS.md)).
`)
  })

  File({ name: 'CLAUDE.md' }, () => {
    Content(claudeMd())
  })

})


export {
  AgentsGo,
}
