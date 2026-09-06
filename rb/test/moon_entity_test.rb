# Moon entity test

require "minitest/autorun"
require "json"
require_relative "../Solardemo_sdk"
require_relative "runner"

class MoonEntityTest < Minitest::Test
  def test_create_instance
    testsdk = SolardemoSDK.test(nil, nil)
    ent = testsdk.Moon(nil)
    assert !ent.nil?
  end

  # Feature #4: the entity stream(action, ...) method runs the op pipeline and
  # returns an Enumerator over result items. With the streaming feature active
  # it yields the feature's incremental output; otherwise it falls back to the
  # materialised list so stream always yields.
  def test_stream
    seed = {
      "entity" => {
        "moon" => {
          "s1" => { "id" => "s1" },
          "s2" => { "id" => "s2" },
          "s3" => { "id" => "s3" },
        },
      },
    }

    # Fallback: streaming inactive -> yields the materialised list items.
    base = SolardemoSDK.test(seed, nil)
    seen = base.Moon(nil).stream("list", nil, nil).to_a
    assert_equal 3, seen.length

    # Inbound: streaming active -> yields each item from the feature.
    cfg = SolardemoConfig.shared_config
    if cfg["feature"].is_a?(Hash) && cfg["feature"].key?("streaming")
      sdk = SolardemoSDK.test(seed, { "feature" => { "streaming" => { "active" => true } } })
      got = []
      sdk.Moon(nil).stream("list", nil, nil).each do |item|
        if item.is_a?(Array)
          got.concat(item)
        else
          got << item
        end
      end
      assert_equal 3, got.length
    end
  end

  def test_basic_flow
    setup = moon_basic_setup(nil)
    # Per-op sdk-test-control.json skip.
    _live = setup[:live] || false
    ["create", "list", "update", "load", "remove"].each do |_op|
      _should_skip, _reason = Runner.is_control_skipped("entityOp", "moon." + _op, _live ? "live" : "unit")
      if _should_skip
        skip(_reason || "skipped via sdk-test-control.json")
        return
      end
    end
    # The basic flow consumes synthetic IDs from the fixture. In live mode
    # without an *_ENTID env override, those IDs hit the live API and 4xx.
    if setup[:synthetic_only]
      skip "live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_MOON_ENTID JSON to run live"
      return
    end
    client = setup[:client]

    # CREATE
    moon_ref01_ent = client.Moon(nil)
    moon_ref01_data = Helpers.to_map(Vs.getprop(
      Vs.getpath(setup[:data], "new.moon"), "moon_ref01"))
    moon_ref01_data["planet_id"] = setup[:idmap]["planet01"]

    moon_ref01_data_result = moon_ref01_ent.create(moon_ref01_data, nil)
    moon_ref01_data = Helpers.to_map(moon_ref01_data_result.respond_to?(:data_get) ? moon_ref01_data_result.data_get : moon_ref01_data_result)
    assert !moon_ref01_data.nil?
    assert !moon_ref01_data["id"].nil?

    # LIST
    moon_ref01_match = {
      "planet_id" => setup[:idmap]["planet01"],
    }

    moon_ref01_list_result = moon_ref01_ent.list(moon_ref01_match, nil)
    assert moon_ref01_list_result.is_a?(Array)

    found_item = Vs.select(
      Runner.entity_list_to_data(moon_ref01_list_result),
      { "id" => moon_ref01_data["id"] })
    assert !Vs.isempty(found_item)

    # UPDATE
    moon_ref01_data_up0_up = {
      "id" => moon_ref01_data["id"],
      "planet_id" => setup[:idmap]["planet_id"],
    }

    moon_ref01_markdef_up0_name = "kind"
    moon_ref01_markdef_up0_value = "Mark01-moon_ref01_#{setup[:now]}"
    moon_ref01_data_up0_up[moon_ref01_markdef_up0_name] = moon_ref01_markdef_up0_value

    moon_ref01_resdata_up0_result = moon_ref01_ent.update(moon_ref01_data_up0_up, nil)
    moon_ref01_resdata_up0 = Helpers.to_map(moon_ref01_resdata_up0_result.respond_to?(:data_get) ? moon_ref01_resdata_up0_result.data_get : moon_ref01_resdata_up0_result)
    assert !moon_ref01_resdata_up0.nil?
    assert_equal moon_ref01_resdata_up0["id"], moon_ref01_data_up0_up["id"]
    assert_equal moon_ref01_resdata_up0[moon_ref01_markdef_up0_name], moon_ref01_markdef_up0_value

    # LOAD
    moon_ref01_match_dt0 = {
      "id" => moon_ref01_data["id"],
    }
    moon_ref01_data_dt0_loaded = moon_ref01_ent.load(moon_ref01_match_dt0, nil)
    moon_ref01_data_dt0_load_result = Helpers.to_map(moon_ref01_data_dt0_loaded.respond_to?(:data_get) ? moon_ref01_data_dt0_loaded.data_get : moon_ref01_data_dt0_loaded)
    assert !moon_ref01_data_dt0_load_result.nil?
    assert_equal moon_ref01_data_dt0_load_result["id"], moon_ref01_data["id"]

    # REMOVE
    moon_ref01_match_rm0 = {
      "id" => moon_ref01_data["id"],
    }
    moon_ref01_ent.remove(moon_ref01_match_rm0, nil)

    # LIST
    moon_ref01_match_rt0 = {
      "planet_id" => setup[:idmap]["planet01"],
    }

    moon_ref01_list_rt0_result = moon_ref01_ent.list(moon_ref01_match_rt0, nil)
    assert moon_ref01_list_rt0_result.is_a?(Array)

    not_found_item = Vs.select(
      Runner.entity_list_to_data(moon_ref01_list_rt0_result),
      { "id" => moon_ref01_data["id"] })
    assert Vs.isempty(not_found_item)

  end
