
import { Context, Operation, Alt } from '../types'

import { getprop } from './StructUtility'


const OPKIND: any = {
  create: 'req',
  update: 'req',
  remove: 'req',
  load: 'res',
  list: 'res',
}


function opify(opmap: Record<string, any>) {

  // const validate = getprop(opmap, 'validate', {})

  const op: Operation = {
    name: getprop(opmap, 'name', '_'),
    entity: getprop(opmap, 'entity', '_'),
    select: getprop(opmap, 'select', '_'),
    alts: getprop(opmap, 'alts', []),

    /*
    path: getprop(opmap, 'path', '_'),
    pathalt: getprop(opmap, 'pathalt', []),
    kind: getprop(opmap, 'kind', '_'),
    reqform: getprop(opmap, 'reqform', '_'),
    resform: getprop(opmap, 'resform', '_'),
    validate: {
      params: getprop(validate, 'params', { '`$OPEN`': true }),
    },

    params: getprop(opmap, 'params', []),
    alias: getprop(opmap, 'alias', {}),
    state: getprop(opmap, 'state', {}),
    check: getprop(opmap, 'check', {}),
    */
  }

  return op
}


// Ensure standard operation definition.
// TODO: rename to alt
function operator(ctx: Context): Alt | Error {
  if (ctx.out.alt) {
    return ctx.alt = ctx.out.alt
  }

  const { op, options } = ctx

  if (!options.allow.op.includes(op.name)) {
    return Error('Operation "' + op.name +
      '" not allowed by SDK option allow.op value: "' + options.allow.op + '"')
  }

  // Choose the appropriate operation alternate based on the match or data.
  if (1 === op.alts.length) {
    ctx.alt = op.alts[0]
  }
  else {
    // Operation argument has priority, but also look in current data or match.
    const reqselector = getprop(ctx, 'req' + op.select)
    const selector = getprop(ctx, op.select)

    let alt
    for (let i = 0; i < op.alts.length; i++) {
      alt = op.alts[i]
      const select = alt.select
      let found = true

      if (selector && select.exist) {
        for (let j = 0; j < select.exist.length; j++) {
          const existkey = select.exist[j]

          if (
            undefined === getprop(reqselector, existkey)
            && undefined === getprop(selector, existkey)
          ) {
            found = false
            break
          }
        }
      }

      // Action is only in operation argument.
      if (found && reqselector.$action !== select.$action) {
        found = false
      }

      if (found) {
        break
      }
    }

    if (
      null != reqselector.$action &&
      null != alt &&
      reqselector.$action !== alt.select.$action
    ) {
      return Error('Operation "' + op.name +
        '" action "' + reqselector.$action + '" is not valid.')
    }

    ctx.alt = alt
  }

  return ctx.alt
}


export {
  opify,
  operator,
}
