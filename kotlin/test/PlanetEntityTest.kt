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
class PlanetEntityTest {

  // main.kit.test.live.strict is true (the default is true): a live
  // request that fails, or a live test missing an input it needs,
  // fails the test.
  // An account with no record for a test to read skips it either way.
  private val LIVE_STRICT = true

  @Test
  fun instance() {
    val testsdk = VoxgigSolardemoSDK.testSDK()
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
    if (setup.live && "TRUE" == System.getenv("VOXGIG_GETONLY_GUARD")) {
      println("LIVE STEP {\"id\":\"planet.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/forbid\"}")
      println("LIVE STEP {\"id\":\"planet.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}\"}")
      println("LIVE STEP {\"id\":\"planet.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}\"}")
      println("LIVE STEP {\"id\":\"planet.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}")
    val client = setup.client
    if (setup.live) {
      val liveId: Any? = if (setup.syntheticOnly) null else setup.idmap?.get("planet01")
      RunnerSupport.livePace()
      RunnerSupport.liveExisting(setup.data!!, LIVE_STRICT, "planet",
        "id", liveId) {
        client.planet(null).list(linkedMapOf<String, Any?>(), null)
      }
    }

    // Bootstrap entity data from existing test data (no create step in flow).
    val planetRef01DataRaw = Struct.items(Helpers.toMapAny(
        Struct.getpath(setup.data, "existing.planet")))
    val planetRef01Data: MutableMap<String, Any?> = if (planetRef01DataRaw.isEmpty())
        linkedMapOf() else (Helpers.toMapAny(planetRef01DataRaw[0][1]) ?: linkedMapOf())

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LIST
    val planetRef01Ent = client.planet(null)
    val planetRef01Match = linkedMapOf<String, Any?>()

    val planetRef01ListResult = planetRef01Ent.list(planetRef01Match, null)
    assertTrue(planetRef01ListResult is List<*>,
        "expected list result to be an array, got " + planetRef01ListResult)

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LOAD
    val planetRef01MatchDt0 = linkedMapOf<String, Any?>()
    planetRef01MatchDt0["id"] = planetRef01Data["id"]
    val planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null)
    val planetRef01DataDt0LoadResult = Helpers.toMapAny(if (planetRef01DataDt0Loaded is SdkEntity) planetRef01DataDt0Loaded.data() else planetRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map")
    assertTrue(RunnerSupport.liveSameId(planetRef01DataDt0LoadResult["id"], planetRef01Data["id"]), "expected load result id to match")

      return
    }

    val client = setup.client

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // CREATE
    val planetRef01Ent = client.planet(null)
    var planetRef01Data: MutableMap<String, Any?> = (Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.planet"), "planet_ref01")) ?: linkedMapOf())

    val planetRef01DataResult = planetRef01Ent.create(planetRef01Data, null)
    planetRef01Data = Helpers.toMapAny(if (planetRef01DataResult is SdkEntity) planetRef01DataResult.data() else planetRef01DataResult) ?: linkedMapOf()
    assertNotNull(planetRef01Data, "expected create result to be a map")
    assertNotNull(planetRef01Data["id"], "expected created entity to have an id")

    if (setup.live) {
      RunnerSupport.livePace()
    }
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

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // UPDATE
    val planetRef01DataUp0Up = linkedMapOf<String, Any?>()
    planetRef01DataUp0Up["id"] = planetRef01Data["id"]

    val planetRef01MarkdefUp0Name = "kind"
    val planetRef01MarkdefUp0Value = "Mark01-planet_ref01_" + setup.now
    planetRef01DataUp0Up[planetRef01MarkdefUp0Name] = planetRef01MarkdefUp0Value

    val planetRef01ResdataUp0Result = planetRef01Ent.update(planetRef01DataUp0Up, null)
    val planetRef01ResdataUp0 = Helpers.toMapAny(if (planetRef01ResdataUp0Result is SdkEntity) planetRef01ResdataUp0Result.data() else planetRef01ResdataUp0Result) ?: linkedMapOf()
    assertNotNull(planetRef01ResdataUp0, "expected update result to be a map")
    assertTrue(RunnerSupport.liveSameId(planetRef01ResdataUp0["id"], planetRef01DataUp0Up["id"]), "expected update result id to match")
    assertEquals(planetRef01MarkdefUp0Value, planetRef01ResdataUp0[planetRef01MarkdefUp0Name],
        "expected " + planetRef01MarkdefUp0Name + " to be updated")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // LOAD
    val planetRef01MatchDt0 = linkedMapOf<String, Any?>()
    planetRef01MatchDt0["id"] = planetRef01Data["id"]
    val planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null)
    val planetRef01DataDt0LoadResult = Helpers.toMapAny(if (planetRef01DataDt0Loaded is SdkEntity) planetRef01DataDt0Loaded.data() else planetRef01DataDt0Loaded) ?: linkedMapOf()
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map")
    assertTrue(RunnerSupport.liveSameId(planetRef01DataDt0LoadResult["id"], planetRef01Data["id"]), "expected load result id to match")

    if (setup.live) {
      RunnerSupport.livePace()
    }
    // REMOVE
    val planetRef01MatchRm0 = linkedMapOf<String, Any?>()
    planetRef01MatchRm0["id"] = planetRef01Data["id"]
    planetRef01Ent.remove(planetRef01MatchRm0, null)

    if (setup.live) {
      RunnerSupport.livePace()
    }
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

  private fun hasFeature(name: String): Boolean {
    val fm = Helpers.toMapAny(Config.sharedConfig()["feature"])
    return fm != null && fm[name] != null
  }

  class FailHook : BaseFeature("failhook", "0.0.1", true) {
    var unexpected = 0
    override fun preSpec(ctx: Context) { throw RuntimeException("planet hook failed") }
    override fun preUnexpected(ctx: Context) { unexpected++ }
  }

  @Test
  fun streamError() {
    val offline = linkedMapOf<String, Any?>("net" to linkedMapOf<String, Any?>("offline" to true))
    val err = assertThrows(RuntimeException::class.java) {
      VoxgigSolardemoSDK.testSDK(offline, null).planet(null).stream("list", null, null).toList()
    }
    assertTrue(err.message.orEmpty().contains("offline"), err.message)

    VoxgigSolardemoSDK.testSDK(offline, null).planet(null).stream("list", null,
      linkedMapOf<String, Any?>("ctrl" to linkedMapOf<String, Any?>("throw" to false))).toList()

    if (hasFeature("rbac")) {
      val denied = VoxgigSolardemoSDK.testSDK(null, linkedMapOf<String, Any?>(
        "feature" to linkedMapOf<String, Any?>(
          "rbac" to linkedMapOf<String, Any?>("active" to true, "deny" to true))))
      val denyerr = assertThrows(SdkError::class.java) {
        denied.planet(null).stream("list", null, null).toList()
      }
      assertEquals("rbac_denied", denyerr.code)
    }
  }

  @Test
  fun streamCtrl() {
    val explain = linkedMapOf<String, Any?>()
    val ctrl = linkedMapOf<String, Any?>("explain" to explain)
    VoxgigSolardemoSDK.testSDK().planet(null).stream("list", null,
      linkedMapOf<String, Any?>("ctrl" to ctrl)).toList()
    assertEquals(listOf("explain"), ctrl.keys.toList())
    assertTrue(explain === ctrl["explain"] && explain.isNotEmpty())
  }

  @Test
  fun unexpected() {
    val hook = FailHook()
    val client = VoxgigSolardemoSDK(linkedMapOf<String, Any?>(
      "feature" to linkedMapOf<String, Any?>("test" to linkedMapOf<String, Any?>("active" to true)),
      "extend" to mutableListOf<Any?>(hook)))

    val err = assertThrows(RuntimeException::class.java) {
      client.planet(null).list(null, null)
    }
    assertTrue(err.message.orEmpty().contains("hook failed"), err.message)
    assertTrue(0 < hook.unexpected)

    val fired = hook.unexpected
    client.planet(null).list(null, linkedMapOf<String, Any?>("throw" to false))
    assertTrue(fired < hook.unexpected)
  }

  @Test
  fun validate() {
    Assumptions.assumeTrue(hasFeature("validate"), "feature not present in this SDK: validate")
    val client = VoxgigSolardemoSDK.testSDK(null, linkedMapOf<String, Any?>(
      "feature" to linkedMapOf<String, Any?>(
        "validate" to linkedMapOf<String, Any?>("active" to true))))
    val err = assertThrows(SdkError::class.java) {
      client.planet(null).list(linkedMapOf<String, Any?>("diameter" to "x"), null)
    }
    assertEquals("validate_failed", err.code)
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

      var client = VoxgigSolardemoSDK.testSDK(options, extra)

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

      // Whether *_ENTID supplied the idmap, read before envOverride consumes it.
      val entidEnvRaw = RunnerSupport.getenv("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID")
      val idmapOverridden = entidEnvRaw != null && entidEnvRaw.trim().startsWith("{")

      val envm = linkedMapOf<String, Any?>()
      envm["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"] = idmap
      envm["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE"
      envm["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] = "FALSE"
      val env = RunnerSupport.envOverride(envm)

      var idmapResolved = Helpers.toMapAny(env["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"])
      if (idmapResolved == null) {
        idmapResolved = Helpers.toMapAny(idmap) ?: linkedMapOf()
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
