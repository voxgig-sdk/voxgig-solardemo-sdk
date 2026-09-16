// planet entity test - basic flow (generated from the API model).

using System.Text.Json;

using Voxgig.Struct;
using Xunit;

namespace SolardemoSdk.Test;

public class PlanetEntityTest
{
    [Fact]
    public void Instance()
    {
        var testsdk = SolardemoSDK.TestSDK(null, null);
        var ent = testsdk.Planet();
        Assert.NotNull(ent);
    }

    [Fact]
    public void Basic()
    {
        var setup = PlanetBasicSetup(null);
        // Per-op sdk-test-control.json skip - basic test exercises a flow
        // with multiple ops; skipping any op skips the whole flow.
        var _mode = setup.Live ? "live" : "unit";
        foreach (var _op in new[] { "create", "list", "update", "load", "remove" })
        {
            var (_shouldSkip, _) = TestRunner.IsControlSkipped(
                "entityOp", "planet." + _op, _mode);
            if (_shouldSkip)
            {
                return; // skipped via sdk-test-control.json
            }
        }
        // The basic flow consumes synthetic IDs from the fixture. In live
        // mode without an *_ENTID env override, those IDs hit the live API
        // and 4xx; set SOLARDEMO_TEST_PLANET_ENTID JSON to run live.
        if (setup.SyntheticOnly)
        {
            return;
        }
        var client = setup.Client;

        // CREATE
        var planetRef01Ent = client.Planet();
        var planetRef01Data = Helpers.ToMapAny(StructUtils.GetProp(
            StructUtils.GetPath(setup.Data, StructUtils.Jt("new", "planet")),
            "planet_ref01"));

        var planetRef01DataResult = planetRef01Ent.Create(planetRef01Data, null);
        planetRef01Data = Helpers.ToMapAny(planetRef01DataResult is IEntity ce ? ce.Data() : planetRef01DataResult);
        Assert.True(planetRef01Data != null, "expected create result to be a map");
        Assert.True(planetRef01Data!["id"] != null, "expected created entity to have an id");

        // LIST
        var planetRef01Match = new Dictionary<string, object?>();

        var planetRef01ListResult = planetRef01Ent.List(planetRef01Match, null);
        var planetRef01List = planetRef01ListResult as List<object?>;
        Assert.True(planetRef01List != null,
            $"expected list result to be a list, got {planetRef01ListResult?.GetType()}");

        var planetRef01ListFound = StructUtils.Select(
            TestRunner.EntityListToData(planetRef01List!),
            new Dictionary<string, object?> { ["id"] = planetRef01Data!["id"] });
        Assert.False(StructUtils.IsEmpty(planetRef01ListFound),
            "expected to find created entity in list");

        // UPDATE
        var planetRef01DataUp0Up = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };

        var planetRef01MarkdefUp0Name = "kind";
        var planetRef01MarkdefUp0Value = $"Mark01-planet_ref01_{setup.Now}";
        planetRef01DataUp0Up[planetRef01MarkdefUp0Name] = planetRef01MarkdefUp0Value;

        var planetRef01ResdataUp0Result = planetRef01Ent.Update(planetRef01DataUp0Up, null);
        var planetRef01ResdataUp0 = Helpers.ToMapAny(planetRef01ResdataUp0Result is IEntity ue ? ue.Data() : planetRef01ResdataUp0Result);
        Assert.True(planetRef01ResdataUp0 != null, "expected update result to be a map");
        Assert.True(StructRunner.DeepEqual(planetRef01ResdataUp0!["id"], planetRef01DataUp0Up["id"]),
            "expected update result id to match");
        Assert.True(Equals(planetRef01ResdataUp0![planetRef01MarkdefUp0Name], planetRef01MarkdefUp0Value),
            $"expected {planetRef01MarkdefUp0Name} to be updated, got {planetRef01ResdataUp0[planetRef01MarkdefUp0Name]}");

