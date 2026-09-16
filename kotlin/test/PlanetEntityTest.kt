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
class PlanetEntityTest {

  @Test
  fun instance() {
    val testsdk = SolardemoSDK.testSDK()
    val ent = testsdk.planet(null)
    assertNotNull(ent, "expected non-null planet entity")
  }

  @Test
  fun basic() {
    val setup = planetBasicSetup(null)
    // Per-op sdk-test-control.json skip.
    val mode = if (setup.live) "live" else "unit"
    for (op in arrayOf<String>("create", "list", "update", "load", "remove")) {
      val reason = RunnerSupport.skipReason("entityOp", "planet.$op", mode)
      Assumptions.assumeTrue(
        reason == null,
        if (reason == null || "" == reason) "skipped via sdk-test-control.json" else reason,
      )
    }
    Assumptions.assumeFalse(
      setup.syntheticOnly,
      "live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live",
    )
    val client = setup.client

    // CREATE
    val planetRef01Ent = client.planet(null)
    var planetRef01Data: MutableMap<String, Any?> = (Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.planet"), "planet_ref01")) ?: linkedMapOf())

    val planetRef01DataResult = planetRef01Ent.create(planetRef01Data, null)
    planetRef01Data = Helpers.toMapAny(if (planetRef01DataResult is SdkEntity) planetRef01DataResult.data() else planetRef01DataResult) ?: linkedMapOf()
    assertNotNull(planetRef01Data, "expected create result to be a map")
    assertNotNull(planetRef01Data["id"], "expected created entity to have an id")

    // LIST
    val planetRef01Match = linkedMapOf<String, Any?>()

    val planetRef01ListResult = planetRef01Ent.list(planetRef01Match, null)
    assertTrue(planetRef01ListResult is List<*>,
        "expected list result to be an array, got " + planetRef01ListResult)
    val planetRef01List = planetRef01ListResult as List<Any?>

    val foundItem = Struct.select(
        RunnerSupport.entityListToData(planetRef01List),
        Struct.jm("id", planetRef01Data["id"]))
    assertFalse(Struct.isempty(foundItem), "expected to find created entity in list")

    // UPDATE
    val planetRef01DataUp0Up = linkedMapOf<String, Any?>()
    planetRef01DataUp0Up["id"] = planetRef01Data["id"]

    val planetRef01MarkdefUp0Name = "kind"
    val planetRef01MarkdefUp0Value = "Mark01-planet_ref01_" + setup.now
    planetRef01DataUp0Up[planetRef01MarkdefUp0Name] = planetRef01MarkdefUp0Value

    val planetRef01ResdataUp0Result = planetRef01Ent.update(planetRef01DataUp0Up, null)
    val planetRef01ResdataUp0 = Helpers.toMapAny(if (planetRef01ResdataUp0Result is SdkEntity) planetRef01ResdataUp0Result.data() else planetRef01ResdataUp0Result) ?: linkedMapOf()
    assertNotNull(planetRef01ResdataUp0, "expected update result to be a map")
    assertEquals(planetRef01DataUp0Up["id"], planetRef01ResdataUp0["id"],
        "expected update result id to match")
    assertEquals(planetRef01MarkdefUp0Value, planetRef01ResdataUp0[planetRef01MarkdefUp0Name],
        "expected " + planetRef01MarkdefUp0Name + " to be updated")

    // LOAD
    val planetRef01MatchDt0 = linkedMapOf<String, Any?>()
    planetRef01MatchDt0["id"] = planetRef01Data["id"]
    val planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null)
    val planetRef01DataDt0LoadResult = Helpers.toMapAny(if (planetRef01DataDt0Loaded is SdkEntity) planetRef01DataDt0Loaded.data() else planetRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map")
    assertEquals(planetRef01Data["id"], planetRef01DataDt0LoadResult["id"],
        "expected load result id to match")

    // REMOVE
    val planetRef01MatchRm0 = linkedMapOf<String, Any?>()
    planetRef01MatchRm0["id"] = planetRef01Data["id"]
    planetRef01Ent.remove(planetRef01MatchRm0, null)

    // LIST
    val planetRef01MatchRt0 = linkedMapOf<String, Any?>()

    val planetRef01ListRt0Result = planetRef01Ent.list(planetRef01MatchRt0, null)
    assertTrue(planetRef01ListRt0Result is List<*>,
        "expected list result to be an array, got " + planetRef01ListRt0Result)
    val planetRef01ListRt0 = planetRef01ListRt0Result as List<Any?>

    val notFoundItem = Struct.select(
        RunnerSupport.entityListToData(planetRef01ListRt0),
        Struct.jm("id", planetRef01Data["id"]))
    assertTrue(Struct.isempty(notFoundItem), "expected removed entity to not be in list")

  }

  @Test
  fun stream() {
    val streamingActive = linkedMapOf<String, Any?>(
      "feature" to linkedMapOf<String, Any?>(
        "streaming" to linkedMapOf<String, Any?>("active" to true),
      ),
    )
    val setup = planetBasicSetup(streamingActive)
    Assumptions.assumeFalse(
      setup.live,
      "stream test streams the seeded fixture data (unit mode only)",
    )

    val ent = setup.client.planet(null)
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
    val setup2 = planetBasicSetup(null)
    val ent2 = setup2.client.planet(null)
    val streamed2 = ent2.stream("list", match, null).toList()
    assertEquals(listed.size, streamed2.size, "expected fallback stream to match list")
  }

  companion object {
    fun planetBasicSetup(extra: MutableMap<String, Any?>?): RunnerSupport.EntityTestSetup {
      RunnerSupport.loadEnvLocal()

      val entityData: MutableMap<String, Any?>
      try {
        val entityDataSource = Files.readString(Paths.get(
            "..", ".sdk", "test", "entity", "planet", "PlanetTestData.json"))
        entityData = Helpers.toMapAny(Json.parse(entityDataSource)) ?: linkedMapOf()
      } catch (e: Exception) {
        throw AssertionError("failed to read planet test data: " + e.message, e)
      }

      val options = linkedMapOf<String, Any?>()
      options["entity"] = entityData["existing"]

      var client = SolardemoSDK.testSDK(options, extra)

      // Generate idmap via transform, matching TS pattern.
      val idnames = mutableListOf<Any?>()
      idnames.add("planet01")
      idnames.add("planet02")
      idnames.add("planet03")
      val idmap = Struct.transform(idnames, Json.parse(
          "{\"`\$PACK`\": [\"\", {" +
          "\"`\$KEY`\": \"`\$COPY`\"," +
          "\"`\$VAL`\": [\"`\$FORMAT`\", \"upper\", \"`\$COPY`\"]" +
          "}]}"))

      // Detect ENTID env override before envOverride consumes it.
      val entidEnvRaw = RunnerSupport.getenv("SOLARDEMO_TEST_PLANET_ENTID")
      val idmapOverridden = entidEnvRaw != null && entidEnvRaw.trim().startsWith("{")

      val envm = linkedMapOf<String, Any?>()
      envm["SOLARDEMO_TEST_PLANET_ENTID"] = idmap
      envm["SOLARDEMO_TEST_LIVE"] = "FALSE"
      envm["SOLARDEMO_TEST_EXPLAIN"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      var idmapResolved = Helpers.toMapAny(env["SOLARDEMO_TEST_PLANET_ENTID"])
      if (idmapResolved == null) {
        idmapResolved = Helpers.toMapAny(idmap) ?: linkedMapOf()
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
