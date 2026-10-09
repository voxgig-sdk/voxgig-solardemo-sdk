package voxgig.voxgigsolardemosdk.sdktest

import java.util.function.BiFunction
import java.util.function.Supplier

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Assumptions
import org.junit.jupiter.api.Test

import voxgig.voxgigsolardemosdk.core.Helpers
import voxgig.voxgigsolardemosdk.core.VoxgigSolardemoSDK
import voxgig.voxgigsolardemosdk.utility.Json

@Suppress("UNCHECKED_CAST", "UNUSED_VARIABLE")
class MoonDirectTest {

  // main.kit.test.live.strict is true (the default is true): a live
  // request that fails, or a live test missing an input it needs,
  // fails the test.
  // An account with no record for a test to read skips it either way.
  private val LIVE_STRICT = true

  private fun liveOk(result: Map<String, Any?>): Boolean {
    val status = Helpers.toInt(result["status"])
    return result["err"] == null && result["ok"] == true && status in 200..299
  }

  @Test
  fun directListMoon() {
    val mockres = mutableListOf<Any?>()
    mockres.add(jm("id", "direct01"))
    mockres.add(jm("id", "direct02"))
    val setup = directSetup(mockres)
    val mode = if (setup.live) "live" else "unit"
    val reason = RunnerSupport.skipReason("direct", "direct-list-moon", mode)
    Assumptions.assumeTrue(
      reason == null,
      if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
    )
    if (setup.live) {
      for (liveKey in arrayOf<String>("planet01")) {
        if (setup.idmap[liveKey] == null) {
          RunnerSupport.liveMiss(LIVE_STRICT, "Live test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        }
      }
    }
    val client = setup.client

    val params = linkedMapOf<String, Any?>()
    if (setup.live) {
      params["planet_id"] = setup.idmap["planet01"]
    } else {
      params["planet_id"] = "direct01"
    }

    val result = client.direct(jm(
        "path", "api/planet/{planet_id}/moon",
        "method", "GET",
        "params", params))
    if (setup.live) {
      if (!liveOk(result)) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live list failed: " + RunnerSupport.liveDescribe(result))
      }
      if (RunnerSupport.liveList(result["data"]) == null) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live list returned no list: " + RunnerSupport.liveDescribe(result))
      }
    } else {
      assertEquals(true, result["ok"], "expected ok to be true")
      assertEquals(200, Helpers.toInt(result["status"]), "expected status 200")
    }

    if (!setup.live) {
      assertTrue(result["data"] is List<*>,
          "expected data to be an array, got " + result["data"])
      assertEquals(2, (result["data"] as List<Any?>).size, "expected 2 items")

      assertEquals(1, setup.calls.size, "expected 1 call")
      val call = setup.calls[0]
      val initMap = Helpers.toMapAny(call["init"])
      if (initMap != null) {
        assertEquals("GET", initMap["method"], "expected method GET")
      }
      val url = if (call["url"] is String) call["url"] as String else ""
      assertTrue(url.contains("direct01"),
          "expected url to contain direct01, got " + url)
    }
  }

  @Test
  fun directLoadMoon() {
    val setup = directSetup(jm("id", "direct01"))
    val mode = if (setup.live) "live" else "unit"
    val reason = RunnerSupport.skipReason("direct", "direct-load-moon", mode)
    Assumptions.assumeTrue(
      reason == null,
      if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
    )
    if (setup.live) {
      for (liveKey in arrayOf<String>("planet01")) {
        if (setup.idmap[liveKey] == null) {
          RunnerSupport.liveMiss(LIVE_STRICT, "Live test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        }
      }
    }
    val client = setup.client

    val params = linkedMapOf<String, Any?>()
    val query = linkedMapOf<String, Any?>()
    if (setup.live) {
      val listParams = linkedMapOf<String, Any?>()
      listParams["planet_id"] = setup.idmap["planet01"]
      val listResult = client.direct(jm(
          "path", "api/planet/{planet_id}/moon",
          "method", "GET",
          "params", listParams))
      if (!liveOk(listResult)) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live list discovery failed: " + RunnerSupport.liveDescribe(listResult))
      }
      val listData = RunnerSupport.liveList(listResult["data"])
      if (listData == null) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live list discovery returned no list: " + RunnerSupport.liveDescribe(listResult))
      }
      if (listData!!.isEmpty()) {
        RunnerSupport.liveEmpty("The account has no moon record to load")
      }
      val firstEnt = Helpers.toMapAny(listData[0]) ?: linkedMapOf()
      if (firstEnt["id"] == null) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live load blocked: discovery returned no usable identity")
      }
      params["id"] = firstEnt["id"]
      params["planet_id"] = setup.idmap["planet01"]
    } else {
      params["id"] = "direct01"
      params["planet_id"] = "direct02"
    }

