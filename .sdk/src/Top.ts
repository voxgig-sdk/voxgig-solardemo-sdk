

import {
  cmp, File, Content, Line,
} from '@voxgig/sdkgen'


import { KIT } from './Root'

import { sdkNames, entityInfo, deriveParent } from './AgentInfo'


const Top = cmp(function Top(props: any) {
  const { ctx$ } = props
  const { model } = ctx$

  const s = sdkNames(model)
  const entities = entityInfo(model)
  const targets = model.main[KIT].target || {}

  File({ name: 'README.md' }, () => {
    Content(`# ${s.Name} SDKs

Generated client SDKs for the ${s.Name} API, produced from a single model by
the generator in [\`.sdk/\`](.sdk). See [\`AGENTS.md\`](AGENTS.md) for how to build
and regenerate them.

## SDKs

`)

    for (const tname of Object.keys(targets)) {
      const t = targets[tname]
      if (null == t || 'object' !== typeof t || null == t.ext) {
        continue
      }
      const title = t.title || tname
      Line(`- **${title}** — [\`${tname}/\`](${tname}) ` +
        `([usage](${tname}/AGENTS.md), [README](${tname}/README.md))`)
    }

    Content(`
## API entities

\`\`\`mermaid
flowchart LR
`)

    // Nodes for every entity, so the diagram is never empty.
    for (const e of entities) {
      Line(`  ${e.Name}["${e.Name}"]`)
    }
    // Edges from path-derived parentage (the model does not populate ancestors).
    for (const e of entities) {
      const p = deriveParent(e, entities)
      if (null != p) {
        Line(`  ${p.Name} --> ${e.Name}`)
      }
    }

    Content(`\`\`\`

`)

    for (const e of entities) {
      const ops = e.ops.map((o) => o.name).join(', ') || '(none)'
      Line(`- **${e.Name}** (\`${e.name}\`) — ${ops}`)
    }

    Content(`

## Test server

A standalone REST server — used to develop and validate the SDKs — lives in
[\`app/\`](app). It is **separate** from the SDKs; see
[\`app/AGENTS.md\`](app/AGENTS.md).
`)
  })

})


export {
  Top
}
