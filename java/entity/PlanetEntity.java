package voxgig.solardemosdk.entity;

import java.util.LinkedHashMap;
import java.util.Map;

import voxgig.solardemosdk.core.Context;
import voxgig.solardemosdk.core.Entity;
import voxgig.solardemosdk.core.Helpers;
import voxgig.solardemosdk.core.SdkClient;
import voxgig.solardemosdk.utility.struct.Struct;

/** Planet entity client for the Solardemo SDK. */
@SuppressWarnings({"unchecked", "unused"})
public class PlanetEntity extends EntityBase {

  public PlanetEntity(SdkClient client, Map<String, Object> entopts) {
    super("planet", client, entopts);
  }

  @Override
  public Entity make() {
    Map<String, Object> opts = new LinkedHashMap<>(this.entopts);
    return new PlanetEntity(this.client, opts);
  }


  @Override
  public Object load(Map<String, Object> reqmatch, Map<String, Object> ctrl) {
    Map<String, Object> ctxmap = new LinkedHashMap<>();
    ctxmap.put("opname", "load");
    ctxmap.put("ctrl", ctrl);
    ctxmap.put("match", this.match);
    ctxmap.put("data", this.data);
    ctxmap.put("reqmatch", reqmatch);
    Context ctx = this.utility.makeContext.apply(ctxmap, this.entctx);

    return runOp(ctx, () -> {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) {
          this.match = ctx.result.resmatch;
        }
        if (ctx.result.resdata != null) {
          Map<String, Object> d = Helpers.toMapAny(Struct.clone(ctx.result.resdata));
          this.data = d == null ? new LinkedHashMap<>() : d;
        }
      }
    });
  }




  @Override
  public Object list(Map<String, Object> reqmatch, Map<String, Object> ctrl) {
    Map<String, Object> ctxmap = new LinkedHashMap<>();
    ctxmap.put("opname", "list");
    ctxmap.put("ctrl", ctrl);
    ctxmap.put("match", this.match);
    ctxmap.put("data", this.data);
    ctxmap.put("reqmatch", reqmatch);
    Context ctx = this.utility.makeContext.apply(ctxmap, this.entctx);

    return runOp(ctx, () -> {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) {
          this.match = ctx.result.resmatch;
        }
      }
    });
  }




  @Override
  public Object create(Map<String, Object> reqdata, Map<String, Object> ctrl) {
    Map<String, Object> ctxmap = new LinkedHashMap<>();
    ctxmap.put("opname", "create");
    ctxmap.put("ctrl", ctrl);
    ctxmap.put("match", this.match);
    ctxmap.put("data", this.data);
    ctxmap.put("reqdata", reqdata);
    Context ctx = this.utility.makeContext.apply(ctxmap, this.entctx);

    return runOp(ctx, () -> {
      if (ctx.result != null) {
        if (ctx.result.resdata != null) {
          Map<String, Object> d = Helpers.toMapAny(Struct.clone(ctx.result.resdata));
          this.data = d == null ? new LinkedHashMap<>() : d;
        }
      }
    });
  }




  @Override
  public Object update(Map<String, Object> reqdata, Map<String, Object> ctrl) {
    Map<String, Object> ctxmap = new LinkedHashMap<>();
    ctxmap.put("opname", "update");
    ctxmap.put("ctrl", ctrl);
    ctxmap.put("match", this.match);
    ctxmap.put("data", this.data);
    ctxmap.put("reqdata", reqdata);
    Context ctx = this.utility.makeContext.apply(ctxmap, this.entctx);

    return runOp(ctx, () -> {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) {
          this.match = ctx.result.resmatch;
        }
        if (ctx.result.resdata != null) {
          Map<String, Object> d = Helpers.toMapAny(Struct.clone(ctx.result.resdata));
          this.data = d == null ? new LinkedHashMap<>() : d;
        }
      }
    });
  }




  @Override
  public Object remove(Map<String, Object> reqmatch, Map<String, Object> ctrl) {
    Map<String, Object> ctxmap = new LinkedHashMap<>();
    ctxmap.put("opname", "remove");
    ctxmap.put("ctrl", ctrl);
    ctxmap.put("match", this.match);
    ctxmap.put("data", this.data);
    ctxmap.put("reqmatch", reqmatch);
    Context ctx = this.utility.makeContext.apply(ctxmap, this.entctx);

    return runOp(ctx, () -> {
      if (ctx.result != null) {
        if (ctx.result.resmatch != null) {
          this.match = ctx.result.resmatch;
        }
        if (ctx.result.resdata != null) {
          Map<String, Object> d = Helpers.toMapAny(Struct.clone(ctx.result.resdata));
          this.data = d == null ? new LinkedHashMap<>() : d;
        }
      }
    });
  }


}
