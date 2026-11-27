// planet entity test - basic flow (generated from the API model).

using System.Text.Json;

using VoxgigSolardemoSdk.Feature;
using Voxgig.Struct;
using Xunit;

namespace VoxgigSolardemoSdk.Test;

public class PlanetEntityTest
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
        if (setup.Live && Environment.GetEnvironmentVariable("VOXGIG_GETONLY_GUARD") == "TRUE")
        {
            Console.WriteLine("LIVE STEP {\"id\":\"planet.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/forbid\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"planet.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"planet.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}\"}");
            Console.WriteLine("LIVE STEP {\"id\":\"planet.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}");
            BasicGetOnly(setup);
            return;
        }

        var client = setup.Client;

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // CREATE
        var planetRef01Ent = client.Planet();
        var planetRef01Data = Helpers.ToMapAny(StructUtils.GetProp(
            StructUtils.GetPath(setup.Data, StructUtils.Jt("new", "planet")),
            "planet_ref01"));

        var planetRef01DataResult = planetRef01Ent.Create(planetRef01Data, null);
        planetRef01Data = Helpers.ToMapAny(planetRef01DataResult is IEntity planetRef01DataEntity ? planetRef01DataEntity.Data() : planetRef01DataResult);
        Assert.True(planetRef01Data != null, "expected create result to be a map");
        Assert.True(planetRef01Data!["id"] != null, "expected created entity to have an id");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
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

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // UPDATE
        var planetRef01DataUp0Up = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };

        var planetRef01MarkdefUp0Name = "kind";
        var planetRef01MarkdefUp0Value = $"Mark01-planet_ref01_{setup.Now}";
        planetRef01DataUp0Up[planetRef01MarkdefUp0Name] = planetRef01MarkdefUp0Value;

        var planetRef01ResdataUp0Result = planetRef01Ent.Update(planetRef01DataUp0Up, null);
        var planetRef01ResdataUp0 = Helpers.ToMapAny(planetRef01ResdataUp0Result is IEntity planetRef01ResdataUp0Entity ? planetRef01ResdataUp0Entity.Data() : planetRef01ResdataUp0Result);
        Assert.True(planetRef01ResdataUp0 != null, "expected update result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(planetRef01ResdataUp0, "id"), planetRef01DataUp0Up["id"]), "expected update result id to match");
        Assert.True(Equals(planetRef01ResdataUp0![planetRef01MarkdefUp0Name], planetRef01MarkdefUp0Value),
            $"expected {planetRef01MarkdefUp0Name} to be updated, got {planetRef01ResdataUp0[planetRef01MarkdefUp0Name]}");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LOAD
        var planetRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };
        var planetRef01DataDt0Loaded = planetRef01Ent.Load(planetRef01MatchDt0, null);
        var planetRef01DataDt0LoadResult = Helpers.ToMapAny(planetRef01DataDt0Loaded is IEntity planetRef01DataDt0LoadedEntity ? planetRef01DataDt0LoadedEntity.Data() : planetRef01DataDt0Loaded);
        Assert.True(planetRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(planetRef01DataDt0LoadResult, "id"), StructUtils.GetProp(planetRef01Data, "id")), "expected load result id to match");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // REMOVE
        var planetRef01MatchRm0 = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };
        planetRef01Ent.Remove(planetRef01MatchRm0, null);

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
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

    private static void BasicGetOnly(EntityTestSetup setup)
    {
        var client = setup.Client;
        if (setup.Live)
        {
            var liveId = setup.SyntheticOnly ? null : StructUtils.GetProp(setup.Idmap, "planet01");
            TestRunner.LivePace();
            if (!TestRunner.LiveExisting(setup.Data, LIVE_STRICT, "planet",
                "id", liveId,
                () => client.Planet().List(new Dictionary<string, object?> { }, null)))
            {
                return;
            }
        }

        // Bootstrap entity data from existing test data (no create step in flow).
        var planetRef01DataRaw = StructUtils.Items(
            Helpers.ToMapAny(StructUtils.GetPath(setup.Data, "existing.planet")));
        var planetRef01Data = planetRef01DataRaw.Count > 0
            ? Helpers.ToMapAny(planetRef01DataRaw[0][1])
            : null;

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LIST
        var planetRef01Ent = client.Planet();
        var planetRef01Match = new Dictionary<string, object?>();

        var planetRef01ListResult = planetRef01Ent.List(planetRef01Match, null);
        var planetRef01List = planetRef01ListResult as List<object?>;
        Assert.True(planetRef01List != null,
            $"expected list result to be a list, got {planetRef01ListResult?.GetType()}");

        if (setup.Live)
        {
            TestRunner.LivePace();
        }
        // LOAD
        var planetRef01MatchDt0 = new Dictionary<string, object?>
        {
            ["id"] = planetRef01Data!["id"],
        };
        var planetRef01DataDt0Loaded = planetRef01Ent.Load(planetRef01MatchDt0, null);
        var planetRef01DataDt0LoadResult = Helpers.ToMapAny(planetRef01DataDt0Loaded is IEntity planetRef01DataDt0LoadedEntity ? planetRef01DataDt0LoadedEntity.Data() : planetRef01DataDt0Loaded);
        Assert.True(planetRef01DataDt0LoadResult != null, "expected load result to be a map");
        Assert.True(TestRunner.LiveSameId(StructUtils.GetProp(planetRef01DataDt0LoadResult, "id"), StructUtils.GetProp(planetRef01Data, "id")), "expected load result id to match");

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

    private sealed class FailHook : BaseFeature
    {
        public int Unexpected;

        public FailHook()
        {
            Name = "failhook";
            Version = "0.0.1";
            Active = true;
        }

        public override void PreSpec(Context ctx) =>
            throw new Exception("planet hook failed");

        public override void PreUnexpected(Context ctx) => Unexpected++;
    }

    [Fact]
    public async Task StreamError()
    {
        var offline = new Dictionary<string, object?> { ["net"] = new Dictionary<string, object?> { ["offline"] = true } };
        var err = await Assert.ThrowsAnyAsync<Exception>(async () =>
        {
            await foreach (var _ in VoxgigSolardemoSDK.TestSDK(offline, null).Planet().Stream("list", null, null)) { }
        });
        Assert.Contains("offline", err.Message);

        await foreach (var _ in VoxgigSolardemoSDK.TestSDK(offline, null).Planet().Stream("list", null,
            new Dictionary<string, object?> { ["ctrl"] = new Dictionary<string, object?> { ["throw"] = false } })) { }

        if (Fh.HasFeature("rbac"))
        {
            var denied = VoxgigSolardemoSDK.TestSDK(null,
                new Dictionary<string, object?> { ["feature"] = new Dictionary<string, object?> { ["rbac"] = new Dictionary<string, object?> { ["active"] = true, ["deny"] = true } } });
            var denyerr = await Assert.ThrowsAnyAsync<VoxgigSolardemoError>(async () =>
            {
                await foreach (var _ in denied.Planet().Stream("list", null, null)) { }
            });
            Assert.Equal("rbac_denied", denyerr.Code);
        }
    }

    [Fact]
    public async Task StreamCtrl()
    {
        var explain = new Dictionary<string, object?>();
        var ctrl = new Dictionary<string, object?> { ["explain"] = explain };
        await foreach (var _ in VoxgigSolardemoSDK.TestSDK(null, null).Planet().Stream("list", null,
            new Dictionary<string, object?> { ["ctrl"] = ctrl })) { }
        Assert.Equal(new[] { "explain" }, ctrl.Keys.ToArray());
        Assert.Same(explain, ctrl["explain"]);
        Assert.NotEmpty(explain);
    }

    [Fact]
    public void Unexpected()
    {
        var hook = new FailHook();
        var client = new VoxgigSolardemoSDK(new Dictionary<string, object?>
        {
            ["feature"] = new Dictionary<string, object?> { ["test"] = new Dictionary<string, object?> { ["active"] = true } },
            ["extend"] = new List<object?> { hook },
        });

        var err = Assert.ThrowsAny<Exception>(() => client.Planet().List(null, null));
        Assert.Contains("hook failed", err.Message);
        Assert.True(hook.Unexpected > 0);

        var fired = hook.Unexpected;
        client.Planet().List(null, new Dictionary<string, object?> { ["throw"] = false });
        Assert.True(hook.Unexpected > fired);
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
        var err = Assert.ThrowsAny<VoxgigSolardemoError>(() => client.Planet().List(
            new Dictionary<string, object?> { ["diameter"] = "x" }, null));
        Assert.Equal("validate_failed", err.Code);
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

        var client = VoxgigSolardemoSDK.TestSDK(options, extra);

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

        // Whether *_ENTID supplied the idmap, read before EnvOverride consumes
        // it: without it, the ids a live flow binds are the fixture's synthetic ones.
        var entidEnvRaw = Environment.GetEnvironmentVariable(
            "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID") ?? "";
        var idmapOverridden = entidEnvRaw != "" &&
            entidEnvRaw.Trim().StartsWith("{");

        var env = TestRunner.EnvOverride(new Dictionary<string, object?>
        {
            ["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"] = idmap,
            ["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE",
            ["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] = "FALSE",
        });

        var idmapResolved = Helpers.ToMapAny(env["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"])
            ?? Helpers.ToMapAny(idmap)
            ?? new Dictionary<string, object?>();

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
