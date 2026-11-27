<?php
declare(strict_types=1);

// Planet entity test

require_once __DIR__ . '/../voxgigsolardemo_sdk.php';
require_once __DIR__ . '/Runner.php';

use PHPUnit\Framework\TestCase;
use Voxgig\Struct\Struct as Vs;

class PlanetEntityTestFailHook extends VoxgigSolardemoBaseFeature
{
    public int $unexpected = 0;

    public function __construct()
    {
        parent::__construct();
        $this->name = 'failhook';
    }

    public function init(VoxgigSolardemoContext $ctx, array $options): void
    {
    }

    public function PreSpec(VoxgigSolardemoContext $ctx): void
    {
        throw new \RuntimeException('planet hook failed');
    }

    public function PreUnexpected(VoxgigSolardemoContext $ctx): void
    {
        $this->unexpected++;
    }
}

class PlanetEntityTest extends TestCase
{
    // main.kit.test.live.strict is true (the default is true): a live
    // request that fails, or a live test missing an input it needs,
    // fails the test.
    // An account with no record for a test to read skips it either way.
    private const LIVE_STRICT = true;

    public function test_create_instance(): void
    {
        $testsdk = VoxgigSolardemoSDK::test(null, null);
        $ent = $testsdk->Planet(null);
        $this->assertNotNull($ent);
    }

    // The entity stream(action, ...) method runs the op pipeline
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
        $base = VoxgigSolardemoSDK::test($seed, null);
        $seen = iterator_to_array($base->Planet(null)->stream("list", null, null), false);
        $this->assertCount(3, $seen);