        // LOAD
        var planetRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };
        var planetRef01DataDt0Loaded = planetRef01Ent.Load(planetRef01MatchDt0, null);
        var planetRef01DataDt0LoadResult = Helpers.ToMapAny(planetRef01DataDt0Loaded is IEntity le ? le.Data() : planetRef01DataDt0Loaded);
        Assert.True(planetRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(StructRunner.DeepEqual(planetRef01DataDt0LoadResult!["id"], planetRef01Data["id"]),
            "expected load result id to match");

        // REMOVE
        var planetRef01MatchRm0 = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };
        planetRef01Ent.Remove(planetRef01MatchRm0, null);

        // LIST
        var planetRef01MatchRt0 = new Dictionary<string, object?>();

        var planetRef01ListRt0Result = planetRef01Ent.List(planetRef01MatchRt0, null);
        var planetRef01ListRt0 = planetRef01ListRt0Result as List<object?>;
        Assert.True(planetRef01ListRt0 != null,
            $"expected list result to be a list, got {planetRef01ListRt0Result?.GetType()}");

        var planetRef01ListRt0NotFound = StructUtils.Select(
            TestRunner.EntityListToData(planetRef01ListRt0!),
            new Dictionary<string, object?> { ["id"] = planetRef01Data!["id"] });
        Assert.True(StructUtils.IsEmpty(planetRef01ListRt0NotFound),
            "expected removed entity to not be in list");

    }

    [Fact]
    public async Task Stream()
    {
        var setup = PlanetBasicSetup(new Dictionary<string, object?>
        {
            ["feature"] = new Dictionary<string, object?>
            {
                ["streaming"] = new Dictionary<string, object?> { ["active"] = true },
            },
        });
        if (setup.Live)
        {
            return; // unit mode only - streams the seeded fixture data
        }

        var ent = setup.Client.Planet();
        var match = new Dictionary<string, object?>();

        // Materialised list result for the same op.
        var listed = ent.List(match, null) as List<object?> ?? new List<object?>();

        // stream("list") yields items via the streaming feature's iterator.
        var streamed = new List<object?>();
        await foreach (var item in ent.Stream("list", match, null))
        {
            streamed.Add(item);
        }
        Assert.True(streamed.Count > 0, "expected stream to yield items");
        Assert.Equal(listed.Count, streamed.Count);

        // Fallback: with streaming inactive, stream still yields the
        // materialised items.
        var setup2 = PlanetBasicSetup(null);
        var ent2 = setup2.Client.Planet();
        var streamed2 = new List<object?>();
        await foreach (var item in ent2.Stream("list", match, null))
        {
            streamed2.Add(item);
        }
        Assert.Equal(listed.Count, streamed2.Count);
    }

    private static EntityTestSetup PlanetBasicSetup(
        Dictionary<string, object?>? extra)
    {
        TestRunner.LoadEnvLocal();

        var entityDataFile = Path.Combine(TestRunner.TestDir(),
            "..", "..", ".sdk", "test", "entity", "planet",
            "PlanetTestData.json");

        var entityDataEl = JsonSerializer.Deserialize<JsonElement>(
            File.ReadAllText(entityDataFile));
        var entityData = StructRunner.ConvertElement(entityDataEl)
            as Dictionary<string, object?>
            ?? throw new InvalidOperationException(
                "failed to parse planet test data");

        var options = new Dictionary<string, object?>
        {
            ["entity"] = entityData["existing"],
        };

        var client = SolardemoSDK.TestSDK(options, extra);

        // Generate idmap via transform, matching the TS pattern.
        var idmap = StructUtils.Transform(
            new List<object?> { "planet01", "planet02", "planet03" },
            new Dictionary<string, object?>
            {
                ["`$PACK`"] = new List<object?>
                {
                    "",
                    new Dictionary<string, object?>
                    {
                        ["`$KEY`"] = "`$COPY`",
                        ["`$VAL`"] = new List<object?> { "`$FORMAT`", "upper", "`$COPY`" },
                    },
                },
            });

        // Detect ENTID env override before EnvOverride consumes it. When
        // live mode is on without a real override, the basic test runs
        // against synthetic IDs from the fixture and 4xx's.
        var entidEnvRaw = Environment.GetEnvironmentVariable(
            "SOLARDEMO_TEST_PLANET_ENTID") ?? "";
        var idmapOverridden = entidEnvRaw != "" &&
            entidEnvRaw.Trim().StartsWith("{");

        var env = TestRunner.EnvOverride(new Dictionary<string, object?>
        {
            ["SOLARDEMO_TEST_PLANET_ENTID"] = idmap,
            ["SOLARDEMO_TEST_LIVE"] = "FALSE",
            ["SOLARDEMO_TEST_EXPLAIN"] = "FALSE",
        });

        var idmapResolved = Helpers.ToMapAny(env["SOLARDEMO_TEST_PLANET_ENTID"])
            ?? Helpers.ToMapAny(idmap)
            ?? new Dictionary<string, object?>();

        if (Equals(env["SOLARDEMO_TEST_LIVE"], "TRUE"))
        {
            // 'extra ?? new ...', not a bare 'extra': Merge returns null when
            // the last entry is null, and BasicSetup is normally called with no
            // argument at all - so a bare 'extra' silently discarded the apikey
            // and server values above and handed the SDK null.
            var extraOpts = extra ?? new Dictionary<string, object?>();
            var mergedOpts = StructUtils.Merge(new List<object?>
            {
                // FIRST, so the generated fields below win: sdk-test-control.json's
                // test.client.options adds to the live client, it does not redirect it.
                TestRunner.LiveClientOptions(),
                new Dictionary<string, object?>
                {
                },
                extraOpts,
            });
            client = new SolardemoSDK(Helpers.ToMapAny(mergedOpts));
        }

        var live = Equals(env["SOLARDEMO_TEST_LIVE"], "TRUE");
        return new EntityTestSetup
        {
            Client = client,
            Data = entityData,
            Idmap = idmapResolved,
            Env = env,
            Explain = Equals(env["SOLARDEMO_TEST_EXPLAIN"], "TRUE"),
            Live = live,
            SyntheticOnly = live && !idmapOverridden,
            Now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
        };
    }
}
