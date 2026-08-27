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
public class PlanetEntityTest {

  @Test
  public void instance() {
    SolardemoSDK testsdk = SolardemoSDK.testSDK();
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
    // The basic flow consumes synthetic IDs from the fixture. In live mode
    // without an *_ENTID env override, those IDs hit the live API and 4xx.
    Assumptions.assumeFalse(setup.syntheticOnly,
        "live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live");
    SolardemoSDK client = setup.client;

    // CREATE
    SdkEntity planetRef01Ent = client.planet(null);
    Map<String, Object> planetRef01Data = Helpers.toMapAny(Struct.getprop(
        Struct.getpath(setup.data, "new.planet"), "planet_ref01"));

    Object planetRef01DataResult = planetRef01Ent.create(planetRef01Data, null);
    planetRef01Data = Helpers.toMapAny(planetRef01DataResult instanceof SdkEntity ? ((SdkEntity) planetRef01DataResult).data() : planetRef01DataResult);
    assertNotNull(planetRef01Data, "expected create result to be a map");
    assertNotNull(planetRef01Data.get("id"), "expected created entity to have an id");

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

    // UPDATE
    Map<String, Object> planetRef01DataUp0Up = new LinkedHashMap<>();
    planetRef01DataUp0Up.put("id", planetRef01Data.get("id"));

    String planetRef01MarkdefUp0Name = "kind";
    String planetRef01MarkdefUp0Value = "Mark01-planet_ref01_" + setup.now;
    planetRef01DataUp0Up.put(planetRef01MarkdefUp0Name, planetRef01MarkdefUp0Value);

    Object planetRef01ResdataUp0Result = planetRef01Ent.update(planetRef01DataUp0Up, null);
    Map<String, Object> planetRef01ResdataUp0 = Helpers.toMapAny(planetRef01ResdataUp0Result instanceof SdkEntity ? ((SdkEntity) planetRef01ResdataUp0Result).data() : planetRef01ResdataUp0Result);
    assertNotNull(planetRef01ResdataUp0, "expected update result to be a map");
    assertEquals(planetRef01DataUp0Up.get("id"), planetRef01ResdataUp0.get("id"),
        "expected update result id to match");
    assertEquals(planetRef01MarkdefUp0Value, planetRef01ResdataUp0.get(planetRef01MarkdefUp0Name),
        "expected " + planetRef01MarkdefUp0Name + " to be updated");

    // LOAD
    Map<String, Object> planetRef01MatchDt0 = new LinkedHashMap<>();
    planetRef01MatchDt0.put("id", planetRef01Data.get("id"));
    Object planetRef01DataDt0Loaded = planetRef01Ent.load(planetRef01MatchDt0, null);
    Map<String, Object> planetRef01DataDt0LoadResult = Helpers.toMapAny(planetRef01DataDt0Loaded instanceof SdkEntity ? ((SdkEntity) planetRef01DataDt0Loaded).data() : planetRef01DataDt0Loaded);
    assertNotNull(planetRef01DataDt0LoadResult, "expected load result to be a map");
    assertEquals(planetRef01Data.get("id"), planetRef01DataDt0LoadResult.get("id"),
        "expected load result id to match");

    // REMOVE
    Map<String, Object> planetRef01MatchRm0 = new LinkedHashMap<>();
    planetRef01MatchRm0.put("id", planetRef01Data.get("id"));
    planetRef01Ent.remove(planetRef01MatchRm0, null);

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

    SolardemoSDK client = SolardemoSDK.testSDK(options, extra);

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

    // Detect ENTID env override before envOverride consumes it. When live
    // mode is on without a real override, the basic test runs against
    // synthetic IDs from the fixture and 4xx's. Surface this so the test
    // can skip.
    String entidEnvRaw = RunnerSupport.getenv("SOLARDEMO_TEST_PLANET_ENTID");
    boolean idmapOverridden = entidEnvRaw != null
        && entidEnvRaw.trim().startsWith("{");

    Map<String, Object> envm = new LinkedHashMap<>();
    envm.put("SOLARDEMO_TEST_PLANET_ENTID", idmap);
    envm.put("SOLARDEMO_TEST_LIVE", "FALSE");
    envm.put("SOLARDEMO_TEST_EXPLAIN", "FALSE");
    Map<String, Object> env = RunnerSupport.envOverride(envm);

    Map<String, Object> idmapResolved = Helpers.toMapAny(env.get("SOLARDEMO_TEST_PLANET_ENTID"));
    if (idmapResolved == null) {
      idmapResolved = Helpers.toMapAny(idmap);
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