        // Inbound: streaming active -> yields each item from the feature.
        $cfg = VoxgigSolardemoConfig::shared_config();
        if (isset($cfg["feature"]) && is_array($cfg["feature"]) && isset($cfg["feature"]["streaming"])) {
            $sdk = VoxgigSolardemoSDK::test($seed, ["feature" => ["streaming" => ["active" => true]]]);
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

    public function test_stream_error(): void
    {
        $offline = ["net" => ["offline" => true]];
        $streamerr = null;
        try {
            iterator_to_array(VoxgigSolardemoSDK::test($offline, null)->Planet(null)
                ->stream("list", null, null), false);
        } catch (\Throwable $e) {
            $streamerr = $e;
        }
        $this->assertNotNull($streamerr, 'the stream should raise the transport failure');
        $this->assertStringContainsString('offline', $streamerr->getMessage());

        iterator_to_array(VoxgigSolardemoSDK::test($offline, null)->Planet(null)
            ->stream("list", null, ["ctrl" => ["throw" => false]]), false);

        $cfg = VoxgigSolardemoConfig::shared_config();
        if (isset($cfg["feature"]["rbac"])) {
            $denied = VoxgigSolardemoSDK::test(null, ["feature" => ["rbac" => ["active" => true, "deny" => true]]]);
            $denyerr = null;
            try {
                iterator_to_array($denied->Planet(null)->stream("list", null, null), false);
            } catch (\Throwable $e) {
                $denyerr = $e;
            }
            $this->assertSame('rbac_denied', $denyerr->sdk_code ?? null);
        }
    }

    public function test_stream_ctrl(): void
    {
        $ctrl = ["explain" => []];
        iterator_to_array(VoxgigSolardemoSDK::test(null, null)->Planet(null)
            ->stream("list", null, ["ctrl" => $ctrl]), false);
        $this->assertSame(["explain"], array_keys($ctrl));
    }

    public function test_unexpected(): void
    {
        $hook = new PlanetEntityTestFailHook();
        $client = new VoxgigSolardemoSDK(["feature" => ["test" => ["active" => true]], "extend" => [$hook]]);

        $err = null;
        try {
            $client->Planet(null)->list(null, null);
        } catch (\Throwable $e) {
            $err = $e;
        }
        $this->assertNotNull($err, 'the throwing hook should fail the operation');
        $this->assertStringContainsString('hook failed', $err->getMessage());
        $this->assertGreaterThan(0, $hook->unexpected, 'PreUnexpected did not fire');

        $fired = $hook->unexpected;
        $this->assertNull($client->Planet(null)->list(null, ["throw" => false]));
        $this->assertGreaterThan($fired, $hook->unexpected, 'PreUnexpected did not fire');
    }

    public function test_cost_commits_a_throwing_transport(): void
    {
        $cfg = VoxgigSolardemoConfig::shared_config();
        if (!isset($cfg["feature"]["cost"])) {
            $this->markTestSkipped('feature not present in this SDK: cost');
        }
        $client = new VoxgigSolardemoSDK([
            "test" => ["active" => true],
            "feature" => ["cost" => ["active" => true, "unit" => 1]],
            "utility" => ["fetcher" => function ($ctx, $url, $fetchdef) {
                throw new \RuntimeException('planet transport failed');
            }],
        ]);

        $err = null;
        try {
            $client->Planet(null)->list(null, null);
        } catch (\Throwable $e) {
            $err = $e;
        }
        $this->assertInstanceOf(VoxgigSolardemoError::class, $err);
        $this->assertStringContainsString('transport failed', $err->getMessage());

        $client->Planet(null)->list(null, ["throw" => false]);
        $this->assertSame(2, $client->_cost["total"]["calls"]);
        $this->assertSame(2, $client->_cost["total"]["attempts"]);
    }

    public function test_validate_list_response(): void
    {
        $cfg = VoxgigSolardemoConfig::shared_config();
        if (!isset($cfg["feature"]["validate"])) {
            $this->markTestSkipped('feature not present in this SDK: validate');
        }
        $opts = ["feature" => ["validate" => ["active" => true, "request" => false, "response" => true]]];
        $listed = VoxgigSolardemoSDK::test(['entity' => ['planet' => ['v1' => ['diameter' => 1, 'kind' => 'x', 'name' => 'x']]]], $opts)->Planet(null)->list(null, null);
        $this->assertSame(['v1'], array_map(fn($ent) => $ent->data_get()['id'] ?? null, $listed));
        $err = null;
        try {
            VoxgigSolardemoSDK::test(['entity' => ['planet' => ['v1' => ['diameter' => 'x', 'kind' => 'x', 'name' => 'x']]]], $opts)->Planet(null)->list(null, null);
        } catch (\Throwable $e) {
            $err = $e;
        }
        $this->assertSame('validate_failed', $err->sdk_code ?? null);
    }

    public function test_validate(): void
    {
        $cfg = VoxgigSolardemoConfig::shared_config();
        if (!isset($cfg["feature"]["validate"])) {
            $this->markTestSkipped('feature not present in this SDK: validate');
        }
        $client = VoxgigSolardemoSDK::test(null, ["feature" => ["validate" => ["active" => true]]]);
        $err = null;
        try {
            $client->Planet(null)->list(["diameter" => 'x'], null);
        } catch (\Throwable $e) {
            $err = $e;
        }
        $this->assertSame('validate_failed', $err->sdk_code ?? null);
    }

    public function test_validate_bare_list(): void
    {
        $cfg = VoxgigSolardemoConfig::shared_config();
        if (!isset($cfg["feature"]["validate"])) {
            $this->markTestSkipped('feature not present in this SDK: validate');
        }
        $client = VoxgigSolardemoSDK::test(null, ["feature" => ["validate" => ["active" => true]]]);
        $this->assertIsArray($client->Planet(null)->list(null, null));
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
        if (!empty($setup["live"]) && getenv('VOXGIG_GETONLY_GUARD') === "TRUE") {
            fwrite(STDOUT, 'LIVE STEP {"id":"planet.create.0","state":"excluded","attempted":false,"reason":"GET-only live run: needs POST /api/planet/{planet_id}/forbid"}' . "\n");
            fwrite(STDOUT, 'LIVE STEP {"id":"planet.update.2","state":"excluded","attempted":false,"reason":"GET-only live run: needs PUT /api/planet/{planet_id}"}' . "\n");
            fwrite(STDOUT, 'LIVE STEP {"id":"planet.remove.4","state":"excluded","attempted":false,"reason":"GET-only live run: needs DELETE /api/planet/{planet_id}"}' . "\n");
            fwrite(STDOUT, 'LIVE STEP {"id":"planet.list.5","state":"excluded","attempted":false,"reason":"GET-only live run: checks a removal this run does not make"}' . "\n");
        $client = $setup["client"];
        if (!empty($setup["live"])) {
            $_liveId = empty($setup["synthetic_only"]) ? ($setup["idmap"]["planet01"] ?? null) : null;
            Runner::live_pace();
            Runner::live_existing($setup, self::LIVE_STRICT, "planet",
                fn() => $client->Planet(null)->list([], null), "id", $_liveId);
        }

        // Bootstrap entity data from existing test data.
        $planet_ref01_data_raw = Vs::items(Helpers::to_map(
            Vs::getpath($setup["data"], "existing.planet")));
        $planet_ref01_data = null;
        if (count($planet_ref01_data_raw) > 0) {
            $planet_ref01_data = Helpers::to_map($planet_ref01_data_raw[0][1]);
        }

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // LIST
        $planet_ref01_ent = $client->Planet(null);
        $planet_ref01_match = [];

        $planet_ref01_list_result = $planet_ref01_ent->list($planet_ref01_match, null);
        $this->assertIsArray($planet_ref01_list_result);

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // LOAD
        $planet_ref01_match_dt0 = [
            "id" => $planet_ref01_data["id"],
        ];
        $planet_ref01_data_dt0_loaded = $planet_ref01_ent->load($planet_ref01_match_dt0, null);
        $planet_ref01_data_dt0_load_result = Helpers::to_map(is_object($planet_ref01_data_dt0_loaded) && method_exists($planet_ref01_data_dt0_loaded, 'data_get') ? $planet_ref01_data_dt0_loaded->data_get() : $planet_ref01_data_dt0_loaded);
        $this->assertNotNull($planet_ref01_data_dt0_load_result);
        $this->assertTrue(Runner::live_same_id($planet_ref01_data_dt0_load_result["id"] ?? null, $planet_ref01_data["id"]));

            return;
        }

        $client = $setup["client"];

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // CREATE
        $planet_ref01_ent = $client->Planet(null);
        $planet_ref01_data = Helpers::to_map(Vs::getprop(
            Vs::getpath($setup["data"], "new.planet"), "planet_ref01"));

        $planet_ref01_data_result = $planet_ref01_ent->create($planet_ref01_data, null);
        $planet_ref01_data = Helpers::to_map(is_object($planet_ref01_data_result) && method_exists($planet_ref01_data_result, 'data_get') ? $planet_ref01_data_result->data_get() : $planet_ref01_data_result);
        $this->assertNotNull($planet_ref01_data);
        $this->assertNotNull($planet_ref01_data["id"]);

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // LIST
        $planet_ref01_match = [];

        $planet_ref01_list_result = $planet_ref01_ent->list($planet_ref01_match, null);
        $this->assertIsArray($planet_ref01_list_result);

        $found_item = sdk_select(
            Runner::entity_list_to_data($planet_ref01_list_result),
            ["id" => $planet_ref01_data["id"]]);
        $this->assertNotEmpty($found_item);

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
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
        $this->assertTrue(Runner::live_same_id($planet_ref01_resdata_up0["id"] ?? null, $planet_ref01_data_up0_up["id"]));
        $this->assertEquals($planet_ref01_resdata_up0[$planet_ref01_markdef_up0_name], $planet_ref01_markdef_up0_value);

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // LOAD
        $planet_ref01_match_dt0 = [
            "id" => $planet_ref01_data["id"],
        ];
        $planet_ref01_data_dt0_loaded = $planet_ref01_ent->load($planet_ref01_match_dt0, null);
        $planet_ref01_data_dt0_load_result = Helpers::to_map(is_object($planet_ref01_data_dt0_loaded) && method_exists($planet_ref01_data_dt0_loaded, 'data_get') ? $planet_ref01_data_dt0_loaded->data_get() : $planet_ref01_data_dt0_loaded);
        $this->assertNotNull($planet_ref01_data_dt0_load_result);
        $this->assertTrue(Runner::live_same_id($planet_ref01_data_dt0_load_result["id"] ?? null, $planet_ref01_data["id"]));

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
        // REMOVE
        $planet_ref01_match_rm0 = [
            "id" => $planet_ref01_data["id"],
        ];
        $planet_ref01_ent->remove($planet_ref01_match_rm0, null);

        if (!empty($setup["live"])) {
            Runner::live_pace();
        }
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

    $client = VoxgigSolardemoSDK::test($options, $extra);

    // Generate idmap.
    $idmap = [];
    foreach (["planet01", "planet02", "planet03"] as $k) {
        $idmap[$k] = strtoupper($k);
    }

    // Whether *_ENTID supplied the idmap, read before env_override consumes
    // it: without it, the ids a live flow binds are the fixture's synthetic ones.
    $entid_env_raw = getenv("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID");
    $idmap_overridden = $entid_env_raw !== false && str_starts_with(trim($entid_env_raw), "{");

    $env = Runner::env_override([
        "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID" => $idmap,
        "VOXGIG_SOLARDEMO_TEST_LIVE" => "FALSE",
        "VOXGIG_SOLARDEMO_TEST_EXPLAIN" => "FALSE",
    ]);

    $idmap_resolved = Helpers::to_map(
        $env["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"]);
    if ($idmap_resolved === null) {
        $idmap_resolved = Helpers::to_map($idmap);
    }

    if ($env["VOXGIG_SOLARDEMO_TEST_LIVE"] === "TRUE") {
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
        // "?? []" because merge legitimately answers with a stdClass when every
        // contributing entry is an EMPTY map - an SDK with no apikey and no
        // server variables generates an empty middle entry, so that is the
        // common case, not the edge one. to_map returns null for a non-array by
        // design, and the constructor takes a non-nullable array, so without the
        // fallback every such SDK died on "must be of type array, null given"
        // the moment live mode was switched on. Offline mode never reaches this
        // branch, which is why the offline suite stayed green.
        $client = new VoxgigSolardemoSDK(Helpers::to_map($merged_opts) ?? []);
    }

    $live = $env["VOXGIG_SOLARDEMO_TEST_LIVE"] === "TRUE";
    return [
        "client" => $client,
        "data" => $entity_data,
        "idmap" => $idmap_resolved,
        "env" => $env,
        "explain" => $env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] === "TRUE",
        "live" => $live,
        "synthetic_only" => $live && !$idmap_overridden,
        "now" => (int)(microtime(true) * 1000),
    ];
}
