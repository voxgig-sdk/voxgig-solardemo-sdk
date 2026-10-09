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
public class MoonEntityTest {

  // main.kit.test.live.strict is true (the default is true): a live
  // request that fails, or a live test missing an input it needs,
  // fails the test.
  // An account with no record for a test to read skips it either way.
  static final boolean LIVE_STRICT = true;

  @Test
  public void instance() {
    VoxgigSolardemoSDK testsdk = VoxgigSolardemoSDK.testSDK();
    SdkEntity ent = testsdk.moon(null);
    assertNotNull(ent, "expected non-null moon entity");
  }

  @Test
  public void basic() {
    RunnerSupport.EntityTestSetup setup = moonBasicSetup(null);
    // Per-op sdk-test-control.json skip — basic test exercises a flow
    // with multiple ops; skipping any op skips the whole flow.
    String mode = setup.live ? "live" : "unit";
    for (String op : new String[] { "create", "list", "update", "load", "remove" }) {
      String reason = RunnerSupport.skipReason("entityOp", "moon." + op, mode);
      Assumptions.assumeTrue(reason == null,
          reason == null || "".equals(reason)
              ? "skipped via sdk-test-control.json" : reason);
    }
    if (setup.live) {
      for (String liveKey : new String[] { "planet01" }) {
        if (setup.syntheticOnly || setup.idmap.get(liveKey) == null) {
          RunnerSupport.liveMiss(LIVE_STRICT, "Live entity test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID");
        }
      }
    }
    VoxgigSolardemoSDK client = setup.client;

    // CREATE
    SdkEntity moonRef01Ent = client.moon(null);
    Map<String, Object> moonRef01Data = Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.moon"), "moon_ref01"));
    moonRef01Data.put("planet_id", setup.idmap.get("planet01"));

    Object moonRef01DataResult = moonRef01Ent.create(moonRef01Data, null);
    moonRef01Data = Helpers.toMapAny(moonRef01DataResult instanceof SdkEntity ? ((SdkEntity) moonRef01DataResult).data() : moonRef01DataResult);
    assertNotNull(moonRef01Data, "expected create result to be a map");
    assertNotNull(moonRef01Data.get("id"), "expected created entity to have an id");

    // LIST
    Map<String, Object> moonRef01Match = new LinkedHashMap<>();
    moonRef01Match.put("planet_id", setup.idmap.get("planet01"));

    Object moonRef01ListResult = moonRef01Ent.list(moonRef01Match, null);
    assertTrue(moonRef01ListResult instanceof List,
        "expected list result to be an array, got " + moonRef01ListResult);
    List<Object> moonRef01List = (List<Object>) moonRef01ListResult;

    List<Object> foundItem = Struct.select(
        RunnerSupport.entityListToData(moonRef01List),
        Struct.jm("id", moonRef01Data.get("id")));
    assertFalse(Struct.isempty(foundItem), "expected to find created entity in list");

    // UPDATE
    Map<String, Object> moonRef01DataUp0Up = new LinkedHashMap<>();
    moonRef01DataUp0Up.put("id", moonRef01Data.get("id"));
    moonRef01DataUp0Up.put("planet_id", setup.idmap.get("planet_id"));

    String moonRef01MarkdefUp0Name = "kind";
    String moonRef01MarkdefUp0Value = "Mark01-moon_ref01_" + setup.now;
    moonRef01DataUp0Up.put(moonRef01MarkdefUp0Name, moonRef01MarkdefUp0Value);

    Object moonRef01ResdataUp0Result = moonRef01Ent.update(moonRef01DataUp0Up, null);
    Map<String, Object> moonRef01ResdataUp0 = Helpers.toMapAny(moonRef01ResdataUp0Result instanceof SdkEntity ? ((SdkEntity) moonRef01ResdataUp0Result).data() : moonRef01ResdataUp0Result);
    assertNotNull(moonRef01ResdataUp0, "expected update result to be a map");
    assertEquals(moonRef01DataUp0Up.get("id"), moonRef01ResdataUp0.get("id"),
        "expected update result id to match");
    assertEquals(moonRef01MarkdefUp0Value, moonRef01ResdataUp0.get(moonRef01MarkdefUp0Name),
        "expected " + moonRef01MarkdefUp0Name + " to be updated");

    // LOAD
    Map<String, Object> moonRef01MatchDt0 = new LinkedHashMap<>();
    moonRef01MatchDt0.put("id", moonRef01Data.get("id"));
    moonRef01MatchDt0.put("planet_id", null != setup.idmap.get("planet_id")
        ? setup.idmap.get("planet_id") : setup.idmap.get("planet01"));
    Object moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null);
    Map<String, Object> moonRef01DataDt0LoadResult = Helpers.toMapAny(moonRef01DataDt0Loaded instanceof SdkEntity ? ((SdkEntity) moonRef01DataDt0Loaded).data() : moonRef01DataDt0Loaded);
    assertNotNull(moonRef01DataDt0LoadResult, "expected load result to be a map");
    assertEquals(moonRef01Data.get("id"), moonRef01DataDt0LoadResult.get("id"),
        "expected load result id to match");

