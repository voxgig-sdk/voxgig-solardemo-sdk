
// Shared helpers for the AGENTS.md generators.
// Derives consumer-facing SDK identifiers and a normalised view of the model
// entities (fields + operations) so the agent docs stay in sync with the model.

import {
  KIT,
  getModelPath,
  nom,
} from '@voxgig/apidef'

import {
  packageName,
  goModule,
} from '@voxgig/sdkgen'


type OpInfo = { name: string, method: string, path: string }
type FieldInfo = { name: string, type: string, req: boolean }
type EntityInfo = {
  name: string
  Name: string
  ancestors: string[]
  ops: OpInfo[]
  fields: FieldInfo[]
}


// ASK sdkgen for the published identifiers — never re-derive them here.
//
// This function used to reproduce the derivation rules, and drifted from the
// artifacts it claimed to describe. Both names are PINNED in the model
// precisely because the derivation is wrong for this project:
//
//   npm  derived -> @voxgig-sdk/solardemo   pinned -> @voxgig-sdk/voxgig-solardemo
//   go   derived -> voxgigsolardemosdk      real   -> github.com/voxgig-sdk/
//                                                     voxgig-solardemo-sdk/go
//
// so AGENTS.md told agents to `npm install` a package that does not exist and
// to `replace` a module path Go never resolves. Every other component here
// already calls goModule(model, 'go') (Package_go, Main_go, Entity_go,
// ReadmeQuick_go, ...); this was the one place with a second copy of the rule.
//
// packageName() reads main.kit.target.<t>.publish.registry.package, and
// goModule() reads main.kit.target.<t>.module.path (falling back to the repo
// path), so both honour the pins in model/sdk-base.aon.
function sdkNames(model: any) {
  const Name = model.const?.Name || nom(model, 'Name')

  return {
    name: model.name,
    Name,
    NAME: String(model.name || '').toUpperCase(),
    npmName: packageName(model, 'npm'),
    goModule: goModule(model, 'go'),
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


// The API's own base URL, from the model rather than typed again here.
//
// The agent docs carried this port as a hand-written third copy — the model
// declares it at main.kit.info.servers[0].url, and the generated Config reads
// exactly that path. A hardcoded copy in prose is the kind nothing notices
// going stale: no build breaks, no test fails, the docs just start naming the
// wrong port.
function serverBase(model: any, fallback = 'http://localhost:8901'): string {
  try {
    const servers = getModelPath(model, `main.${KIT}.info.servers`)
    const url = servers && servers[0] && servers[0].url
    return 'string' === typeof url && '' !== url ? url : fallback
  }
  catch (err: any) {
    return fallback
  }
}


// Best entity for an introductory example: a root collection whose list
// endpoint takes no path parameters. Falls back to any non-nested entity.
function rootEntity(entities: EntityInfo[]): EntityInfo | undefined {
  return entities.find((e) => e.ops.some((o) => 'list' === o.name && !o.path.includes('{')))
    || entities.find((e) => 0 === e.ancestors.length)
    || entities[0]
}


export {
  serverBase,
  sdkNames,
  entityInfo,
  friendlyType,
  primaryPoint,
  rootEntity,
}

export type {
  EntityInfo,
  OpInfo,
  FieldInfo,
}
