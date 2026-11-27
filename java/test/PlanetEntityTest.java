package voxgig.voxgigsolardemosdk.sdktest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;

import voxgig.voxgigsolardemosdk.core.Config;
import voxgig.voxgigsolardemosdk.core.Context;
import voxgig.voxgigsolardemosdk.core.Helpers;
import voxgig.voxgigsolardemosdk.core.SdkEntity;
import voxgig.voxgigsolardemosdk.core.SdkError;
import voxgig.voxgigsolardemosdk.core.VoxgigSolardemoSDK;
import voxgig.voxgigsolardemosdk.feature.BaseFeature;
import voxgig.voxgigsolardemosdk.utility.Json;
import voxgig.voxgigsolardemosdk.utility.struct.Struct;

@SuppressWarnings({"unchecked", "unused"})
public class PlanetEntityTest {

  // main.kit.test.live.strict is true (the default is true): a live
  // request that fails, or a live test missing an input it needs,
  // fails the test.
  // An account with no record for a test to read skips it either way.
  static final boolean LIVE_STRICT = true;

  @Test
  public void instance() {
    VoxgigSolardemoSDK testsdk = VoxgigSolardemoSDK.testSDK();
    SdkEntity ent = testsdk.planet(null);
    assertNotNull(ent, "expected non-null planet entity");
  }

  @Test
  public void basic() {
    RunnerSupport.EntityTestSetup setup = planetBasicSetup(null);
    // Per-op sdk-test-control.json skip — basic test exercises a flow
    // with multiple ops; skipping any op skips the whole flow.
    String mode = setup.live ? "live" : "unit";
    for (String op : new String[] { "create", "list", "update", "load", "remove" }) {
      String reason = RunnerSupport.skipReason("entityOp", "planet." + op, mode);
      Assumptions.assumeTrue(reason == null,
          reason == null || "".equals(reason)
              ? "skipped via sdk-test-control.json" : reason);
    }
    if (setup.live && "TRUE".equals(System.getenv("VOXGIG_GETONLY_GUARD"))) {
      System.out.println("LIVE STEP {\"id\":\"planet.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/forbid\"}");
      System.out.println("LIVE STEP {\"id\":\"planet.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}\"}");
      System.out.println("LIVE STEP {\"id\":\"planet.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}\"}");
      System.out.println("LIVE STEP {\"id\":\"planet.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}");
    VoxgigSolardemoSDK client = setup.client;
    if (setup.live) {
      Object liveId = setup.syntheticOnly ? null : setup.idmap.get("planet01");
      RunnerSupport.livePace();
      RunnerSupport.liveExisting(setup.data, LIVE_STRICT, "planet",
          "id", liveId, () -> {
        Map<String, Object> match = new LinkedHashMap<>();
        return client.planet(null).list(match, null);
      });
    }

    // Bootstrap entity data from existing test data (no create step in flow).
    List<List<Object>> planetRef01DataRaw = Struct.items(Helpers.toMapAny(
        Struct.getpath(setup.data, "existing.planet")));
    Map<String, Object> planetRef01Data = planetRef01DataRaw.isEmpty()
        ? null : Helpers.toMapAny(planetRef01DataRaw.get(0).get(1));

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // LIST
    SdkEntity planetRef01Ent = client.planet(null);
    Map<String, Object> planetRef01Match = new LinkedHashMap<>();

    Object planetRef01ListResult = planetRef01Ent.list(planetRef01Match, null);
    assertTrue(planetRef01ListResult instanceof List,
        "expected list result to be an array, got " + planetRef01ListResult);

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // LOAD
    Map<String, Object> planetRef01MatchDt0 = new LinkedHashMap<>();
    planetRef01MatchDt0.put("id", planetRef01Data.get("id"));
    Object planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null);
    Map<String, Object> planetRef01DataDt0LoadResult = Helpers.toMapAny(planetRef01DataDt0Loaded instanceof SdkEntity ? ((SdkEntity) planetRef01DataDt0Loaded).data() : planetRef01DataDt0Loaded);
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map");
    assertTrue(RunnerSupport.liveSameId(planetRef01DataDt0LoadResult.get("id"), planetRef01Data.get("id")), "expected load result id to match");

      return;
    }

