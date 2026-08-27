// moon entity test - basic flow (generated from the API model).

using System.Text.Json;

using Voxgig.Struct;
using Xunit;

namespace SolardemoSdk.Test;

public class MoonEntityTest
{
    [Fact]
    public void Instance()
    {
        var testsdk = SolardemoSDK.TestSDK(null, null);
        var ent = testsdk.Moon();
        Assert.NotNull(ent);
    }

    [Fact]
    public void Basic()
    {
        var setup = MoonBasicSetup(null);
        // Per-op sdk-test-control.json skip - basic test exercises a flow
        // with multiple ops; skipping any op skips the whole flow.
        var _mode = setup.Live ? "live" : "unit";
        foreach (var _op in new[] { "create", "list", "update", "load", "remove" })
        {
            var (_shouldSkip, _) = TestRunner.IsControlSkipped(
                "entityOp", "moon." + _op, _mode);
            if (_shouldSkip)
            {
                return; // skipped via sdk-test-control.json
            }
        }
        // The basic flow consumes synthetic IDs from the fixture. In live
        // mode without an *_ENTID env override, those IDs hit the live API
        // and 4xx; set SOLARDEMO_TEST_MOON_ENTID JSON to run live.
        if (setup.SyntheticOnly)
        {
            return;
        }
        var client = setup.Client;

        // CREATE
        var moonRef01Ent = client.Moon();
        var moonRef01Data = Helpers.ToMapAny(StructUtils.GetProp(
            StructUtils.GetPath(setup.Data, StructUtils.Jt("new", "moon")),
            "moon_ref01"));
        moonRef01Data!["planet_id"] = setup.Idmap["planet01"];

        var moonRef01DataResult = moonRef01Ent.Create(moonRef01Data, null);
        moonRef01Data = Helpers.ToMapAny(moonRef01DataResult is IEntity ce ? ce.Data() : moonRef01DataResult);
        Assert.True(moonRef01Data != null, "expected create result to be a map");
        Assert.True(moonRef01Data!["id"] != null, "expected created entity to have an id");

        // LIST
        var moonRef01Match = new Dictionary<string, object?>
        {
            ["planet_id"] = setup.Idmap["planet01"],
        };

        var moonRef01ListResult = moonRef01Ent.List(moonRef01Match, null);
        var moonRef01List = moonRef01ListResult as List<object?>;
        Assert.True(moonRef01List != null,
            $"expected list result to be a list, got {moonRef01ListResult?.GetType()}");

        var moonRef01ListFound = StructUtils.Select(
            TestRunner.EntityListToData(moonRef01List!),
            new Dictionary<string, object?> { ["id"] = moonRef01Data!["id"] });
        Assert.False(StructUtils.IsEmpty(moonRef01ListFound),
            "expected to find created entity in list");

        // UPDATE
        var moonRef01DataUp0Up = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
            ["planet_id"] = setup.Idmap["planet_id"],
        };

        var moonRef01MarkdefUp0Name = "kind";
        var moonRef01MarkdefUp0Value = $"Mark01-moon_ref01_{setup.Now}";
        moonRef01DataUp0Up[moonRef01MarkdefUp0Name] = moonRef01MarkdefUp0Value;

        var moonRef01ResdataUp0Result = moonRef01Ent.Update(moonRef01DataUp0Up, null);
        var moonRef01ResdataUp0 = Helpers.ToMapAny(moonRef01ResdataUp0Result is IEntity ue ? ue.Data() : moonRef01ResdataUp0Result);
        Assert.True(moonRef01ResdataUp0 != null, "expected update result to be a map");
        Assert.True(StructRunner.DeepEqual(moonRef01ResdataUp0!["id"], moonRef01DataUp0Up["id"]),
            "expected update result id to match");
        Assert.True(Equals(moonRef01ResdataUp0![moonRef01MarkdefUp0Name], moonRef01MarkdefUp0Value),
            $"expected {moonRef01MarkdefUp0Name} to be updated, got {moonRef01ResdataUp0[moonRef01MarkdefUp0Name]}");

