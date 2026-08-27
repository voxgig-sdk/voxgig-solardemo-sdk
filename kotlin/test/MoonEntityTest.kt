package voxgig.solardemosdk.sdktest

import java.nio.file.Files
import java.nio.file.Paths

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Assumptions
import org.junit.jupiter.api.Test

import voxgig.solardemosdk.core.Helpers
import voxgig.solardemosdk.core.SdkEntity
import voxgig.solardemosdk.core.SolardemoSDK
import voxgig.solardemosdk.utility.Json
import voxgig.solardemosdk.utility.struct.Struct

@Suppress("UNCHECKED_CAST", "UNUSED_VARIABLE", "UNUSED_VALUE")
class MoonEntityTest {

  @Test
  fun instance() {
    val testsdk = SolardemoSDK.testSDK()
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
    Assumptions.assumeFalse(
      setup.syntheticOnly,
      "live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_MOON_ENTID JSON to run live",
    )
    val client = setup.client

    // CREATE
    val moonRef01Ent = client.moon(null)
    var moonRef01Data: MutableMap<String, Any?> = (Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.moon"), "moon_ref01")) ?: linkedMapOf())
    moonRef01Data["planet_id"] = setup.idmap!!["planet01"]

    val moonRef01DataResult = moonRef01Ent.create(moonRef01Data, null)
    moonRef01Data = Helpers.toMapAny(if (moonRef01DataResult is SdkEntity) moonRef01DataResult.data() else moonRef01DataResult) ?: linkedMapOf()
    assertNotNull(moonRef01Data, "expected create result to be a map")
    assertNotNull(moonRef01Data["id"], "expected created entity to have an id")

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
    assertEquals(moonRef01DataUp0Up["id"], moonRef01ResdataUp0["id"],
        "expected update result id to match")
    assertEquals(moonRef01MarkdefUp0Value, moonRef01ResdataUp0[moonRef01MarkdefUp0Name],
        "expected " + moonRef01MarkdefUp0Name + " to be updated")

    // LOAD
    val moonRef01MatchDt0 = linkedMapOf<String, Any?>()
    moonRef01MatchDt0["id"] = moonRef01Data["id"]
    val moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null)
    val moonRef01DataDt0LoadResult = Helpers.toMapAny(if (moonRef01DataDt0Loaded is SdkEntity) moonRef01DataDt0Loaded.data() else moonRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(moonRef01DataDt0LoadResult, "expected load result to be a map")
    assertEquals(moonRef01Data["id"], moonRef01DataDt0LoadResult["id"],
        "expected load result id to match")

    // REMOVE
    val moonRef01MatchRm0 = linkedMapOf<String, Any?>()
    moonRef01MatchRm0["id"] = moonRef01Data["id"]
    moonRef01Ent.remove(moonRef01MatchRm0, null)

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

  @Test
  fun stream() {
    val streamingActive = linkedMapOf<String, Any?>(
      "feature" to linkedMapOf<String, Any?>(
        "streaming" to linkedMapOf<String, Any?>("active" to true),
      ),
    )
    val setup = moonBasicSetup(streamingActive)
    Assumptions.assumeFalse(
      setup.live,
      "stream test streams the seeded fixture data (unit mode only)",
    )

    val ent = setup.client.moon(null)
    val match = linkedMapOf<String, Any?>()

    // Materialised list result for the same op.
    val listedResult = ent.list(match, null)
    val listed = (listedResult as? List<Any?>) ?: emptyList<Any?>()

    // stream("list") yields items via the streaming feature's iterator.
    val streamed = ent.stream("list", match, null).toList()
    assertTrue(streamed.size > 0, "expected stream to yield items")
    assertEquals(listed.size, streamed.size, "expected stream to match list count")

    // Fallback: with streaming inactive, stream still yields the materialised
    // items.
    val setup2 = moonBasicSetup(null)
    val ent2 = setup2.client.moon(null)
    val streamed2 = ent2.stream("list", match, null).toList()
    assertEquals(listed.size, streamed2.size, "expected fallback stream to match list")
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

      var client = SolardemoSDK.testSDK(options, extra)

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

      // Detect ENTID env override before envOverride consumes it.
      val entidEnvRaw = RunnerSupport.getenv("SOLARDEMO_TEST_MOON_ENTID")
      val idmapOverridden = entidEnvRaw != null && entidEnvRaw.trim().startsWith("{")

      val envm = linkedMapOf<String, Any?>()
      envm["SOLARDEMO_TEST_MOON_ENTID"] = idmap
      envm["SOLARDEMO_TEST_LIVE"] = "FALSE"
      envm["SOLARDEMO_TEST_EXPLAIN"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      var idmapResolved = Helpers.toMapAny(env["SOLARDEMO_TEST_MOON_ENTID"])
      if (idmapResolved == null) {
        idmapResolved = Helpers.toMapAny(idmap) ?: linkedMapOf()
      }
      // Add planet_id alias for update test.
      if (idmapResolved["planet_id"] == null) {
        idmapResolved["planet_id"] = idmapResolved["planet01"]
      }

      val live = "TRUE" == env["SOLARDEMO_TEST_LIVE"]
      if (live) {
        val liveOpts = linkedMapOf<String, Any?>()
        val mergedOpts = Struct.merge(Struct.jt(liveOpts, extra))
        client = SolardemoSDK(Helpers.toMapAny(mergedOpts))
      }

      val setup = RunnerSupport.EntityTestSetup()
      setup.client = client
      setup.data = entityData
      setup.idmap = idmapResolved
      setup.env = env
      setup.explain = "TRUE" == env["SOLARDEMO_TEST_EXPLAIN"]
      setup.live = live
      setup.syntheticOnly = live && !idmapOverridden
      setup.now = System.currentTimeMillis()
      return setup
    }
  }
}