    VoxgigSolardemoSDK client = setup.client;

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // CREATE
    SdkEntity planetRef01Ent = client.planet(null);
    Map<String, Object> planetRef01Data = Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.planet"), "planet_ref01"));

    Object planetRef01DataResult = planetRef01Ent.create(planetRef01Data, null);
    planetRef01Data = Helpers.toMapAny(planetRef01DataResult instanceof SdkEntity ? ((SdkEntity) planetRef01DataResult).data() : planetRef01DataResult);
    assertNotNull(planetRef01Data, "expected create result to be a map");
    assertNotNull(planetRef01Data.get("id"), "expected created entity to have an id");

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // LIST
    Map<String, Object> planetRef01Match = new LinkedHashMap<>();

    Object planetRef01ListResult = planetRef01Ent.list(planetRef01Match, null);
    assertTrue(planetRef01ListResult instanceof List,
        "expected list result to be an array, got " + planetRef01ListResult);
    List<Object> planetRef01List = (List<Object>) planetRef01ListResult;

    List<Object> foundItem = Struct.select(
        RunnerSupport.entityListToData(planetRef01List),
        Struct.jm("id", planetRef01Data.get("id")));
    assertFalse(Struct.isempty(foundItem), "expected to find created entity in list");

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // UPDATE
    Map<String, Object> planetRef01DataUp0Up = new LinkedHashMap<>();
    planetRef01DataUp0Up.put("id", planetRef01Data.get("id"));

    String planetRef01MarkdefUp0Name = "kind";
    String planetRef01MarkdefUp0Value = "Mark01-planet_ref01_" + setup.now;
    planetRef01DataUp0Up.put(planetRef01MarkdefUp0Name, planetRef01MarkdefUp0Value);

