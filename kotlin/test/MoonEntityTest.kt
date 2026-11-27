package voxgig.voxgigsolardemosdk.sdktest

import java.nio.file.Files
import java.nio.file.Paths

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Assumptions
import org.junit.jupiter.api.Test

import voxgig.voxgigsolardemosdk.core.Config
import voxgig.voxgigsolardemosdk.core.Context
import voxgig.voxgigsolardemosdk.core.Helpers
import voxgig.voxgigsolardemosdk.core.SdkEntity
import voxgig.voxgigsolardemosdk.core.SdkError
import voxgig.voxgigsolardemosdk.core.VoxgigSolardemoSDK
import voxgig.voxgigsolardemosdk.feature.BaseFeature
import voxgig.voxgigsolardemosdk.utility.Json
import voxgig.voxgigsolardemosdk.utility.struct.Struct

@Suppress("UNCHECKED_CAST", "UNUSED_VARIABLE", "UNUSED_VALUE")
class MoonEntityTest {

  // main.kit.test.live.strict is true (the default is true): a live
  // request that fails, or a live test missing an input it needs,
  // fails the test.
  // An account with no record for a test to read skips it either way.
  private val LIVE_STRICT = true

  @Test
  fun instance() {
    val testsdk = VoxgigSolardemoSDK.testSDK()
    val ent = testsdk.moon(null)
    assertNotNull(ent, "expected non-null moon entity")
  }

