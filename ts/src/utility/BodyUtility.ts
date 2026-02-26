
import { Context } from '../types'

function body(ctx: Context) {
  const { alt, op, utility } = ctx
  const { error, reqform } = utility

  let body = undefined

  if ('data' === op.select) {
    try {
      body = reqform(ctx)

      console.log('BODY', op.name, alt.parts, body)

      // if (alt.check.nobody && null == body) {
      //   return error(ctx, new Error('Request body is empty.'))
      // }
    }
    catch (err) {
      return error(ctx, err)
    }
  }

  return body
}

export {
  body
}