    Object planetRef01ResdataUp0Result = planetRef01Ent.update(planetRef01DataUp0Up, null);
    Map<String, Object> planetRef01ResdataUp0 = Helpers.toMapAny(planetRef01ResdataUp0Result instanceof SdkEntity ? ((SdkEntity) planetRef01ResdataUp0Result).data() : planetRef01ResdataUp0Result);
    assertNotNull(planetRef01ResdataUp0, "expected update result to be a map");
    assertTrue(RunnerSupport.liveSameId(planetRef01ResdataUp0.get("id"), planetRef01DataUp0Up.get("id")), "expected update result id to match");
    assertEquals(planetRef01MarkdefUp0Value, planetRef01ResdataUp0.get(planetRef01MarkdefUp0Name),
        "expected " + planetRef01MarkdefUp0Name + " to be updated");

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // LOAD
    Map<String, Object> planetRef01MatchDt0 = new LinkedHashMap<>();
    planetRef01MatchDt0.put("id", planetRef01Data.get("id"));
    Object planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null);
    Map<String, Object> planetRef01DataDt0LoadResult = Helpers.toMapAny(planetRef01DataDt0Loaded instanceof SdkEntity ? ((SdkEntity) planetRef01DataDt0Loaded).data() : planetRef01DataDt0Loaded);
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map");
    assertTrue(RunnerSupport.liveSameId(planetRef01DataDt0LoadResult.get("id"), planetRef01Data.get("id")), "expected load result id to match");

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // REMOVE
    Map<String, Object> planetRef01MatchRm0 = new LinkedHashMap<>();
    planetRef01MatchRm0.put("id", planetRef01Data.get("id"));
    planetRef01Ent.remove(planetRef01MatchRm0, null);

    if (setup.live) {
      RunnerSupport.livePace();
    }
    // LIST
    Map<String, Object> planetRef01MatchRt0 = new LinkedHashMap<>();

    Object planetRef01ListRt0Result = planetRef01Ent.list(planetRef01MatchRt0, null);
    assertTrue(planetRef01ListRt0Result instanceof List,
        "expected list result to be an array, got " + planetRef01ListRt0Result);
    List<Object> planetRef01ListRt0 = (List<Object>) planetRef01ListRt0Result;

    List<Object> notFoundItem = Struct.select(
        RunnerSupport.entityListToData(planetRef01ListRt0),
        Struct.jm("id", planetRef01Data.get("id")));
    assertTrue(Struct.isempty(notFoundItem), "expected removed entity to not be in list");

  }

  @Test
  public void stream() {
    Map<String, Object> streamingActive = new LinkedHashMap<>();
    Map<String, Object> streamingOpts = new LinkedHashMap<>();
    streamingOpts.put("active", true);
    Map<String, Object> featureOpts = new LinkedHashMap<>();
    featureOpts.put("streaming", streamingOpts);
    streamingActive.put("feature", featureOpts);

    RunnerSupport.EntityTestSetup setup = planetBasicSetup(streamingActive);
    Assumptions.assumeFalse(setup.live,
        "stream test streams the seeded fixture data (unit mode only)");

    SdkEntity ent = setup.client.planet(null);
    Map<String, Object> match = new LinkedHashMap<>();

    // Materialised list result for the same op.
    Object listedResult = ent.list(match, null);
    List<Object> listed = listedResult instanceof List
        ? (List<Object>) listedResult : new ArrayList<>();

    // stream("list") yields items via the streaming feature's iterator.
    List<Object> streamed = ent.stream("list", match, null)
        .collect(Collectors.toList());
    assertTrue(streamed.size() > 0, "expected stream to yield items");
    assertEquals(listed.size(), streamed.size(),
        "expected stream to yield the same item count as list");

    // Fallback: with streaming inactive, stream still yields the
    // materialised items.
    RunnerSupport.EntityTestSetup setup2 = planetBasicSetup(null);
    SdkEntity ent2 = setup2.client.planet(null);
    List<Object> streamed2 = ent2.stream("list", match, null)
        .collect(Collectors.toList());
    assertEquals(listed.size(), streamed2.size(),
        "expected fallback stream to yield the materialised items");
  }

  static boolean hasFeature(String name) {
    Map<String, Object> fm = Helpers.toMapAny(Config.makeConfig().get("feature"));
    return fm != null && fm.get(name) != null;
  }

  public static final class FailHook extends BaseFeature {
    int unexpected = 0;

    FailHook() {
      super("failhook", "0.0.1", true);
    }

    @Override
    public void preSpec(Context ctx) {
      throw new RuntimeException("planet hook failed");
    }

    @Override
    public void preUnexpected(Context ctx) {
      this.unexpected++;
    }
  }

  @Test
  public void streamError() {
    Map<String, Object> offline = Struct.jm("net", Struct.jm("offline", true));
    RuntimeException err = assertThrows(RuntimeException.class, () ->
        VoxgigSolardemoSDK.testSDK(offline, null).planet(null).stream("list", null, null)
            .collect(Collectors.toList()));
    assertTrue(err.getMessage().contains("offline"), err.getMessage());

    VoxgigSolardemoSDK.testSDK(offline, null).planet(null)
        .stream("list", null, Struct.jm("ctrl", Struct.jm("throw", false)))
        .collect(Collectors.toList());

    if (hasFeature("rbac")) {
      VoxgigSolardemoSDK denied = VoxgigSolardemoSDK.testSDK(null,
          Struct.jm("feature", Struct.jm("rbac", Struct.jm("active", true, "deny", true))));
      SdkError denyerr = assertThrows(SdkError.class, () ->
          denied.planet(null).stream("list", null, null).collect(Collectors.toList()));
      assertEquals("rbac_denied", denyerr.code);
    }
  }

  @Test
  public void streamCtrl() {
    Map<String, Object> explain = new LinkedHashMap<>();
    Map<String, Object> ctrl = new LinkedHashMap<>();
    ctrl.put("explain", explain);
    VoxgigSolardemoSDK.testSDK().planet(null).stream("list", null, Struct.jm("ctrl", ctrl))
        .collect(Collectors.toList());
    assertEquals(List.of("explain"), new ArrayList<>(ctrl.keySet()));
    assertTrue(explain == ctrl.get("explain") && !explain.isEmpty());
  }

  @Test
  public void unexpected() {
    FailHook hook = new FailHook();
    VoxgigSolardemoSDK client = new VoxgigSolardemoSDK(Struct.jm(
        "feature", Struct.jm("test", Struct.jm("active", true)),
        "extend", Struct.jt(hook)));

    RuntimeException err = assertThrows(RuntimeException.class, () ->
        client.planet(null).list(null, null));
    assertTrue(err.getMessage().contains("hook failed"), err.getMessage());
    assertTrue(0 < hook.unexpected);

    int fired = hook.unexpected;
    client.planet(null).list(null, Struct.jm("throw", false));
    assertTrue(fired < hook.unexpected);
  }

  @Test
  public void validate() {
    Assumptions.assumeTrue(hasFeature("validate"), "feature not present in this SDK: validate");
    VoxgigSolardemoSDK client = VoxgigSolardemoSDK.testSDK(null,
        Struct.jm("feature", Struct.jm("validate", Struct.jm("active", true))));
    SdkError err = assertThrows(SdkError.class, () ->
        client.planet(null).list(Struct.jm("diameter", "x"), null));
    assertEquals("validate_failed", err.code);
  }

  static RunnerSupport.EntityTestSetup planetBasicSetup(Map<String, Object> extra) {
    RunnerSupport.loadEnvLocal();

    Map<String, Object> entityData;
    try {
      String entityDataSource = Files.readString(Path.of(
          "..", ".sdk", "test", "entity", "planet", "PlanetTestData.json"));
      entityData = Helpers.toMapAny(Json.parse(entityDataSource));
    }
    catch (Exception e) {
      throw new AssertionError("failed to read planet test data: " + e.getMessage(), e);
    }

    Map<String, Object> options = new LinkedHashMap<>();
    options.put("entity", entityData.get("existing"));

    VoxgigSolardemoSDK client = VoxgigSolardemoSDK.testSDK(options, extra);

    // Generate idmap via transform, matching TS pattern.
    List<Object> idnames = new ArrayList<>();
    idnames.add("planet01");
    idnames.add("planet02");
    idnames.add("planet03");
    Object idmap = Struct.transform(idnames, Json.parse(
        "{\"`$PACK`\": [\"\", {"
        + "\"`$KEY`\": \"`$COPY`\","
        + "\"`$VAL`\": [\"`$FORMAT`\", \"upper\", \"`$COPY`\"]"
        + "}]}"));

    // Whether *_ENTID supplied the idmap, read before envOverride consumes
    // it: without it, the ids a live flow binds are the fixture's synthetic ones.
    String entidEnvRaw = RunnerSupport.getenv("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID");
    boolean idmapOverridden = entidEnvRaw != null
        && entidEnvRaw.trim().startsWith("{");

    Map<String, Object> envm = new LinkedHashMap<>();
    envm.put("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID", idmap);
    envm.put("VOXGIG_SOLARDEMO_TEST_LIVE", "FALSE");
    envm.put("VOXGIG_SOLARDEMO_TEST_EXPLAIN", "FALSE");
    Map<String, Object> env = RunnerSupport.envOverride(envm);

    Map<String, Object> idmapResolved = Helpers.toMapAny(env.get("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"));
    if (idmapResolved == null) {
      idmapResolved = Helpers.toMapAny(idmap);
    }

    boolean live = "TRUE".equals(env.get("VOXGIG_SOLARDEMO_TEST_LIVE"));
    if (live) {
      // sdk-test-control.json's test.client.options seeds the live
      // client; the generated fields below overwrite anything they name.
      Map<String, Object> liveOpts =
          new LinkedHashMap<>(RunnerSupport.liveClientOptions());
      // An empty map, not a null one: merge answers null when its last
      // entry is null, and basicSetup is normally called with no extras -
      // so a bare null silently discarded the apikey and server values
      // above.
      Map<String, Object> extraOpts =
          extra == null ? new LinkedHashMap<>() : extra;
      Object mergedOpts = Struct.merge(Struct.jt(liveOpts, extraOpts));
      client = new VoxgigSolardemoSDK(Helpers.toMapAny(mergedOpts));
    }

    RunnerSupport.EntityTestSetup setup = new RunnerSupport.EntityTestSetup();
    setup.client = client;
    setup.data = entityData;
    setup.idmap = idmapResolved;
    setup.env = env;
    setup.explain = "TRUE".equals(env.get("VOXGIG_SOLARDEMO_TEST_EXPLAIN"));
    setup.live = live;
    setup.syntheticOnly = live && !idmapOverridden;
    setup.now = System.currentTimeMillis();
    return setup;
  }
}
