
import {
  names,
  cmp,
  each,
  getx,
  requirePath,

  Project,
  Folder,

  Main,
  Entity,
  Feature,
  Readme,
  Test,

} from '@voxgig/sdkgen'

import {
  KIT
} from '@voxgig/apidef'


import { transform, select, ismap } from '@voxgig/struct'

import { PointUtil, Content } from 'jostraca'


import { Top } from './Top'
import { BuildSDK } from './BuildSDK'
import { Agents } from './Agents'


const {
  buildPoints,
  SerialPoint,
} = PointUtil




const Root = cmp(function Root(props: any) {
  const { model, ctx$ } = props

  ctx$.util = ctx$.util || {}
  ctx$.util.makeFlow = makeFlow

  // TODO: move to @voxgig/util as duplicated
  model.const = { name: model.name }
  names(model.const, model.name)
  model.const.year = new Date().getFullYear()

  ctx$.model = model

  const target = model.main[KIT].target || {}
  const feature = model.main[KIT].feature || {}
  const entity = model.main[KIT].entity || {}

  ctx$.log.debug({
    point: 'cmp-root', target, entity, feature, note: [
      '\ntarget: \n' + Object.keys(target).map(s => '  ' + s).join('\n'),
      '\nentity:\n' + Object.keys(entity).map(s => '  ' + s).join('\n'),
      '\nfeature:\n' + Object.keys(feature).map(s => '  ' + s).join('\n'),
    ].join('\n')
  })

  names(model, model.name)
  // console.log('MODEL name', model.name, model.Name)

  // Standard Replacements
  ctx$.stdrep = {}
  names(ctx$.stdrep, model.Name, 'Project' + 'Name')
  // console.log('STDREP', stdrep)

  Project({}, () => {

    // TODO: jostraca should accept no props
    Top({})

    // Top-level agent docs (AGENTS.md) + the separate test-server's app/AGENTS.md
    Agents({})

    BuildSDK({})

    each(target, (target: any) => {
      names(target, target.name)

      Folder({ name: target.name }, () => {

        // Per-generation-phase activation. A target's aontu model carries
        // a `phase` map mirroring the feature pattern:
        //
        //   phase: {
        //     entity:     { active: false }
        //     feature:    { active: false }
        //     readme:     { active: false }
        //     agentguide: { active: false }
        //     test:       { active: false }
        //   }
        //
        // Defaults are inclusive — when a phase entry is absent (or
        // active is not explicitly false), the phase runs. Standard
        // language targets don't declare `phase` and keep current
        // behaviour, so this is a no-op for ts/go here.
        //
        // CONSUMER targets need it: go-cli, go-mcp and py-data switch
        // every phase off and emit only Main, because they consume a
        // sibling SDK rather than being one. Without this gate they fail
        // outright with `Cannot find module cmp/<target>/Entity_<target>`,
        // which is exactly what this repo did before the resync — the
        // scaffold grew the gate and this Root.ts never picked it up.
        const phase = target.phase || {}
        const phaseActive = (name: string): boolean =>
          false !== (phase[name] && phase[name].active)

        if (phaseActive('entity')) {
          each(entity, (entity: any) => {
            names(entity, entity.name)
            Entity({ target, entity })
          })
        }

        if (phaseActive('feature')) {
          each(feature).filter((feature: any) => feature.active).map((feature: any) => {
            names(feature, feature.name)
            Feature({ target, feature })
          })
        }

        Main({ target })

        if (phaseActive('readme')) {
          Readme({ target })
        }

        if (phaseActive('test')) {
          Test({ target })
        }

        // Per-SDK usage docs for AI coding agents (server-agnostic).
        //
        // These are this repo's own components, kept in place of the
        // scaffold's standard AgentGuide. They are per-target agent docs,
        // so they belong under the `agentguide` phase — the per-language
        // checks below already exclude any consumer target, but gating
        // them keeps the phase map meaning one thing everywhere.
        if (phaseActive('agentguide')) {
          // Convention, not a hardcoded target list. This was an if/else on
          // 'ts' and 'go' with both components statically imported, so a third
          // target's agent docs needed an edit HERE as well as a new
          // component — and silently generated nothing until someone
          // remembered. Now cmp/<target>/Agents_<target> is used when it
          // exists, and a target without one contributes no agent doc.
          //
          // `ignore: true` swallows only a genuine module-not-found; a
          // component that resolves and then throws still propagates, so a
          // broken Agents_* fails loudly rather than quietly emitting nothing.
          const agentsPath = 'cmp/' + target.name + '/Agents_' + target.name
          const agentsMod = requirePath(ctx$, agentsPath, { ignore: true })

          const Agents = agentsMod && (
            agentsMod['Agents' + target.name.charAt(0).toUpperCase() + target.name.slice(1)] ||
            agentsMod.default
          )

          if (Agents) {
            Agents({ target })
          }
        }
      })
    })

  })
})