    val result = client.direct(jm(
        "path", "api/planet/{planet_id}/moon/{id}",
        "method", "GET",
        "params", params,
        "query", query))
    if (setup.live) {
      if (!liveOk(result)) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live load failed: " + RunnerSupport.liveDescribe(result))
      }
      if (result["data"] == null) {
        RunnerSupport.liveMiss(LIVE_STRICT, "Live load returned no data: " + RunnerSupport.liveDescribe(result))
      }
    } else {
      assertEquals(true, result["ok"], "expected ok to be true")
      assertEquals(200, Helpers.toInt(result["status"]), "expected status 200")
      assertNotNull(result["data"], "expected data to be non-null")
    }

    if (!setup.live) {
      val dataMap = Helpers.toMapAny(result["data"])
      if (dataMap != null) {
        assertEquals("direct01", dataMap["id"], "expected data.id to be direct01")
      }

      assertEquals(1, setup.calls.size, "expected 1 call")
      val call = setup.calls[0]
      val initMap = Helpers.toMapAny(call["init"])
      if (initMap != null) {
        assertEquals("GET", initMap["method"], "expected method GET")
      }
      val url = if (call["url"] is String) call["url"] as String else ""
      assertTrue(url.contains("direct01"),
          "expected url to contain direct01, got " + url)
      assertTrue(url.contains("direct02"),
          "expected url to contain direct02, got " + url)
    }
  }

  companion object {
    fun jm(vararg kv: Any?): MutableMap<String, Any?> {
      val out = linkedMapOf<String, Any?>()
      var i = 0
      while (i < kv.size - 1) {
        out[kv[i].toString()] = kv[i + 1]
        i += 2
      }
      return out
    }

    class DirectSetup {
      lateinit var client: VoxgigSolardemoSDK
      var calls: MutableList<MutableMap<String, Any?>> = mutableListOf()
      var live: Boolean = false
      var idmap: MutableMap<String, Any?> = linkedMapOf()
    }

    fun directSetup(mockres: Any?): DirectSetup {
      RunnerSupport.loadEnvLocal()

      val calls = mutableListOf<MutableMap<String, Any?>>()

      val envm = linkedMapOf<String, Any?>()
      envm["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"] = linkedMapOf<String, Any?>()
      envm["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      val live = "TRUE" == env["VOXGIG_SOLARDEMO_TEST_LIVE"]

      val setup = DirectSetup()
      setup.calls = calls

      if (live) {
        val mergedOpts = linkedMapOf<String, Any?>()
        setup.client = VoxgigSolardemoSDK(mergedOpts)
        setup.live = true

        var idmap: MutableMap<String, Any?> = linkedMapOf()
        val entidRaw = env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"]
        if (entidRaw is String && entidRaw.startsWith("{")) {
          val parsed = Helpers.toMapAny(Json.parseOrNull(entidRaw))
          if (parsed != null) {
            idmap = parsed
          }
        } else if (entidRaw is MutableMap<*, *>) {
          idmap = entidRaw as MutableMap<String, Any?>
        }
        setup.idmap = idmap
        return setup
      }

      val mockdata: Any? = mockres ?: jm("id", "direct01")
      val mockFetch = BiFunction<String, MutableMap<String, Any?>, MutableMap<String, Any?>> { url, init ->
        calls.add(jm("url", url, "init", init))
        jm(
            "status", 200,
            "statusText", "OK",
            "headers", linkedMapOf<String, Any?>(),
            "json", Supplier<Any?> { mockdata })
      }

      setup.client = VoxgigSolardemoSDK(jm(
          "base", "http://localhost:8080",
          "system", jm("fetch", mockFetch)))
      setup.live = false
      setup.idmap = linkedMapOf()
      return setup
    }
  }
}
