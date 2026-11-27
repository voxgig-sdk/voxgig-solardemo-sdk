// moon entity test - basic flow (generated from the API model).

using System.Text.Json;

using VoxgigSolardemoSdk.Feature;
using Voxgig.Struct;
using Xunit;

namespace VoxgigSolardemoSdk.Test;

public class MoonEntityTest
{
    // main.kit.test.live.strict is true (the default is true): a live
    // request that fails, or a live test missing an input it needs,
    // fails the test.
    // An account with no record for a test to read skips it either way.
    private const bool LIVE_STRICT = true;

    [Fact]
    public void Instance()
    {
        var testsdk = VoxgigSolardemoSDK.TestSDK(null, null);
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
        if (setup.Live && Environment.GetEnvironmentVariable("VOXGIG_GETONLY_GUARD") == "TRUE")
        {
            Console.WriteLine("LIVE STEP {\"id\":\"moon.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/moon\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"moon.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}/moon/{moon_id}\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"moon.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}/moon/{moon_id}\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"moon.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}");
            BasicGetOnly(setup);
            return;
        }

        if (setup.Live)
        {
            foreach (var liveKey in new[] { "planet01" })
            {
                if (setup.SyntheticOnly || StructUtils.GetProp(setup.Idmap, liveKey) == null)
                {
                    TestRunner.LiveMiss(LIVE_STRICT, "Live entity test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID");
                    return;
                }
            }
        }
        var client = setup.Client;

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // CREATE
        var moonRef01Ent = client.Moon();
        var moonRef01Data = Helpers.ToMapAny(StructUtils.GetProp(
            StructUtils.GetPath(setup.Data, StructUtils.Jt("new", "moon")),
            "moon_ref01"));
        moonRef01Data!["planet_id"] = setup.Idmap["planet01"];

