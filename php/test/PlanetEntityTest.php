<?php
declare(strict_types=1);

// Planet entity test

require_once __DIR__ . '/../solardemo_sdk.php';
require_once __DIR__ . '/Runner.php';

use PHPUnit\Framework\TestCase;
use Voxgig\Struct\Struct as Vs;

class PlanetEntityTest extends TestCase
{
    public function test_create_instance(): void
    {
        $testsdk = SolardemoSDK::test(null, null);
        $ent = $testsdk->Planet(null);
        $this->assertNotNull($ent);
    }

    // Feature #4: the entity stream(action, ...) method runs the op pipeline
    // and yields result items. With the streaming feature active it yields the
    // feature's incremental output; otherwise it falls back to the materialised
    // list so stream always yields.
    public function test_stream(): void
    {
        $seed = [
            "entity" => [
                "planet" => [
                    "s1" => ["id" => "s1"],
                    "s2" => ["id" => "s2"],
                    "s3" => ["id" => "s3"],
                ],
            ],
        ];

        // Fallback: streaming inactive -> yields the materialised list items.
        $base = SolardemoSDK::test($seed, null);
        $seen = iterator_to_array($base->Planet(null)->stream("list", null, null), false);
        $this->assertCount(3, $seen);

        // Inbound: streaming active -> yields each item from the feature.
        $cfg = SolardemoConfig::shared_config();
        if (isset($cfg["feature"]) && is_array($cfg["feature"]) && isset($cfg["feature"]["streaming"])) {
            $sdk = SolardemoSDK::test($seed, ["feature" => ["streaming" => ["active" => true]]]);
            $got = [];
            foreach ($sdk->Planet(null)->stream("list", null, null) as $item) {
                if (is_array($item) && array_is_list($item)) {
                    foreach ($item as $sub) {
                        $got[] = $sub;
                    }
                } else {
                    $got[] = $item;
                }
            }
            $this->assertCount(3, $got);
        }
    }

    public function test_basic_flow(): void
    {
        $setup = planet_basic_setup(null);
        // Per-op sdk-test-control.json skip.
        $_live = !empty($setup["live"]);
        foreach (["create", "list", "update", "load", "remove"] as $_op) {
            [$_shouldSkip, $_reason] = Runner::is_control_skipped("entityOp", "planet." . $_op, $_live ? "live" : "unit");
            if ($_shouldSkip) {
                $this->markTestSkipped($_reason ?? "skipped via sdk-test-control.json");
                return;
            }
        }
        // The basic flow consumes synthetic IDs from the fixture. In live mode
        // without an *_ENTID env override, those IDs hit the live API and 4xx.
        if (!empty($setup["synthetic_only"])) {
            $this->markTestSkipped("live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live");
            return;
        }
        $client = $setup["client"];

        // CREATE
        $planet_ref01_ent = $client->Planet(null);
        $planet_ref01_data = Helpers::to_map(Vs::getprop(
            Vs::getpath($setup["data"], "new.planet"), "planet_ref01"));

        $planet_ref01_data_result = $planet_ref01_ent->create($planet_ref01_data, null);
        $planet_ref01_data = Helpers::to_map(is_object($planet_ref01_data_result) && method_exists($planet_ref01_data_result, 'data_get') ? $planet_ref01_data_result->data_get() : $planet_ref01_data_result);
        $this->assertNotNull($planet_ref01_data);
        $this->assertNotNull($planet_ref01_data["id"]);

        // LIST
        $planet_ref01_match = [];

        $planet_ref01_list_result = $planet_ref01_ent->list($planet_ref01_match, null);
        $this->assertIsArray($planet_ref01_list_result);

        $found_item = sdk_select(
            Runner::entity_list_to_data($planet_ref01_list_result),
            ["id" => $planet_ref01_data["id"]]);
        $this->assertNotEmpty($found_item);

        // UPDATE
        $planet_ref01_data_up0_up = [
            "id" => $planet_ref01_data["id"],
        ];

        $planet_ref01_markdef_up0_name = "kind";
        $planet_ref01_markdef_up0_value = "Mark01-planet_ref01_" . $setup["now"];
        $planet_ref01_data_up0_up[$planet_ref01_markdef_up0_name] = $planet_ref01_markdef_up0_value;

        $planet_ref01_resdata_up0_result = $planet_ref01_ent->update($planet_ref01_data_up0_up, null);
        $planet_ref01_resdata_up0 = Helpers::to_map(is_object($planet_ref01_resdata_up0_result) && method_exists($planet_ref01_resdata_up0_result, 'data_get') ? $planet_ref01_resdata_up0_result->data_get() : $planet_ref01_resdata_up0_result);
        $this->assertNotNull($planet_ref01_resdata_up0);
        $this->assertEquals($planet_ref01_resdata_up0["id"], $planet_ref01_data_up0_up["id"]);
        $this->assertEquals($planet_ref01_resdata_up0[$planet_ref01_markdef_up0_name], $planet_ref01_markdef_up0_value);

        // LOAD
        $planet_ref01_match_dt0 = [
            "id" => $planet_ref01_data["id"],
        ];
        $planet_ref01_data_dt0_loaded = $planet_ref01_ent->load($planet_ref01_match_dt0, null);
        $planet_ref01_data_dt0_load_result = Helpers::to_map(is_object($planet_ref01_data_dt0_loaded) && method_exists($planet_ref01_data_dt0_loaded, 'data_get') ? $planet_ref01_data_dt0_loaded->data_get() : $planet_ref01_data_dt0_loaded);
        $this->assertNotNull($planet_ref01_data_dt0_load_result);
        $this->assertEquals($planet_ref01_data_dt0_load_result["id"], $planet_ref01_data["id"]);

        // REMOVE
        $planet_ref01_match_rm0 = [
            "id" => $planet_ref01_data["id"],
        ];
        $planet_ref01_ent->remove($planet_ref01_match_rm0, null);

        // LIST
        $planet_ref01_match_rt0 = [];

        $planet_ref01_list_rt0_result = $planet_ref01_ent->list($planet_ref01_match_rt0, null);
        $this->assertIsArray($planet_ref01_list_rt0_result);

        $not_found_item = sdk_select(
            Runner::entity_list_to_data($planet_ref01_list_rt0_result),
            ["id" => $planet_ref01_data["id"]]);
        $this->assertEmpty($not_found_item);

    }
}

