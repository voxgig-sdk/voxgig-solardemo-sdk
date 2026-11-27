
import { Context, Spec } from '../types'


function prepareAuth(ctx: Context): Spec | Error {
  const spec = ctx.spec

  if (null == spec) {
    return ctx.error('auth_no_spec', 'Expected context spec property to be defined.')
  }

  return spec
}


export {
  prepareAuth
}
