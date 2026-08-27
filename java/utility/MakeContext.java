package voxgig.solardemosdk.utility;

import java.util.Map;

import voxgig.solardemosdk.core.Context;

final class MakeContext {

  private MakeContext() {}

  static Context makeContext(Map<String, Object> ctxmap, Context basectx) {
    return new Context(ctxmap, basectx);
  }
}
