package voxgig.solardemosdk.sdktest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
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

import voxgig.solardemosdk.core.Helpers;
import voxgig.solardemosdk.core.SdkEntity;
import voxgig.solardemosdk.core.SolardemoSDK;
import voxgig.solardemosdk.utility.Json;
import voxgig.solardemosdk.utility.struct.Struct;

@SuppressWarnings({"unchecked", "unused"})
public class MoonEntityTest {

  @Test
  public void instance() {
    SolardemoSDK testsdk = SolardemoSDK.testSDK();
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
    // The basic flow consumes synthetic IDs from the fixture. In live mode
    // without an *_ENTID env override, those IDs hit the live API and 4xx.
    Assumptions.assumeFalse(setup.syntheticOnly,
        "live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_MOON_ENTID JSON to run live");
    SolardemoSDK client = setup.client;

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
    Object moonRef01DataDt0Loaded = moonRef01Ent.load(moonRef01MatchDt0, null);
    Map<String, Object> moonRef01DataDt0LoadResult = Helpers.toMapAny(moonRef01DataDt0Loaded instanceof SdkEntity ? ((SdkEntity) moonRef01DataDt0Loaded).data() : moonRef01DataDt0Loaded);
    assertNotNull(moonRef01DataDt0LoadResult, "expected load result to be a map");
    assertEquals(moonRef01Data.get("id"), moonRef01DataDt0LoadResult.get("id"),
        "expected load result id to match");

    // REMOVE
    Map<String, Object> moonRef01MatchRm0 = new LinkedHashMap<>();
    moonRef01MatchRm0.put("id", moonRef01Data.get("id"));
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

  @Test
  public void stream() {
    Map<String, Object> streamingActive = new LinkedHashMap<>();
    Map<String, Object> streamingOpts = new LinkedHashMap<>();
    streamingOpts.put("active", true);
    Map<String, Object> featureOpts = new LinkedHashMap<>();
    featureOpts.put("streaming", streamingOpts);
    streamingActive.put("feature", featureOpts);

    RunnerSupport.EntityTestSetup setup = moonBasicSetup(streamingActive);
    Assumptions.assumeFalse(setup.live,
        "stream test streams the seeded fixture data (unit mode only)");

    SdkEntity ent = setup.client.moon(null);
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
    RunnerSupport.EntityTestSetup setup2 = moonBasicSetup(null);
    SdkEntity ent2 = setup2.client.moon(null);
    List<Object> streamed2 = ent2.stream("list", match, null)
        .collect(Collectors.toList());
    assertEquals(listed.size(), streamed2.size(),
        "expected fallback stream to yield the materialised items");
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

    SolardemoSDK client = SolardemoSDK.testSDK(options, extra);

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

    // Detect ENTID env override before envOverride consumes it. When live
    // mode is on without a real override, the basic test runs against
    // synthetic IDs from the fixture and 4xx's. Surface this so the test
    // can skip.
    String entidEnvRaw = RunnerSupport.getenv("SOLARDEMO_TEST_MOON_ENTID");
    boolean idmapOverridden = entidEnvRaw != null
        && entidEnvRaw.trim().startsWith("{");

    Map<String, Object> envm = new LinkedHashMap<>();
    envm.put("SOLARDEMO_TEST_MOON_ENTID", idmap);
    envm.put("SOLARDEMO_TEST_LIVE", "FALSE");
    envm.put("SOLARDEMO_TEST_EXPLAIN", "FALSE");
    Map<String, Object> env = RunnerSupport.envOverride(envm);

    Map<String, Object> idmapResolved = Helpers.toMapAny(env.get("SOLARDEMO_TEST_MOON_ENTID"));
    if (idmapResolved == null) {
      idmapResolved = Helpers.toMapAny(idmap);
    }
    // Add planet_id alias for update test.
    if (idmapResolved.get("planet_id") == null) {
      idmapResolved.put("planet_id", idmapResolved.get("planet01"));
    }

    boolean live = "TRUE".equals(env.get("SOLARDEMO_TEST_LIVE"));
    if (live) {
      Map<String, Object> liveOpts = new LinkedHashMap<>();
      Object mergedOpts = Struct.merge(Struct.jt(liveOpts, extra));
      client = new SolardemoSDK(Helpers.toMapAny(mergedOpts));
    }

    RunnerSupport.EntityTestSetup setup = new RunnerSupport.EntityTestSetup();
    setup.client = client;
    setup.data = entityData;
    setup.idmap = idmapResolved;
    setup.env = env;
    setup.explain = "TRUE".equals(env.get("SOLARDEMO_TEST_EXPLAIN"));
    setup.live = live;
    setup.syntheticOnly = live && !idmapOverridden;
    setup.now = System.currentTimeMillis();
    return setup;
  }
}