function makeFlow(def: any, data: any, stepMakers: Record<string, any>) {

  const steps: any = {}
  each(stepMakers, (n: any) => {
    // TODO: support after?
    if ('function' === typeof n.val$) {
      steps[n.key$] = (id: any, pdef: any) => makeFlowStep(id(), pdef, n.val$)
    }
    else if ('string' === typeof n.val$) {
      steps[n.key$] = (id: any, pdef: any) => makeFlowStep(id(), pdef, (sd: any, pctx: any) => {
        Content({
          indent: pctx.data.indent,
          extra: {
            __stepdef: sd
          },
        }, n.val$)
      })
    }
    else if (Array.isArray(n)) {
      steps[(n as any).key$] =
        (id: any, pdef: any) => makeFlowStep(id(), pdef, (sd: any, pctx: any) => {
          const extra = {
            __stepdef: sd
          }
          for (let tmdef of n) {
            let tmtxt
            if ('string' === typeof tmdef) {
              tmtxt = tmdef
            }
            else if (Array.isArray(tmdef)) {
              let pass = true
              let cond = tmdef[0]
              tmtxt = tmdef[1]

              if ('string' === typeof cond) {
                pass = (null != getx(extra, tmdef[0]) || null != getx(pctx.data.model, tmdef[0]))
              }
              else if (ismap(cond)) {
                let children = [{ ...pctx.data.model, ...extra }]
                let found = select(
                  children,
                  cond
                )
                pass = 0 < found.length
              }

              if (!pass) {
                tmtxt = tmdef[2]
              }
            }
            else if ('function' === typeof tmdef) {
              tmdef(sd, pctx)
            }

            if (null != tmtxt) {
              Content({
                indent: pctx.data.indent,
                extra,
              }, tmtxt)
            }
          }
        })
    }
  })

  each(def.step, (step: any) => {
    names(step, step.entity, 'entity')
  })

  // console.log('STEPS', stepMakers, steps, def)

  const spec = transform(def, {
    p: ['`$EACH`', 'step', {
      k: 'FlowStep',
      a: '`.`',
      p: [
        { k: 'GetEntity', a: '`...`' },
        { k: 'EntityMatch', a: '`...`' },
        { k: 'EntityData', a: '`...`' },
        { k: 'EntityAction', a: '`...`' },
        { k: 'ExplainAction', a: '`...`' },
        { k: 'ValidateAction', a: '`...`' },
      ]
    }]
  })

  const rootPoint = buildPoints(spec, steps) as any

  data = data || {}
  data.step = {}

  rootPoint.direct(data)
}


function makeFlowStep(
  id: string,
  pdef: any,
  before: any,
  after?: any,
  _parent?: any
): any {

  class FlowStep extends SerialPoint {
    pdef: any

    constructor(id: string, pdef: any) {
      super(id)
      this.pdef = pdef
    }

    async run(pctx: any): Promise<void> {
      const stepdef = pdef.a
      if (stepdef.ref) {
        const refstep = pctx.data.step[stepdef.ref]
        stepdef.kind = refstep.kind
        stepdef.entity = refstep.entity
        stepdef._ref = stepdef.ref
        delete stepdef.ref
      }

      before.call(this, stepdef, pctx)
      super.run(pctx)
      after && after.call(this, stepdef, pctx)
    }
  }

  return new FlowStep(id, pdef)
}




export {
  KIT,
  Root,
}

