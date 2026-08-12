
import { Context } from './Context'


class VoxgigSolardemoError extends Error {

  isVoxgigSolardemoError = true

  sdk = 'VoxgigSolardemo'

  code: string
  ctx: Context

  constructor(code: string, msg: string, ctx: Context) {
    super(msg)
    this.code = code
    this.ctx = ctx
  }

}

export {
  VoxgigSolardemoError
}