        var moonRef01DataResult = moonRef01Ent.Create(moonRef01Data, null);
        moonRef01Data = Helpers.ToMapAny(moonRef01DataResult is IEntity moonRef01DataEntity ? moonRef01DataEntity.Data() : moonRef01DataResult);
        Assert.True(moonRef01Data != null, "expected create result to be a map");
        Assert.True(moonRef01Data!["id"] != null, "expected created entity to have an id");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
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

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
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
        var moonRef01ResdataUp0 = Helpers.ToMapAny(moonRef01ResdataUp0Result is IEntity moonRef01ResdataUp0Entity ? moonRef01ResdataUp0Entity.Data() : moonRef01ResdataUp0Result);
        Assert.True(moonRef01ResdataUp0 != null, "expected update result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(moonRef01ResdataUp0, "id"), moonRef01DataUp0Up["id"]), "expected update result id to match");
        Assert.True(Equals(moonRef01ResdataUp0![moonRef01MarkdefUp0Name], moonRef01MarkdefUp0Value),
            $"expected {moonRef01MarkdefUp0Name} to be updated, got {moonRef01ResdataUp0[moonRef01MarkdefUp0Name]}");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LOAD
        var moonRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
        };
        moonRef01MatchDt0["planet_id"] = StructUtils.GetProp(moonRef01Data, "planet_id") is System.IConvertible ? StructUtils.GetProp(moonRef01Data, "planet_id") : StructUtils.GetProp(setup.Idmap, "planet_id") ?? StructUtils.GetProp(setup.Idmap, "planet01");
        var moonRef01DataDt0Loaded = moonRef01Ent.Load(moonRef01MatchDt0, null);
        var moonRef01DataDt0LoadResult = Helpers.ToMapAny(moonRef01DataDt0Loaded is IEntity moonRef01DataDt0LoadedEntity ? moonRef01DataDt0LoadedEntity.Data() : moonRef01DataDt0Loaded);
        Assert.True(moonRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(moonRef01DataDt0LoadResult, "id"), StructUtils.GetProp(moonRef01Data, "id")), "expected load result id to match");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // REMOVE
        var moonRef01MatchRm0 = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
        };
        moonRef01MatchRm0["planet_id"] = StructUtils.GetProp(setup.Idmap, "planet_id") ?? StructUtils.GetProp(setup.Idmap, "planet01");
        moonRef01Ent.Remove(moonRef01MatchRm0, null);

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
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

    private static void BasicGetOnly(EntityTestSetup setup)
    {
        if (setup.Live)
        {
            foreach (var liveKey in new[] { "planet01" })
            {
                if (setup.SyntheticOnly || StructUtils.GetProp(setup.Idmap, liveKey) == null)
                {
                    TestRunner.LiveMiss(LIVE_STRICT, "Live entity test blocked: needs " + liveKey + " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID");
                    return;
                }
            }
        }
        var client = setup.Client;
        if (setup.Live)
        {
            var liveId = setup.SyntheticOnly ? null : StructUtils.GetProp(setup.Idmap, "moon01");
            TestRunner.LivePace();
            if (!TestRunner.LiveExisting(setup.Data, LIVE_STRICT, "moon",
                "id", liveId,
                () => client.Moon().List(new Dictionary<string, object?> { ["planet_id"] = setup.Idmap["planet01"], }, null)))
            {
                return;
            }
        }

        // Bootstrap entity data from existing test data (no create step in flow).
        var moonRef01DataRaw = StructUtils.Items(
            Helpers.ToMapAny(StructUtils.GetPath(setup.Data, "existing.moon")));
        var moonRef01Data = moonRef01DataRaw.Count > 0
            ? Helpers.ToMapAny(moonRef01DataRaw[0][1])
            : null;

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LIST
        var moonRef01Ent = client.Moon();
        var moonRef01Match = new Dictionary<string, object?>
        {
            ["planet_id"] = setup.Idmap["planet01"],
        };

        var moonRef01ListResult = moonRef01Ent.List(moonRef01Match, null);
        var moonRef01List = moonRef01ListResult as List<object?>;
        Assert.True(moonRef01List != null,
            $"expected list result to be a list, got {moonRef01ListResult?.GetType()}");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LOAD
        var moonRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = moonRef01Data!["id"],
        };
        moonRef01MatchDt0["planet_id"] = StructUtils.GetProp(moonRef01Data, "planet_id") is System.IConvertible ? StructUtils.GetProp(moonRef01Data, "planet_id") : StructUtils.GetProp(setup.Idmap, "planet_id") ?? StructUtils.GetProp(setup.Idmap, "planet01");
        var moonRef01DataDt0Loaded = moonRef01Ent.Load(moonRef01MatchDt0, null);
        var moonRef01DataDt0LoadResult = Helpers.ToMapAny(moonRef01DataDt0Loaded is IEntity moonRef01DataDt0LoadedEntity ? moonRef01DataDt0LoadedEntity.Data() : moonRef01DataDt0Loaded);
        Assert.True(moonRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(moonRef01DataDt0LoadResult, "id"), StructUtils.GetProp(moonRef01Data, "id")), "expected load result id to match");

    }

    [Fact]
    public void Validate()
    {
        if (!Fh.HasFeature("validate"))
        {
            Console.WriteLine("skip: feature not present in this SDK: validate");
            return;
        }
        var client = VoxgigSolardemoSDK.TestSDK(null,
            new Dictionary<string, object?> { ["feature"] = new Dictionary<string, object?> { ["validate"] = new Dictionary<string, object?> { ["active"] = true } } });
        var err = Assert.ThrowsAny<VoxgigSolardemoError>(() => client.Moon().List(
            new Dictionary<string, object?> { ["planet_id"] = 1 }, null));
        Assert.Equal("validate_failed", err.Code);
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

        var client = VoxgigSolardemoSDK.TestSDK(options, extra);

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

        // Whether *_ENTID supplied the idmap, read before EnvOverride consumes
        // it: without it, the ids a live flow binds are the fixture's synthetic ones.
        var entidEnvRaw = Environment.GetEnvironmentVariable(
            "VOXGIG_SOLARDEMO_TEST_MOON_ENTID") ?? "";
        var idmapOverridden = entidEnvRaw != "" &&
            entidEnvRaw.Trim().StartsWith("{");

        var env = TestRunner.EnvOverride(new Dictionary<string, object?>
        {
            ["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"] = idmap,
            ["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE",
            ["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] = "FALSE",
        });

        var idmapResolved = Helpers.ToMapAny(env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"])
            ?? Helpers.ToMapAny(idmap)
            ?? new Dictionary<string, object?>();

        // Add planet_id alias for the update test.
        if (StructUtils.GetProp(idmapResolved, "planet_id") == null)
        {
            idmapResolved["planet_id"] = StructUtils.GetProp(idmapResolved, "planet01");
        }

        if (Equals(env["VOXGIG_SOLARDEMO_TEST_LIVE"], "TRUE"))
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
            client = new VoxgigSolardemoSDK(Helpers.ToMapAny(mergedOpts));
        }

        var live = Equals(env["VOXGIG_SOLARDEMO_TEST_LIVE"], "TRUE");
        return new EntityTestSetup
        {
            Client = client,
            Data = entityData,
            Idmap = idmapResolved,
            Env = env,
            Explain = Equals(env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"], "TRUE"),
            Live = live,
            SyntheticOnly = live && !idmapOverridden,
            Now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
        };
    }
}
