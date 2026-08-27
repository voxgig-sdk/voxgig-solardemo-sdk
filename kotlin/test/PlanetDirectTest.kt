package voxgig.solardemosdk.sdktest

import java.util.function.BiFunction
import java.util.function.Supplier

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Assumptions
import org.junit.jupiter.api.Test

import voxgig.solardemosdk.core.Helpers
import voxgig.solardemosdk.core.SolardemoSDK
import voxgig.solardemosdk.utility.Json

@Suppress("UNCHECKED_CAST", "UNUSED_VARIABLE")
class PlanetDirectTest {

  @Test
  fun directListPlanet() {
    val mockres = mutableListOf<Any?>()
    mockres.add(jm("id", "direct01"))
    mockres.add(jm("id", "direct02"))
    val setup = directSetup(mockres)
    val mode = if (setup.live) "live" else "unit"
    val reason = RunnerSupport.skipReason("direct", "direct-list-planet", mode)
    Assumptions.assumeTrue(
      reason == null,
      if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
    )
    val client = setup.client


    val result = client.direct(jm(
        "path", "api/planet",
        "method", "GET",
        "params", linkedMapOf<String, Any?>()))
    if (setup.live) {
      Assumptions.assumeTrue(result["ok"] == true,
          "list call not ok (likely synthetic IDs against live API): " + result)
      val status = Helpers.toInt(result["status"])
      Assumptions.assumeTrue(status in 200..299, "expected 2xx status, got " + result["status"])
    } else {
      assertEquals(true, result["ok"], "expected ok to be true")
      assertEquals(200, Helpers.toInt(result["status"]), "expected status 200")
    }

    if (!setup.live) {
      assertTrue(result["data"] is List<*>,
          "expected data to be an array, got " + result["data"])
      assertEquals(2, (result["data"] as List<Any?>).size, "expected 2 items")

      assertEquals(1, setup.calls.size, "expected 1 call")
    }
  }

  @Test
  fun directLoadPlanet() {
    val setup = directSetup(jm("id", "direct01"))
    val mode = if (setup.live) "live" else "unit"
    val reason = RunnerSupport.skipReason("direct", "direct-load-planet", mode)
    Assumptions.assumeTrue(
      reason == null,
      if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
    )
    val client = setup.client

    val params = linkedMapOf<String, Any?>()
    val query = linkedMapOf<String, Any?>()
    if (setup.live) {
      val listParams = linkedMapOf<String, Any?>()
      val listResult = client.direct(jm(
          "path", "api/planet",
          "method", "GET",
          "params", listParams))
      Assumptions.assumeTrue(listResult["ok"] == true,
          "list call not ok (likely synthetic IDs against live API): " + listResult)

      val listData = if (listResult["data"] is List<*>) listResult["data"] as List<Any?> else mutableListOf<Any?>()
      Assumptions.assumeTrue(listData.isNotEmpty(), "no entities to load in live mode")
      val firstEnt = Helpers.toMapAny(listData[0]) ?: linkedMapOf()
      params["id"] = firstEnt["id"]
    } else {
      params["id"] = "direct01"
    }

    val result = client.direct(jm(
        "path", "api/planet/{id}",
        "method", "GET",
        "params", params,
        "query", query))
    if (setup.live) {
      Assumptions.assumeTrue(result["ok"] == true,
          "load call not ok (likely synthetic IDs against live API): " + result)
      val status = Helpers.toInt(result["status"])
      Assumptions.assumeTrue(status in 200..299, "expected 2xx status, got " + result["status"])
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
      lateinit var client: SolardemoSDK
      var calls: MutableList<MutableMap<String, Any?>> = mutableListOf()
      var live: Boolean = false
      var idmap: MutableMap<String, Any?> = linkedMapOf()
    }

    fun directSetup(mockres: Any?): DirectSetup {
      RunnerSupport.loadEnvLocal()

      val calls = mutableListOf<MutableMap<String, Any?>>()

      val envm = linkedMapOf<String, Any?>()
      envm["SOLARDEMO_TEST_PLANET_ENTID"] = linkedMapOf<String, Any?>()
      envm["SOLARDEMO_TEST_LIVE"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      val live = "TRUE" == env["SOLARDEMO_TEST_LIVE"]

      val setup = DirectSetup()
      setup.calls = calls

      if (live) {
        val mergedOpts = linkedMapOf<String, Any?>()
        setup.client = SolardemoSDK(mergedOpts)
        setup.live = true

        var idmap: MutableMap<String, Any?> = linkedMapOf()
        val entidRaw = env["SOLARDEMO_TEST_PLANET_ENTID"]
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

      setup.client = SolardemoSDK(jm(
          "base", "http://localhost:8080",
          "system", jm("fetch", mockFetch)))
      setup.live = false
      setup.idmap = linkedMapOf()
      return setup
    }
  }
}
