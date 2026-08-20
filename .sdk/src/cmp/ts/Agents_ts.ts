
// ts/AGENTS.md — how an AI coding agent uses the generated TypeScript SDK.
// Server-agnostic: describes pointing the client at any compatible API.

import {
  cmp,
  File,
  Content,
} from '@voxgig/sdkgen'

import { sdkNames, entityInfo, rootEntity } from '../../AgentInfo'


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
throughout; every entity operation resolves to an **entity** and **throws**
on failure.

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
try {
  for (const item of await client.${exampleName}().list()) {
    console.log(item.data().id, item.data().name)
  }
} catch (err) {
  console.error('list failed:', err)
}
\`\`\`

## Entity operations return ENTITIES

This is the single most important thing to get right, and it is where a
\`Result\`-style API would mislead you:

| Operation | Resolves to | On failure |
| --- | --- | --- |
| \`load\` / \`create\` / \`update\` | the **entity** | **throws** |
| \`list\` | an **array of entities** | **throws** |
| \`remove\` | \`void\` | **throws** |

The record is absorbed into the entity — reach it with \`.data()\`:

\`\`\`ts
const created = await client.${exampleName}().create({ /* ... */ })
console.log(created.data().id)          // the record
const again = await client.${exampleName}().load({ id: created.data().id })
\`\`\`

There is no \`.ok\` and no \`.data\` property on these results, so do not branch
on one — wrap calls in \`try\`/\`catch\` instead.

## \`direct()\` is the exception

The low-level \`direct()\` escape hatch does **not** throw. It returns either an
\`Error\` or a result envelope, so check before use:

\`\`\`ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (result instanceof Error) {
  throw result
}
if (result.ok) {
  console.log(result.status, result.data)
}
\`\`\`

\`\`\`ts
{
  ok: boolean      // true when the HTTP status is 2xx
  status: number   // HTTP status code
  headers: object  // response headers
  data: any        // parsed JSON body
}
\`\`\`

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
- Operations **throw** on failure — use \`try\`/\`catch\`. Only \`direct()\` returns
  an envelope to inspect.
- Read the record off an entity with \`.data()\`; the entity itself is not the
  record.
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

})


export {
  AgentsTs,
}
