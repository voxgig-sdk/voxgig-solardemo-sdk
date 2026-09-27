package voxgig.voxgigsolardemosdk.utility;

import java.util.LinkedHashMap;
import java.util.Map;

import voxgig.voxgigsolardemosdk.core.Context;
import voxgig.voxgigsolardemosdk.core.Helpers;
import voxgig.voxgigsolardemosdk.utility.struct.Struct;

final class PrepareHeaders {

  private PrepareHeaders() {}

  static Map<String, Object> prepareHeaders(Context ctx) {
    Map<String, Object> options = ctx.client.optionsMap();

    Object headers = Struct.getprop(options, "headers");
    if (headers == null) {
      return new LinkedHashMap<>();
    }

    Map<String, Object> out = Helpers.toMapAny(Struct.clone(headers));
    if (out != null) {
      return out;
    }
    return new LinkedHashMap<>();
  }
}
