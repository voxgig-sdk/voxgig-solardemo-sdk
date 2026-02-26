
import { Context } from '../types'


function params(ctx: Context) {
  const utility = ctx.utility
  const findparam = utility.findparam

  const struct = utility.struct
  // const { validate } = struct

  const { alt } = ctx

  let { param } = alt.args
  let { reqmatch } = ctx

  param = param || []
  reqmatch = reqmatch || {}

  let out: any = {}
  for (let pd of param) {
    let val = findparam(ctx, pd)
    if (null != val) {
      out[pd.name] = val
    }
  }

  console.log('PARAMS', alt, param, out)

  // out = validate(out, op.validate.params)

  return out
}


export {
  params
}
