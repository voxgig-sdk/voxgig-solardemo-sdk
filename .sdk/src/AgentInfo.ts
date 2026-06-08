
// Shared helpers for the AGENTS.md generators.
// Derives consumer-facing SDK identifiers and a normalised view of the model
// entities (fields + operations) so the agent docs stay in sync with the model.

import {
  KIT,
  getModelPath,
  nom,
} from '@voxgig/apidef'


type OpInfo = { name: string, method: string, path: string }
type FieldInfo = { name: string, type: string, req: boolean }
type EntityInfo = {
  name: string
  Name: string
  ancestors: string[]
  ops: OpInfo[]
  fields: FieldInfo[]
}


// Reproduce the naming rules used by Package_ts.ts / Package_go.ts so the
// install + import snippets match the actual published artifacts.
function sdkNames(model: any) {
  const origin = model.origin ? `@${model.origin}/` : ''
  const npmSuffix = model.origin?.endsWith('-sdk') ? '' : '-sdk'
  const npmName = `${origin}${model.name}${npmSuffix}`

  const orgPrefix = (model.origin || '').replace(/-sdk$/, '').replace(/[^a-z0-9]/gi, '')
  const goModule = orgPrefix + model.name + 'sdk'

  const Name = model.const?.Name || nom(model, 'Name')

  return {
    name: model.name,
    Name,
    NAME: String(model.name || '').toUpperCase(),
    npmName,
    goModule,
    sdkClass: Name + 'SDK',
  }
}


const FRIENDLY_TYPE: Record<string, string> = {
  '`$STRING`': 'string',
  '`$NUMBER`': 'number',
  '`$BOOLEAN`': 'boolean',
  '`$OBJECT`': 'object',
  '`$MAP`': 'object',
  '`$ARRAY`': 'array',
  '`$LIST`': 'array',
}

function friendlyType(t: string): string {
  return FRIENDLY_TYPE[t] || 'string'
}


// Pick the canonical endpoint for an operation: the point with no $action
// selector (plain CRUD), falling back to the last declared point.
function primaryPoint(op: any): any {
  const points = op?.points || []
  const plain = points.find((p: any) => !(p.select && p.select.$action))
  return plain || points[points.length - 1] || null
}


function entityInfo(model: any): EntityInfo[] {
  const entityMap = getModelPath(model, `main.${KIT}.entity`) || {}
  const list: EntityInfo[] = []

  for (const key of Object.keys(entityMap)) {
    const e = entityMap[key]
    if (null == e || 'object' !== typeof e || null == e.name || false === e.active) {
      continue
    }

    const ops: OpInfo[] = Object.keys(e.op || {}).sort().map((opname: string) => {
      const pt = primaryPoint(e.op[opname])
      return { name: opname, method: pt?.method || '', path: pt?.orig || '' }
    })

    const fields: FieldInfo[] = (e.fields || []).map((f: any) => ({
      name: f.name,
      type: friendlyType(f.type),
      req: true === f.req,
    }))

    list.push({
      name: e.name,
      Name: nom(e, 'Name'),
      ancestors: e.ancestors || [],
      ops,
      fields,
    })
  }

  return list
}


// Best entity for an introductory example: a root collection whose list
// endpoint takes no path parameters. Falls back to any non-nested entity.
function rootEntity(entities: EntityInfo[]): EntityInfo | undefined {
  return entities.find((e) => e.ops.some((o) => 'list' === o.name && !o.path.includes('{')))
    || entities.find((e) => 0 === e.ancestors.length)
    || entities[0]
}


// Claude Code loads CLAUDE.md, not AGENTS.md. Emit a thin CLAUDE.md that
// imports the sibling AGENTS.md (via the @path syntax) so there is a single
// source of truth shared with AGENTS.md-aware agents.
function claudeMd(): string {
  return `# Claude Code memory

Claude Code loads this file. The shared, tool-agnostic agent guide lives in
AGENTS.md and is imported below.

@AGENTS.md
`
}


// Derive an entity's parent from its operation paths: the last path segment
// (before the entity's own segment) that matches another entity name. Used
// because the model does not populate \`ancestors\`.
function deriveParent(entity: EntityInfo, entities: EntityInfo[]): EntityInfo | undefined {
  const names = new Set(entities.map((e) => e.name))
  for (const op of entity.ops) {
    const parts = op.path.split('/').filter((p) => p && !p.startsWith('{'))
    const self = parts.lastIndexOf(entity.name)
    if (0 < self) {
      for (let i = self - 1; 0 <= i; i--) {
        if (names.has(parts[i]) && parts[i] !== entity.name) {
          return entities.find((e) => e.name === parts[i])
        }
      }
    }
  }
  return undefined
}


export {
  sdkNames,
  entityInfo,
  friendlyType,
  primaryPoint,
  rootEntity,
  claudeMd,
  deriveParent,
}

export type {
  EntityInfo,
  OpInfo,
  FieldInfo,
}
