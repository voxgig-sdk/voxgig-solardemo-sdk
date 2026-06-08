
// ts/AGENTS.md — how an AI coding agent uses the generated TypeScript SDK.
// Server-agnostic: describes pointing the client at any compatible API.

import {
  cmp,
  File,
  Content,
} from '@voxgig/sdkgen'

import { sdkNames, entityInfo, rootEntity, claudeMd } from '../../AgentInfo'


const AgentsTs = cmp(function AgentsTs(props: any) {
  const { ctx$: { model } } = props

  const s = sdkNames(model)
  const entities = entityInfo(model)

  // Prefer a root collection entity for the quick-start example.
  const example = rootEntity(entities)

  const entitySections = entities.map((e) => {
    const fieldRows = e.fields.length
      ? e.fields.map((f) =>
        `| \`${f.name}\` | ${f.type} | ${f.req ? 'yes' : 'no'} |`).join('\n')
      : '| _(none modelled)_ | | |'

    const opRows = e.ops.map((o) =>
      `| \`${o.name}\` | ${o.method || '—'} | \`${o.path || '—'}\` |`).join('\n')

    return `### ${e.Name}

Handle: \`client.${e.Name}()\`${0 < e.ancestors.length
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

  const exampleName = example ? example.Name : 'Entity'


  File({ name: 'AGENTS.md' }, () => {
    Content(`# AGENTS.md — ${s.Name} TypeScript SDK

Type-safe, entity-oriented client for the ${s.Name} API. Async/await
throughout; every operation returns a \`Result\`.

## Install

\`\`\`bash
npm install ${s.npmName}
\`\`\`

## Create a client

\`\`\`ts
import { ${s.sdkClass} } from '${s.npmName}'

const client = new ${s.sdkClass}({
  base: process.env.${s.NAME}_BASE_URL,   // base URL of the API server
  apikey: process.env.${s.NAME}_APIKEY,   // bearer credential
})
\`\`\`

The SDK is **server-agnostic**: set \`base\` to whichever API endpoint you target.

## Minimal example

\`\`\`ts
const result = await client.${exampleName}().list()

if (result.ok) {
  for (const item of result.data) {
    console.log(item.id, item.name)
  }
} else {
  console.error(result.status, result.error)
}
\`\`\`

## Result shape

Every entity operation resolves to a \`Result\`:

\`\`\`ts
{
  ok: boolean      // true when the HTTP status is 2xx
  status: number   // HTTP status code
  headers: object  // response headers
  data: any        // parsed JSON body
}
\`\`\`

Always branch on \`result.ok\` before reading \`result.data\`.

## Constructor options

| Option | Type | Description |
| --- | --- | --- |
| \`base\` | \`string\` | Base URL of the API server. |
| \`apikey\` | \`string\` | Credential sent on each request. |
| \`prefix\` | \`string\` | Path prefix prepended to every request. |
| \`suffix\` | \`string\` | Path suffix appended to every request. |
| \`feature\` | \`object\` | Feature activation flags, e.g. \`{ log: { active: true } }\`. |
| \`extend\` | \`Feature[]\` | Extra feature instances (custom hooks). |

## Entities

${entitySections}
## Conventions for agents

- Obtain an entity handle with \`client.${exampleName}()\`, then call an operation.
- Pass match criteria (e.g. \`{ id }\`) to \`load\`/\`remove\`; pass data to
  \`create\`/\`update\`. Nested entities also need their parent id.
- Do not throw on failure — inspect \`result.ok\` / \`result.status\`.
- Full prose reference: [\`README.md\`](README.md) and [\`REFERENCE.md\`](REFERENCE.md).

## Building this SDK from source

This package is **generated** from \`../.sdk\`. Do not hand-edit files here.

\`\`\`bash
cd ts
npm install
npm run build      # tsc --build src test
npm test
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
  AgentsTs,
}
