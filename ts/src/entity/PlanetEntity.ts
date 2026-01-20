
import { inspect } from 'node:util'

import {
  SolardemoSDK,
  SolardemoEntity,
} from '../SolardemoSDK'

import {
  Utility
} from '../utility/Utility'

import type {
  Operation,
  Context,
  Control,
} from '../types'


class PlanetEntity {
  #client: SolardemoSDK
  #utility: Utility
  #entopts: any
  #data: any
  #match: any

  _entctx: Context

  constructor(client: SolardemoSDK, entopts: any) {
    // super()
    entopts = entopts || {}
    entopts.active = false !== entopts.active

    this.#client = client
    this.#entopts = entopts
    this.#utility = client.utility()
    this.#data = {}
    this.#match = {}

    const makeContext = this.#utility.makeContext

    this._entctx = makeContext({
      entity: this,
      entopts,
    }, client._rootctx)

    const featureHook = this.#utility.featureHook
    featureHook(this._entctx, 'PostConstructEntity')
  }

  entopts() {
    return { ...this.#entopts }
  }

  client() {
    return this.#client
  }

  make() {
    return new PlanetEntity(this.#client, this.entopts())
  }


  data(this: any, data?: any) {
    const featureHook = this.#utility.featureHook

    if (null != data) {
      featureHook(this._entctx, 'SetData')
      this.#data = { ...data }
    }

    let out = { ...this.#data }

    featureHook(this._entctx, 'GetData')
    return out
  }


  match(match?: any) {
    const featureHook = this.#utility.featureHook

    if (null != match) {
      featureHook(this._entctx, 'SetMatch')
      this.#match = { ...match }
    }

    let out = { ...this.#match }

    featureHook(this._entctx, 'GetMatch')
    return out
  }


  toJSON() {
    return { ...(this.#data || {}), _entity: 'Planet' }
  }

  toString() {
    return 'Planet ' + this.#utility.struct.jsonify(this.#data)
  }

  [inspect.custom]() {
    return this.toString()
  }



  async load(this: any, reqmatch?: any, ctrl?: Control) {

    const utility = this.#utility

    const {
      makeContext,
      makeOperation,
      done,
      error,
      featureHook,
      selection,
      request,
      response,
      result,
      spec,
    } = utility

    let fres: Promise<any> | undefined = undefined

    const op: Operation = makeOperation({
      entity: 'planet',
      name: 'load',
      select: 'match',
      alts: [
        {
          "args": {
            "param": [
              {
                "kind": "param",
                "name": "id",
                "orig": "planet_id",
                "req": true,
                "type": "`$STRING`",
                "active": true
              }
            ]
          },
          "method": "GET",
          "orig": "/api/planet/{planet_id}",
          "parts": [
            "api",
            "planet",
            "{id}"
          ],
          "rename": {
            "param": {
              "planet_id": "id"
            }
          },
          "select": {
            "exist": [
              "id"
            ]
          },
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "relations": []
        }
      ],
    })

    let ctx: Context = makeContext({
      current: new WeakMap(),
      ctrl,
      op,
      match: this.#match,
      data: this.#data,
      reqmatch
    }, this._entctx)

    try {

      fres = featureHook(ctx, 'PreSelection')
      if (fres instanceof Promise) { await fres }

      ctx.out.selected = selection(ctx)
      if (ctx.out.selected instanceof Error) {
        return error(ctx, ctx.out.selected)
      }



      fres = featureHook(ctx, 'PreSpec')
      if (fres instanceof Promise) { await fres }

      ctx.out.spec = spec(ctx)
      if (ctx.out.spec instanceof Error) {
        return error(ctx, ctx.out.spec)
      }



      fres = featureHook(ctx, 'PreRequest')
      if (fres instanceof Promise) { await fres }

      ctx.out.request = await request(ctx)
      if (ctx.out.request instanceof Error) {
        return error(ctx, ctx.out.request)
      }



      fres = featureHook(ctx, 'PreResponse')
      if (fres instanceof Promise) { await fres }

      ctx.out.response = await response(ctx)
      if (ctx.out.response instanceof Error) {
        return error(ctx, ctx.out.response)
      }



      fres = featureHook(ctx, 'PreResult')
      if (fres instanceof Promise) { await fres }

      ctx.out.result = await result(ctx)
      if (ctx.out.result instanceof Error) {
        return error(ctx, ctx.out.result)
      }



      fres = featureHook(ctx, 'PreDone')
      if (fres instanceof Promise) { await fres }

      if (null != ctx.result) {
        if (null != ctx.result.resmatch) {
          this.#match = ctx.result.resmatch
        }

        if (null != ctx.result.resdata) {
          this.#data = ctx.result.resdata
        }
      }

      return done(ctx)
    }
    catch (err: any) {

      fres = featureHook(ctx, 'PreUnexpected')
      if (fres instanceof Promise) { await fres }

      err = this.#unexpected(ctx, err)

      if (err) {
        throw err
      }
      else {
        return undefined
      }
    }
  }



  async list(this: any, reqmatch?: any, ctrl?: Control) {

    const utility = this.#utility

    const {
      makeContext,
      makeOperation,
      done,
      error,
      featureHook,
      selection,
      request,
      response,
      result,
      spec,
    } = utility

    let fres: Promise<any> | undefined = undefined

    let op: Operation = makeOperation({
      entity: 'planet',
      name: 'list',
      select: 'match',
      alts: [
        {
          "method": "GET",
          "orig": "/api/planet",
          "parts": [
            "api",
            "planet"
          ],
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "args": {
            "param": []
          },
          "relations": [],
          "select": {}
        }
      ],
    })

    let ctx: Context = makeContext({
      current: new WeakMap(),
      ctrl,
      op,
      match: this.#match,
      data: this.#data,
      reqmatch
    }, this._entctx)


    try {

      fres = featureHook(ctx, 'PreSelection')
      if (fres instanceof Promise) { await fres }

      ctx.out.selected = selection(ctx)
      if (ctx.out.selected instanceof Error) {
        return error(ctx, ctx.out.selected)
      }



      fres = featureHook(ctx, 'PreSpec')
      if (fres instanceof Promise) { await fres }

      ctx.out.spec = spec(ctx)
      if (ctx.out.spec instanceof Error) {
        return error(ctx, ctx.out.spec)
      }



      fres = featureHook(ctx, 'PreRequest')
      if (fres instanceof Promise) { await fres }

      ctx.out.request = await request(ctx)
      if (ctx.out.request instanceof Error) {
        return error(ctx, ctx.out.request)
      }



      fres = featureHook(ctx, 'PreResponse')
      if (fres instanceof Promise) { await fres }

      ctx.out.response = await response(ctx)
      if (ctx.out.response instanceof Error) {
        return error(ctx, ctx.out.response)
      }



      fres = featureHook(ctx, 'PreResult')
      if (fres instanceof Promise) { await fres }

      ctx.out.result = await result(ctx)
      if (ctx.out.result instanceof Error) {
        return error(ctx, ctx.out.result)
      }


      fres = featureHook(ctx, 'PreDone')
      if (fres instanceof Promise) { await fres }

      if (null != ctx.result) {
        if (null != ctx.result.resmatch) {
          this.#match = ctx.result.resmatch
        }
      }

      return done(ctx)
    }
    catch (err: any) {

      fres = featureHook(ctx, 'PreUnexpected')
      if (fres instanceof Promise) { await fres }

      err = this.#unexpected(ctx, err)

      if (err) {
        throw err
      }
      else {
        return undefined
      }
    }
  }



  async create(this: any, reqdata?: any, ctrl?: Control) {

    const utility = this.#utility
    const {
      makeContext,
      makeOperation,
      done,
      error,
      featureHook,
      selection,
      request,
      response,
      result,
      spec,
    } = utility

    let fres: Promise<any> | undefined = undefined

    let op: Operation = makeOperation({
      entity: 'planet',
      name: 'create',
      select: 'data',
      alts: [
        {
          "args": {
            "param": [
              {
                "kind": "param",
                "name": "id",
                "orig": "planet_id",
                "req": true,
                "type": "`$STRING`",
                "active": true
              }
            ]
          },
          "method": "POST",
          "orig": "/api/planet/{planet_id}/forbid",
          "parts": [
            "api",
            "planet",
            "{id}",
            "forbid"
          ],
          "rename": {
            "param": {
              "planet_id": "id"
            }
          },
          "select": {
            "$action": "forbid",
            "exist": [
              "id"
            ]
          },
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "relations": []
        },
        {
          "args": {
            "param": [
              {
                "kind": "param",
                "name": "id",
                "orig": "planet_id",
                "req": true,
                "type": "`$STRING`",
                "active": true
              }
            ]
          },
          "method": "POST",
          "orig": "/api/planet/{planet_id}/terraform",
          "parts": [
            "api",
            "planet",
            "{id}",
            "terraform"
          ],
          "rename": {
            "param": {
              "planet_id": "id"
            }
          },
          "select": {
            "$action": "terraform",
            "exist": [
              "id"
            ]
          },
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "relations": []
        },
        {
          "method": "POST",
          "orig": "/api/planet",
          "parts": [
            "api",
            "planet"
          ],
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "args": {
            "param": []
          },
          "relations": [],
          "select": {}
        }
      ],
    })

    let ctx: Context = makeContext({
      current: new WeakMap(),
      ctrl,
      op,
      match: this.#match,
      data: this.#data,
      reqdata
    }, this._entctx)


    try {

      fres = featureHook(ctx, 'PreSelection')
      if (fres instanceof Promise) { await fres }

      ctx.out.selected = selection(ctx)
      if (ctx.out.selected instanceof Error) {
        return error(ctx, ctx.out.selected)
      }



      fres = featureHook(ctx, 'PreSpec')
      if (fres instanceof Promise) { await fres }

      ctx.out.spec = spec(ctx)
      if (ctx.out.spec instanceof Error) {
        return error(ctx, ctx.out.spec)
      }



      fres = featureHook(ctx, 'PreRequest')
      if (fres instanceof Promise) { await fres }

      ctx.out.request = await request(ctx)
      if (ctx.out.request instanceof Error) {
        return error(ctx, ctx.out.request)
      }



      fres = featureHook(ctx, 'PreResponse')
      if (fres instanceof Promise) { await fres }

      ctx.out.response = await response(ctx)
      if (ctx.out.response instanceof Error) {
        return error(ctx, ctx.out.response)
      }



      fres = featureHook(ctx, 'PreResult')
      if (fres instanceof Promise) { await fres }

      ctx.out.result = await result(ctx)
      if (ctx.out.result instanceof Error) {
        return error(ctx, ctx.out.result)
      }



      fres = featureHook(ctx, 'PreDone')
      if (fres instanceof Promise) { await fres }

      if (null != ctx.result) {
        if (null != ctx.result.resdata) {
          this.#data = ctx.result.resdata
        }
      }

      return done(ctx)
    }
    catch (err: any) {

      fres = featureHook(ctx, 'PreUnexpected')
      if (fres instanceof Promise) { await fres }

      err = this.#unexpected(ctx, err)

      if (err) {
        throw err
      }
      else {
        return undefined
      }
    }
  }



  async update(this: any, reqdata?: any, ctrl?: Control) {

    const utility = this.#utility

    const {
      makeContext,
      makeOperation,
      done,
      error,
      featureHook,
      selection,
      request,
      response,
      result,
      spec,
    } = utility

    let fres: Promise<any> | undefined = undefined

    let op: Operation = makeOperation({
      entity: 'planet',
      name: 'update',
      select: 'data',
      alts: [
        {
          "args": {
            "param": [
              {
                "kind": "param",
                "name": "id",
                "orig": "planet_id",
                "req": true,
                "type": "`$STRING`",
                "active": true
              }
            ]
          },
          "method": "PUT",
          "orig": "/api/planet/{planet_id}",
          "parts": [
            "api",
            "planet",
            "{id}"
          ],
          "select": {
            "exist": [
              "id"
            ]
          },
          "transform": {
            "req": "`reqdata`",
            "res": "`body`"
          },
          "active": true,
          "relations": []
        }
      ],
    })

    let ctx: Context = makeContext({
      current: new WeakMap(),
      ctrl,
      op,
      match: this.#match,
      data: this.#data,
      reqdata
    }, this._entctx)

    try {


      fres = featureHook(ctx, 'PreSelection')
      if (fres instanceof Promise) { await fres }

      ctx.out.selected = selection(ctx)
      if (ctx.out.selected instanceof Error) {
        return error(ctx, ctx.out.selected)
      }



      fres = featureHook(ctx, 'PreSpec')
      if (fres instanceof Promise) { await fres }

      ctx.out.spec = spec(ctx)
      if (ctx.out.spec instanceof Error) {
        return error(ctx, ctx.out.spec)
      }



      fres = featureHook(ctx, 'PreRequest')
      if (fres instanceof Promise) { await fres }

      ctx.out.request = await request(ctx)
      if (ctx.out.request instanceof Error) {
        return error(ctx, ctx.out.request)
      }



      fres = featureHook(ctx, 'PreResponse')
      if (fres instanceof Promise) { await fres }

      ctx.out.response = await response(ctx)
      if (ctx.out.response instanceof Error) {
        return error(ctx, ctx.out.response)
      }



      fres = featureHook(ctx, 'PreResult')
      if (fres instanceof Promise) { await fres }

      ctx.out.result = await result(ctx)
      if (ctx.out.result instanceof Error) {
        return error(ctx, ctx.out.result)
      }



      fres = featureHook(ctx, 'PreDone')
      if (fres instanceof Promise) { await fres }

      if (null != ctx.result) {
        if (null != ctx.result.resmatch) {
          this.#match = ctx.result.resmatch
        }

        if (null != ctx.result.resdata) {
          this.#data = ctx.result.resdata
        }
      }

      return done(ctx)
    }
    catch (err: any) {

      fres = featureHook(ctx, 'PreUnexpected')
      if (fres instanceof Promise) { await fres }

      err = this.#unexpected(ctx, err)

      if (err) {
        throw err
      }
      else {
        return undefined
      }
    }
  }








  #unexpected(this: any, ctx: Context, err: any) {
    const ctrl = ctx.ctrl

    ctrl.err = err

    if (ctrl.explain) {
      const { clean, struct } = this.#utility
      const { delprop, clone } = struct

      ctx.ctrl.explain = clean(ctx, ctx.ctrl.explain)
      delprop(ctx.ctrl.explain.result, 'err')

      if (null != ctx.result && null != ctx.result.err) {
        ctrl.explain.err = clean(ctx, {
          ...clone({ err: ctx.result.err }).err,
          message: ctx.result.err.message,
          stack: ctx.result.err.stack,
        })
      }

      const cleanerr = clean(ctx, {
        ...clone({ err }).err,
        message: err.message,
        stack: err.stack,
      })

      if (null == ctrl.explain.err) {
        ctrl.explain.err = cleanerr
      }
      else if (ctrl.explain.err.message != cleanerr.message) {
        ctrl.explain.unexpected = cleanerr
      }
    }

    if (false === ctrl.throw) {
      return undefined
    }

    return err
  }

}




export {
  PlanetEntity
}
