
import { Context } from './Context'


class SolardemoError extends Error {

  isSolardemoError = true

  sdk = 'Solardemo'

  code: string
  ctx: Context

  constructor(code: string, msg: string, ctx: Context) {
    super(msg)
    this.code = code
    this.ctx = ctx
  }

}

export {
  SolardemoError
}