function planet_basic_setup($extra)
{
    Runner::load_env_local();

    $entity_data_file = __DIR__ . '/../../.sdk/test/entity/planet/PlanetTestData.json';
    $entity_data_source = file_get_contents($entity_data_file);
    $entity_data = json_decode($entity_data_source, true);

    $options = [];
    $options["entity"] = $entity_data["existing"];

    $client = SolardemoSDK::test($options, $extra);

    // Generate idmap.
    $idmap = [];
    foreach (["planet01", "planet02", "planet03"] as $k) {
        $idmap[$k] = strtoupper($k);
    }

    // Detect ENTID env override before envOverride consumes it. When live
    // mode is on without a real override, the basic test runs against synthetic
    // IDs from the fixture and 4xx's. Surface this so the test can skip.
    $entid_env_raw = getenv("SOLARDEMO_TEST_PLANET_ENTID");
    $idmap_overridden = $entid_env_raw !== false && str_starts_with(trim($entid_env_raw), "{");

    $env = Runner::env_override([
        "SOLARDEMO_TEST_PLANET_ENTID" => $idmap,
        "SOLARDEMO_TEST_LIVE" => "FALSE",
        "SOLARDEMO_TEST_EXPLAIN" => "FALSE",
    ]);

    $idmap_resolved = Helpers::to_map(
        $env["SOLARDEMO_TEST_PLANET_ENTID"]);
    if ($idmap_resolved === null) {
        $idmap_resolved = Helpers::to_map($idmap);
    }

    if ($env["SOLARDEMO_TEST_LIVE"] === "TRUE") {
        $merged_opts = Vs::merge([
            // FIRST, so the generated fields below win: sdk-test-control.json's
            // test.client.options adds to the live client, it does not redirect it.
            Runner::live_client_options(),
            [
            ],
            // ismap, not a plain "?? []" default: an empty PHP array is a
            // LIST, and a non-map later entry REPLACES the accumulated map in
            // merge - so the no-extras call discarded live_client_options()
            // and the apikey/server map above it.
            Vs::ismap($extra) ? $extra : new \stdClass(),
        ]);
        $client = new SolardemoSDK(Helpers::to_map($merged_opts));
    }

    $live = $env["SOLARDEMO_TEST_LIVE"] === "TRUE";
    return [
        "client" => $client,
        "data" => $entity_data,
        "idmap" => $idmap_resolved,
        "env" => $env,
        "explain" => $env["SOLARDEMO_TEST_EXPLAIN"] === "TRUE",
        "live" => $live,
        "synthetic_only" => $live && !$idmap_overridden,
        "now" => (int)(microtime(true) * 1000),
    ];
}
