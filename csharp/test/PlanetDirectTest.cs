// planet direct API tests (generated from the API model).

using System.Text.Json;

using Voxgig.Struct;
using Xunit;

namespace VoxgigSolardemoSdk.Test;

public class PlanetDirectTest
{
    // main.kit.test.live.strict is true (the default is true): a live
    // request that fails, or a live test missing an input it needs,
    // fails the test.
    // An account with no record for a test to read skips it either way.
    private const bool LIVE_STRICT = true;

    [Fact]
    public void DirectList()
    {
        var setup = PlanetDirectSetup(new List<object?>
        {
            new Dictionary<string, object?> { ["id"] = "direct01" },
            new Dictionary<string, object?> { ["id"] = "direct02" },
        });
        var _mode = setup.Live ? "live" : "unit";
        var (_shouldSkip, _) = TestRunner.IsControlSkipped(
            "direct", "direct-list-planet", _mode);
        if (_shouldSkip)
        {
            return; // skipped via sdk-test-control.json
        }
        var client = setup.Client;


        var result = client.Direct(new Dictionary<string, object?>
        {
            ["path"] = "api/planet",
            ["method"] = "GET",
            ["params"] = new Dictionary<string, object?>(),
        });
        if (setup.Live)
        {
            if (!TestRunner.LiveOk(result))
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live list failed: " + TestRunner.LiveDescribe(result));
                return;
            }
            if (TestRunner.LiveList(result["data"]) == null)
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live list returned no list: " + TestRunner.LiveDescribe(result));
                return;
            }
        }
        else
        {
            Assert.True(Equals(result["ok"], true),
                $"expected ok to be true, got {result.GetValueOrDefault("err")}");
            Assert.Equal(200, Helpers.ToInt(result["status"]));
        }

        if (!setup.Live)
        {
            var dataList = result["data"] as List<object?>;
            Assert.True(dataList != null, "expected data to be a list");
            Assert.Equal(2, dataList!.Count);

            Assert.True(setup.Calls.Count == 1,
                $"expected 1 call, got {setup.Calls.Count}");
        }
    }

    [Fact]
    public void DirectLoad()
    {
        var setup = PlanetDirectSetup(
            new Dictionary<string, object?> { ["id"] = "direct01" });
        var _mode = setup.Live ? "live" : "unit";
        var (_shouldSkip, _) = TestRunner.IsControlSkipped(
            "direct", "direct-load-planet", _mode);
        if (_shouldSkip)
        {
            return; // skipped via sdk-test-control.json
        }
        var client = setup.Client;

        var pathParams = new Dictionary<string, object?>();
        var query = new Dictionary<string, object?>();
        if (setup.Live)
        {
            var listParams = new Dictionary<string, object?>();
            var listResult = client.Direct(new Dictionary<string, object?>
            {
                ["path"] = "api/planet",
                ["method"] = "GET",
                ["params"] = listParams,
            });
            if (!TestRunner.LiveOk(listResult))
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live list discovery failed: " + TestRunner.LiveDescribe(listResult));
                return;
            }
            var listData = TestRunner.LiveList(listResult["data"]);
            if (listData == null)
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live list discovery returned no list: " + TestRunner.LiveDescribe(listResult));
                return;
            }
            if (listData.Count == 0)
            {
                TestRunner.LiveEmpty("The account has no planet record to load");
                return;
            }
            var firstEnt = Helpers.ToMapAny(listData[0]);
            if (firstEnt == null || !firstEnt.TryGetValue("id", out var firstId) || firstId == null)
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live load blocked: discovery returned no usable identity");
                return;
            }
            pathParams["id"] = firstId;
        }
        else
        {
            pathParams["id"] = "direct01";
        }

        var result = client.Direct(new Dictionary<string, object?>
        {
            ["path"] = "api/planet/{id}",
            ["method"] = "GET",
            ["params"] = pathParams,
            ["query"] = query,
        });
        if (setup.Live)
        {
            if (!TestRunner.LiveOk(result))
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live load failed: " + TestRunner.LiveDescribe(result));
                return;
            }
            if (result["data"] == null)
            {
                TestRunner.LiveMiss(LIVE_STRICT, "Live load returned no data: " + TestRunner.LiveDescribe(result));
                return;
            }
        }
        else
        {
            Assert.True(Equals(result["ok"], true),
                $"expected ok to be true, got {result.GetValueOrDefault("err")}");
            Assert.Equal(200, Helpers.ToInt(result["status"]));
            Assert.NotNull(result["data"]);
        }

        if (!setup.Live)
        {
            if (result["data"] is Dictionary<string, object?> dataMap)
            {
                Assert.True(Equals(dataMap["id"], "direct01"),
                    $"expected data.id to be direct01, got {dataMap["id"]}");
            }

            Assert.True(setup.Calls.Count == 1,
                $"expected 1 call, got {setup.Calls.Count}");
            var call = setup.Calls[0];
            var init = call["init"] as Dictionary<string, object?>;
            Assert.Equal("GET", init?["method"]);
            var url = call["url"] as string ?? "";
            Assert.Contains("direct01", url);
        }
    }

    private class PlanetDirectSetupResult
    {
        public VoxgigSolardemoSDK Client = null!;
        public List<Dictionary<string, object?>> Calls = new();
        public bool Live;
        public Dictionary<string, object?> Idmap = new();
    }

    private static PlanetDirectSetupResult PlanetDirectSetup(object? mockres)
    {
        TestRunner.LoadEnvLocal();

        var calls = new List<Dictionary<string, object?>>();

        var env = TestRunner.EnvOverride(new Dictionary<string, object?>
        {
            ["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"] = new Dictionary<string, object?>(),
            ["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE",
        });

        var live = Equals(env["VOXGIG_SOLARDEMO_TEST_LIVE"], "TRUE");

        if (live)
        {
            // sdk-test-control.json's test.client.options goes UNDER the
            // generated fields: it adds to the live client, it does not
            // redirect it, so the generated entries overwrite it here.
            var liveOpts = TestRunner.LiveClientOptions();
            foreach (var _kv in new Dictionary<string, object?>
            {
            })
            {
                liveOpts[_kv.Key] = _kv.Value;
            }
            var liveClient = new VoxgigSolardemoSDK(liveOpts);

            var idmap = new Dictionary<string, object?>();
            var entidRaw = env["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"];
            if (entidRaw is string entidStr && entidStr.StartsWith("{"))
            {
                try
                {
                    var el = JsonSerializer.Deserialize<JsonElement>(entidStr);
                    idmap = StructRunner.ConvertElement(el)
                        as Dictionary<string, object?> ?? idmap;
                }
                catch (JsonException)
                {
                }
            }
            else if (entidRaw is Dictionary<string, object?> entidMap)
            {
                idmap = entidMap;
            }

            return new PlanetDirectSetupResult
            {
                Client = liveClient,
                Calls = calls,
                Live = true,
                Idmap = idmap,
            };
        }

        Func<string, Dictionary<string, object?>, Dictionary<string, object?>> mockFetch =
            (url, init) =>
            {
                calls.Add(new Dictionary<string, object?>
                {
                    ["url"] = url,
                    ["init"] = init,
                });
                return new Dictionary<string, object?>
                {
                    ["status"] = 200,
                    ["statusText"] = "OK",
                    ["headers"] = new Dictionary<string, object?>(),
                    ["json"] = (Func<object?>)(() =>
                        mockres ?? new Dictionary<string, object?> { ["id"] = "direct01" }),
                };
            };

        var client = new VoxgigSolardemoSDK(new Dictionary<string, object?>
        {
            ["base"] = "http://localhost:8080",
            ["system"] = new Dictionary<string, object?>
            {
                ["fetch"] = mockFetch,
            },
        });

        return new PlanetDirectSetupResult
        {
            Client = client,
            Calls = calls,
            Live = false,
            Idmap = new Dictionary<string, object?>(),
        };
    }
}
