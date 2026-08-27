package voxgig.solardemosdk.entity

import java.util.{LinkedHashMap, List => JList, Map => JMap}
import voxgig.solardemosdk.core.{Context, Entity, Helpers, SdkClient}
import voxgig.solardemosdk.utility.struct.Struct

// Planet entity client for the Solardemo SDK.
class PlanetEntity(client0: SdkClient, entopts0: JMap[String, Object]) extends EntityBase("planet", client0, entopts0) {

  override def make(): Entity = {
    val opts = new LinkedHashMap[String, Object](this.entopts)
    new PlanetEntity(this.client, opts)
  }


  override def load(reqmatch: JMap[String, Object], ctrl: JMap[String, Object]): Object = {
    val ctxmap = new LinkedHashMap[String, Object]()
    ctxmap.put("opname", "load")
    ctxmap.put("ctrl", ctrl)
    ctxmap.put("match", this.matchState)
    ctxmap.put("data", this.dataState)
    ctxmap.put("reqmatch", reqmatch)
    val ctx = this.utility.makeContext(ctxmap, this.entctx)

    runOp(ctx, () => {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) this.matchState = ctx.result.resmatch
        if (ctx.result.resdata != null) {
          val d = Helpers.toMapAny(Struct.clone(ctx.result.resdata))
          this.dataState = if (d == null) new LinkedHashMap[String, Object]() else d
        }
      }
    })
  }




  override def list(reqmatch: JMap[String, Object], ctrl: JMap[String, Object]): Object = {
    val ctxmap = new LinkedHashMap[String, Object]()
    ctxmap.put("opname", "list")
    ctxmap.put("ctrl", ctrl)
    ctxmap.put("match", this.matchState)
    ctxmap.put("data", this.dataState)
    ctxmap.put("reqmatch", reqmatch)
    val ctx = this.utility.makeContext(ctxmap, this.entctx)

    runOp(ctx, () => {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) this.matchState = ctx.result.resmatch
      }
    })
  }




  override def create(reqdata: JMap[String, Object], ctrl: JMap[String, Object]): Object = {
    val ctxmap = new LinkedHashMap[String, Object]()
    ctxmap.put("opname", "create")
    ctxmap.put("ctrl", ctrl)
    ctxmap.put("match", this.matchState)
    ctxmap.put("data", this.dataState)
    ctxmap.put("reqdata", reqdata)
    val ctx = this.utility.makeContext(ctxmap, this.entctx)

    runOp(ctx, () => {
      if (ctx.result != null) {
        if (ctx.result.resdata != null) {
          val d = Helpers.toMapAny(Struct.clone(ctx.result.resdata))
          this.dataState = if (d == null) new LinkedHashMap[String, Object]() else d
        }
      }
    })
  }




  override def update(reqdata: JMap[String, Object], ctrl: JMap[String, Object]): Object = {
    val ctxmap = new LinkedHashMap[String, Object]()
    ctxmap.put("opname", "update")
    ctxmap.put("ctrl", ctrl)
    ctxmap.put("match", this.matchState)
    ctxmap.put("data", this.dataState)
    ctxmap.put("reqdata", reqdata)
    val ctx = this.utility.makeContext(ctxmap, this.entctx)

    runOp(ctx, () => {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) this.matchState = ctx.result.resmatch
        if (ctx.result.resdata != null) {
          val d = Helpers.toMapAny(Struct.clone(ctx.result.resdata))
          this.dataState = if (d == null) new LinkedHashMap[String, Object]() else d
        }
      }
    })
  }




  override def remove(reqmatch: JMap[String, Object], ctrl: JMap[String, Object]): Object = {
    val ctxmap = new LinkedHashMap[String, Object]()
    ctxmap.put("opname", "remove")
    ctxmap.put("ctrl", ctrl)
    ctxmap.put("match", this.matchState)
    ctxmap.put("data", this.dataState)
    ctxmap.put("reqmatch", reqmatch)
    val ctx = this.utility.makeContext(ctxmap, this.entctx)

    runOp(ctx, () => {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) this.matchState = ctx.result.resmatch
        if (ctx.result.resdata != null) {
          val d = Helpers.toMapAny(Struct.clone(ctx.result.resdata))
          this.dataState = if (d == null) new LinkedHashMap[String, Object]() else d
        }
      }
    })
  }


}