    // REMOVE
    Map<String, Object> moonRef01MatchRm0 = new LinkedHashMap<>();
    moonRef01MatchRm0.put("id", moonRef01Data.get("id"));
    moonRef01MatchRm0.put("planet_id", null != setup.idmap.get("planet_id")
        ? setup.idmap.get("planet_id") : setup.idmap.get("planet01"));
    moonRef01Ent.remove(moonRef01MatchRm0, null);

    // LIST
    Map<String, Object> moonRef01MatchRt0 = new LinkedHashMap<>();
    moonRef01MatchRt0.put("planet_id", setup.idmap.get("planet01"));

    Object moonRef01ListRt0Result = moonRef01Ent.list(moonRef01MatchRt0, null);
    assertTrue(moonRef01ListRt0Result instanceof List,
        "expected list result to be an array, got " + moonRef01ListRt0Result);
    List<Object> moonRef01ListRt0 = (List<Object>) moonRef01ListRt0Result;

    List<Object> notFoundItem = Struct.select(
        RunnerSupport.entityListToData(moonRef01ListRt0),
        Struct.jm("id", moonRef01Data.get("id")));
    assertTrue(Struct.isempty(notFoundItem), "expected removed entity to not be in list");

  }

  static boolean hasFeature(String name) {
    Map<String, Object> fm = Helpers.toMapAny(Config.makeConfig().get("feature"));
    return fm != null && fm.get(name) != null;
  }

  @Test
  public void validate() {
    Assumptions.assumeTrue(hasFeature("validate"), "feature not present in this SDK: validate");
    VoxgigSolardemoSDK client = VoxgigSolardemoSDK.testSDK(null,
        Struct.jm("feature", Struct.jm("validate", Struct.jm("active", true))));
    SdkError err = assertThrows(SdkError.class, () ->
        client.moon(null).list(Struct.jm("planet_id", 1), null));
    assertEquals("validate_failed", err.code);
  }

  static RunnerSupport.EntityTestSetup moonBasicSetup(Map<String, Object> extra) {
    RunnerSupport.loadEnvLocal();

    Map<String, Object> entityData;
    try {
      String entityDataSource = Files.readString(Path.of(
          "..", ".sdk", "test", "entity", "moon", "MoonTestData.json"));
      entityData = Helpers.toMapAny(Json.parse(entityDataSource));
    }
    catch (Exception e) {
      throw new AssertionError("failed to read moon test data: " + e.getMessage(), e);
    }

    Map<String, Object> options = new LinkedHashMap<>();
    options.put("entity", entityData.get("existing"));

    VoxgigSolardemoSDK client = VoxgigSolardemoSDK.testSDK(options, extra);

    // Generate idmap via transform, matching TS pattern.
    List<Object> idnames = new ArrayList<>();
    idnames.add("moon01");
    idnames.add("moon02");
    idnames.add("moon03");
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
    String entidEnvRaw = RunnerSupport.getenv("VOXGIG_SOLARDEMO_TEST_MOON_ENTID");
    boolean idmapOverridden = entidEnvRaw != null
        && entidEnvRaw.trim().startsWith("{");

    Map<String, Object> envm = new LinkedHashMap<>();
    envm.put("VOXGIG_SOLARDEMO_TEST_MOON_ENTID", idmap);
    envm.put("VOXGIG_SOLARDEMO_TEST_LIVE", "FALSE");
    envm.put("VOXGIG_SOLARDEMO_TEST_EXPLAIN", "FALSE");
    Map<String, Object> env = RunnerSupport.envOverride(envm);

    Map<String, Object> idmapResolved = Helpers.toMapAny(env.get("VOXGIG_SOLARDEMO_TEST_MOON_ENTID"));
    if (idmapResolved == null) {
      idmapResolved = Helpers.toMapAny(idmap);
    }
    // Add planet_id alias for update test.
    if (idmapResolved.get("planet_id") == null) {
      idmapResolved.put("planet_id", idmapResolved.get("planet01"));
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