  @Test
  fun basic() {
    val setup = moonBasicSetup(null)
    // Per-op sdk-test-control.json skip.
    val mode = if (setup.live) "live" else "unit"
    for (op in arrayOf<String>("create", "list", "update", "load", "remove")) {
      val reason = RunnerSupport.skipReason("entityOp", "moon.$op", mode)
      Assumptions.assumeTrue(
        reason == null,
        if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
      )
    }
    if (setup.live && "TRUE" == System.getenv("VOXGIG_GETONLY_GUARD")) {
      println("LIVE STEP {\"id\":\"moon.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/moon\"}")
      println("LIVE STEP {\"id\":\"moon.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}/moon/{moon_id}\"}")
      println("LIVE STEP {\"id\":\"moon.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}/moon/{moon_id}\"}")
      println("LIVE STEP {\"id\":\"moon.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}")
    if (setup.live) {
      for (liveKey in arrayOf<String>("planet01")) {
        if (setup.syntheticOnly || setup.idmap?.get(liveKey) == null) {
          RunnerSupport.liveMiss(LIVE_STRICT, "Live entity test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        }
      }
    }
    val client = setup.client
    if (setup.live) {
      val liveId: Any? = if (setup.syntheticOnly) null else setup.idmap?.get("moon01")
      RunnerSupport.livePace()
      RunnerSupport.liveExisting(setup.data!!, LIVE_STRICT, "moon",
        "id", liveId) {
        client.moon(null).list(linkedMapOf<String, Any?>("planet_id" to setup.idmap?.get("planet01")), null)
      }
    }

    // Bootstrap entity data from existing test data (no create step in flow).
    val moonRef01DataRaw = Struct.items(Helpers.toMapAny(
        Struct.getpath(setup.data, "existing.moon")))
    val moonRef01Data: MutableMap<String, Any?> = if (moonRef01DataRaw.isEmpty())
        linkedMapOf() else (Helpers.toMapAny(moonRef01DataRaw[0][1]) ?: linkedMapOf())

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LIST
    val moonRef01Ent = client.moon(null)
    val moonRef01Match = linkedMapOf<String, Any?>()
    moonRef01Match["planet_id"] = setup.idmap!!["planet01"]

    val moonRef01ListResult = moonRef01Ent.list(moonRef01Match, null)
    assertTrue(moonRef01ListResult is List<*>,
        "expected list result to be an array, got " + moonRef01ListResult)

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LOAD
    val moonRef01MatchDt0 = linkedMapOf<String, Any?>()
    moonRef01MatchDt0["id"] = moonRef01Data["id"]
    moonRef01MatchDt0["planet_id"] = moonRef01Data["planet_id"].let { if (it is String || it is Number || it is Boolean) it else setup.idmap?.get("planet_id") ?: setup.idmap?.get("planet01") }
    val moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null)
    val moonRef01DataDt0LoadResult = Helpers.toMapAny(if (moonRef01DataDt0Loaded is SdkEntity) moonRef01DataDt0Loaded.data() else moonRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(moonRef01DataDt0LoadResult, "expected load result to be a map")
    assertTrue(RunnerSupport.liveSameId(moonRef01DataDt0LoadResult["id"], moonRef01Data["id"]), "expected load result id to match")

      return
    }

    if (setup.live) {
      for (liveKey in arrayOf<String>("planet01")) {
        if (setup.syntheticOnly || setup.idmap?.get(liveKey) == null) {
          RunnerSupport.liveMiss(LIVE_STRICT, "Live entity test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        }
      }
    }
    val client = setup.client

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // CREATE
    val moonRef01Ent = client.moon(null)
    var moonRef01Data: MutableMap<String, Any?> = (Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.moon"), "moon_ref01")) ?: linkedMapOf())
    moonRef01Data["planet_id"] = setup.idmap!!["planet01"]

    val moonRef01DataResult = moonRef01Ent.create(moonRef01Data, null)
    moonRef01Data = Helpers.toMapAny(if (moonRef01DataResult is SdkEntity) moonRef01DataResult.data() else moonRef01DataResult) ?: linkedMapOf()
    assertNotNull(moonRef01Data, "expected create result to be a map")
    assertNotNull(moonRef01Data["id"], "expected created entity to have an id")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LIST
    val moonRef01Match = linkedMapOf<String, Any?>()
    moonRef01Match["planet_id"] = setup.idmap!!["planet01"]

    val moonRef01ListResult = moonRef01Ent.list(moonRef01Match, null)
    assertTrue(moonRef01ListResult is List<*>,
        "expected list result to be an array, got " + moonRef01ListResult)
    val moonRef01List = moonRef01ListResult as List<Any?>

    val foundItem = Struct.select(
        RunnerSupport.entityListToData(moonRef01List),
        Struct.jm("id", moonRef01Data["id"]))
    assertFalse(Struct.isempty(foundItem), "expected to find created entity in list")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // UPDATE
    val moonRef01DataUp0Up = linkedMapOf<String, Any?>()
    moonRef01DataUp0Up["id"] = moonRef01Data["id"]
    moonRef01DataUp0Up["planet_id"] = setup.idmap!!["planet_id"]

    val moonRef01MarkdefUp0Name = "kind"
    val moonRef01MarkdefUp0Value = "Mark01-moon_ref01_" + setup.now
    moonRef01DataUp0Up[moonRef01MarkdefUp0Name] = moonRef01MarkdefUp0Value

    val moonRef01ResdataUp0Result = moonRef01Ent.update(moonRef01DataUp0Up, null)
    val moonRef01ResdataUp0 = Helpers.toMapAny(if (moonRef01ResdataUp0Result is SdkEntity) moonRef01ResdataUp0Result.data() else moonRef01ResdataUp0Result) ?: linkedMapOf()
    assertNotNull(moonRef01ResdataUp0, "expected update result to be a map")
    assertTrue(RunnerSupport.liveSameId(moonRef01ResdataUp0["id"], moonRef01DataUp0Up["id"]), "expected update result id to match")
    assertEquals(moonRef01MarkdefUp0Value, moonRef01ResdataUp0[moonRef01MarkdefUp0Name],
        "expected " + moonRef01MarkdefUp0Name + " to be updated")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LOAD
    val moonRef01MatchDt0 = linkedMapOf<String, Any?>()
    moonRef01MatchDt0["id"] = moonRef01Data["id"]
    moonRef01MatchDt0["planet_id"] = moonRef01Data["planet_id"].let { if (it is String || it is Number || it is Boolean) it else setup.idmap?.get("planet_id") ?: setup.idmap?.get("planet01") }
    val moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null)
    val moonRef01DataDt0LoadResult = Helpers.toMapAny(if (moonRef01DataDt0Loaded is SdkEntity) moonRef01DataDt0Loaded.data() else moonRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(moonRef01DataDt0LoadResult, "expected load result to be a map")
    assertTrue(RunnerSupport.liveSameId(moonRef01DataDt0LoadResult["id"], moonRef01Data["id"]), "expected load result id to match")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // REMOVE
    val moonRef01MatchRm0 = linkedMapOf<String, Any?>()
    moonRef01MatchRm0["id"] = moonRef01Data["id"]
    moonRef01MatchRm0["planet_id"] = setup.idmap?.get("planet_id") ?: setup.idmap?.get("planet01")
    moonRef01Ent.remove(moonRef01MatchRm0, null)

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LIST
    val moonRef01MatchRt0 = linkedMapOf<String, Any?>()
    moonRef01MatchRt0["planet_id"] = setup.idmap!!["planet01"]

    val moonRef01ListRt0Result = moonRef01Ent.list(moonRef01MatchRt0, null)
    assertTrue(moonRef01ListRt0Result is List<*>,
        "expected list result to be an array, got " + moonRef01ListRt0Result)
    val moonRef01ListRt0 = moonRef01ListRt0Result as List<Any?>

    val notFoundItem = Struct.select(
        RunnerSupport.entityListToData(moonRef01ListRt0),
        Struct.jm("id", moonRef01Data["id"]))
    assertTrue(Struct.isempty(notFoundItem), "expected removed entity to not be in list")

  }

  private fun hasFeature(name: String): Boolean {
    val fm = Helpers.toMapAny(Config.sharedConfig()["feature"])
    return fm != null && fm[name] != null
  }

  @Test
  fun validate() {
    Assumptions.assumeTrue(hasFeature("validate"), "feature not present in this SDK: validate")
    val client = VoxgigSolardemoSDK.testSDK(null, linkedMapOf<String, Any?>(
      "feature" to linkedMapOf<String, Any?>(
        "validate" to linkedMapOf<String, Any?>("active" to true))))
    val err = assertThrows(SdkError::class.java) {
      client.moon(null).list(linkedMapOf<String, Any?>("planet_id" to 1), null)
    }
    assertEquals("validate_failed", err.code)
  }

  companion object {
    fun moonBasicSetup(extra: MutableMap<String, Any?>?): RunnerSupport.EntityTestSetup {
      RunnerSupport.loadEnvLocal()

      val entityData: MutableMap<String, Any?>
      try {
        val entityDataSource = Files.readString(Paths.get(
            "..", ".sdk", "test", "entity", "moon", "MoonTestData.json"))
        entityData = Helpers.toMapAny(Json.parse(entityDataSource)) ?: linkedMapOf()
      } catch (e: Exception) {
        throw AssertionError("failed to read moon test data: " + e.message, e)
      }

      val options = linkedMapOf<String, Any?>()
      options["entity"] = entityData["existing"]

      var client = VoxgigSolardemoSDK.testSDK(options, extra)

      // Generate idmap via transform, matching TS pattern.
      val idnames = mutableListOf<Any?>()
      idnames.add("moon01")
      idnames.add("moon02")
      idnames.add("moon03")
      idnames.add("planet01")
      idnames.add("planet02")
      idnames.add("planet03")
      val idmap = Struct.transform(idnames, Json.parse(
          "{\"`\$PACK`\": [\"\", {" +
          "\"`\$KEY`\": \"`\$COPY`\"," +
          "\"`\$VAL`\": [\"`\$FORMAT`\", \"upper\", \"`\$COPY`\"]" +
          "}]}"))

      // Whether *_ENTID supplied the idmap, read before envOverride consumes it.
      val entidEnvRaw = RunnerSupport.getenv("VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
      val idmapOverridden = entidEnvRaw != null && entidEnvRaw.trim().startsWith("{")

      val envm = linkedMapOf<String, Any?>()
      envm["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"] = idmap
      envm["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE"
      envm["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      var idmapResolved = Helpers.toMapAny(env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"])
      if (idmapResolved == null) {
        idmapResolved = Helpers.toMapAny(idmap) ?: linkedMapOf()
      }
      // Add planet_id alias for update test.
      if (idmapResolved["planet_id"] == null) {
        idmapResolved["planet_id"] = idmapResolved["planet01"]
      }

      val live = "TRUE" == env["VOXGIG_SOLARDEMO_TEST_LIVE"]
      if (live) {
        // sdk-test-control.json's test.client.options seeds the live
        // client; the generated fields below overwrite anything they name.
        val liveOpts = RunnerSupport.liveClientOptions()
        // An empty map, not null: merge answers null when its last entry is null.
        val mergedOpts = Struct.merge(Struct.jt(liveOpts, extra ?: linkedMapOf<String, Any?>()))
        client = VoxgigSolardemoSDK(Helpers.toMapAny(mergedOpts))
      }

      val setup = RunnerSupport.EntityTestSetup()
      setup.client = client
      setup.data = entityData
      setup.idmap = idmapResolved
      setup.env = env
      setup.explain = "TRUE" == env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"]
      setup.live = live
      setup.syntheticOnly = live && !idmapOverridden
      setup.now = System.currentTimeMillis()
      return setup
    }
  }
}
