package voxgig.solardemosdk.utility;

import java.util.LinkedHashMap;
import java.util.Map;

import voxgig.solardemosdk.core.Context;
import voxgig.solardemosdk.core.Helpers;
import voxgig.solardemosdk.core.Response;
import voxgig.solardemosdk.core.Result;

final class ResultHeaders {

  private ResultHeaders() {}

  static Result resultHeaders(Context ctx) {
    Response response = ctx.response;
    Result result = ctx.result;

    if (result != null) {
      if (response != null && response.headers != null) {
        Map<String, Object> hm = Helpers.toMapAny(response.headers);
        if (hm != null) {
          result.headers = hm;
        }
        else {
          result.headers = new LinkedHashMap<>();
        }
      }
      else {
        result.headers = new LinkedHashMap<>();
      }
    }

    return result;
  }
}