        // LOAD
        var moonRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
        };
        var moonRef01DataDt0Loaded = moonRef01Ent.Load(moonRef01MatchDt0, null);
        var moonRef01DataDt0LoadResult = Helpers.ToMapAny(moonRef01DataDt0Loaded is IEntity le ? le.Data() : moonRef01DataDt0Loaded);
        Assert.True(moonRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(StructRunner.DeepEqual(moonRef01DataDt0LoadResult!["id"], moonRef01Data["id"]),
            "expected load result id to match");

        // REMOVE
        var moonRef01MatchRm0 = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
        };
        moonRef01Ent.Remove(moonRef01MatchRm0, null);

        // LIST
        var moonRef01MatchRt0 = new Dictionary<string, object?>
        {
            ["planet_id"] = setup.Idmap["planet01"],
        };

        var moonRef01ListRt0Result = moonRef01Ent.List(moonRef01MatchRt0, null);
        var moonRef01ListRt0 = moonRef01ListRt0Result as List<object?>;
        Assert.True(moonRef01ListRt0 != null,
            $"expected list result to be a list, got {moonRef01ListRt0Result?.GetType()}");

        var moonRef01ListRt0NotFound = StructUtils.Select(
            TestRunner.EntityListToData(moonRef01ListRt0!),
            new Dictionary<string, object?> { ["id"] = moonRef01Data!["id"] });
        Assert.True(StructUtils.IsEmpty(moonRef01ListRt0NotFound),
            "expected removed entity to not be in list");

    }

    [Fact]
    public async Task Stream()
    {
        var setup = MoonBasicSetup(new Dictionary<string, object?>
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

        var ent = setup.Client.Moon();
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
        var setup2 = MoonBasicSetup(null);
        var ent2 = setup2.Client.Moon();
        var streamed2 = new List<object?>();
        await foreach (var item in ent2.Stream("list", match, null))
        {
            streamed2.Add(item);
        }
        Assert.Equal(listed.Count, streamed2.Count);
    }

    private static EntityTestSetup MoonBasicSetup(
        Dictionary<string, object?>? extra)
    {
        TestRunner.LoadEnvLocal();

        var entityDataFile = Path.Combine(TestRunner.TestDir(),
            "..", "..", ".sdk", "test", "entity", "moon",
            "MoonTestData.json");

        var entityDataEl = JsonSerializer.Deserialize<JsonElement>(
            File.ReadAllText(entityDataFile));
        var entityData = StructRunner.ConvertElement(entityDataEl)
            as Dictionary<string, object?>
            ?? throw new InvalidOperationException(
                "failed to parse moon test data");

        var options = new Dictionary<string, object?>
        {
            ["entity"] = entityData["existing"],
        };

        var client = SolardemoSDK.TestSDK(options, extra);

        // Generate idmap via transform, matching the TS pattern.
        var idmap = StructUtils.Transform(
            new List<object?> { "moon01", "moon02", "moon03", "planet01", "planet02", "planet03" },
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
            "SOLARDEMO_TEST_MOON_ENTID") ?? "";
        var idmapOverridden = entidEnvRaw != "" &&
            entidEnvRaw.Trim().StartsWith("{");

        var env = TestRunner.EnvOverride(new Dictionary<string, object?>
        {
            ["SOLARDEMO_TEST_MOON_ENTID"] = idmap,
            ["SOLARDEMO_TEST_LIVE"] = "FALSE",
            ["SOLARDEMO_TEST_EXPLAIN"] = "FALSE",
        });

        var idmapResolved = Helpers.ToMapAny(env["SOLARDEMO_TEST_MOON_ENTID"])
            ?? Helpers.ToMapAny(idmap)
            ?? new Dictionary<string, object?>();

        // Add planet_id alias for the update test.
        if (StructUtils.GetProp(idmapResolved, "planet_id") == null)
        {
            idmapResolved["planet_id"] = StructUtils.GetProp(idmapResolved, "planet01");
        }

        if (Equals(env["SOLARDEMO_TEST_LIVE"], "TRUE"))
        {
            var mergedOpts = StructUtils.Merge(new List<object?>
            {
                new Dictionary<string, object?>
                {
                },
                extra,
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