end

def moon_basic_setup(extra)
  Runner.load_env_local

  entity_data_file = File.join(__dir__, "..", "..", ".sdk", "test", "entity", "moon", "MoonTestData.json")
  entity_data_source = File.read(entity_data_file)
  entity_data = JSON.parse(entity_data_source)

  options = {}
  options["entity"] = entity_data["existing"]

  client = SolardemoSDK.test(options, extra)

  # Generate idmap via transform.
  idmap = Vs.transform(
    ["moon01", "moon02", "moon03", "planet01", "planet02", "planet03"],
    {
      "`$PACK`" => ["", {
        "`$KEY`" => "`$COPY`",
        "`$VAL`" => ["`$FORMAT`", "upper", "`$COPY`"],
      }],
    }
  )

  # Detect ENTID env override before envOverride consumes it. When live
  # mode is on without a real override, the basic test runs against synthetic
  # IDs from the fixture and 4xx's. Surface this so the test can skip.
  entid_env_raw = ENV["SOLARDEMO_TEST_MOON_ENTID"]
  idmap_overridden = !entid_env_raw.nil? && entid_env_raw.strip.start_with?("{")

  env = Runner.env_override({
    "SOLARDEMO_TEST_MOON_ENTID" => idmap,
    "SOLARDEMO_TEST_LIVE" => "FALSE",
    "SOLARDEMO_TEST_EXPLAIN" => "FALSE",
  })

  idmap_resolved = Helpers.to_map(
    env["SOLARDEMO_TEST_MOON_ENTID"])
  if idmap_resolved.nil?
    idmap_resolved = Helpers.to_map(idmap)
  end
  if idmap_resolved["planet_id"].nil?
    idmap_resolved["planet_id"] = idmap_resolved["planet01"]
  end

  if env["SOLARDEMO_TEST_LIVE"] == "TRUE"
    merged_opts = Vs.merge([
      # FIRST, so the generated fields below win: sdk-test-control.json's
      # test.client.options adds to the live client, it does not redirect it.
      Runner.live_client_options,
      {
      },
      extra || {},
    ])
    client = SolardemoSDK.new(Helpers.to_map(merged_opts))
  end

  live = env["SOLARDEMO_TEST_LIVE"] == "TRUE"
  {
    client: client,
    data: entity_data,
    idmap: idmap_resolved,
    env: env,
    explain: env["SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
    live: live,
    synthetic_only: live && !idmap_overridden,
    now: (Time.now.to_f * 1000).to_i,
  }
end
