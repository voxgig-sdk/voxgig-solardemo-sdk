# Moon entity test

require "minitest/autorun"
require "json"
require_relative "../VoxgigSolardemo_sdk"
require_relative "runner"

class MoonEntityTest < Minitest::Test
  # main.kit.test.live.strict is true (the default is true): a live
  # request that fails, or a live test missing an input it needs,
  # fails the test.
  # An account with no record for a test to read skips it either way.
  LIVE_STRICT = true

  def test_create_instance
    testsdk = VoxgigSolardemoSDK.test(nil, nil)
    ent = testsdk.Moon(nil)
    assert !ent.nil?
  end

  def test_validate
    cfg = VoxgigSolardemoConfig.shared_config
    unless cfg["feature"].is_a?(Hash) && cfg["feature"].key?("validate")
      skip("feature not present in this SDK: validate")
    end
    client = VoxgigSolardemoSDK.test(nil, { "feature" => { "validate" => { "active" => true } } })
    err = assert_raises(StandardError) do
      client.Moon(nil).list({ "planet_id" => 1 }, nil)
    end
    assert_equal "validate_failed", err.code
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
    if setup[:live] && ENV["VOXGIG_GETONLY_GUARD"] == "TRUE"
      puts "LIVE STEP {\"id\":\"moon.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/moon\"}"
      puts "LIVE STEP {\"id\":\"moon.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}/moon/{moon_id}\"}"
      puts "LIVE STEP {\"id\":\"moon.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}/moon/{moon_id}\"}"
      puts "LIVE STEP {\"id\":\"moon.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}"
    if setup[:live]
      ["planet01"].each do |_live_key|
        if setup[:synthetic_only] || setup[:idmap][_live_key].nil?
          Runner.live_miss(LIVE_STRICT, "Live entity test blocked: needs #{_live_key} via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        end
      end
    end
    client = setup[:client]
    if setup[:live]
      _live_id = setup[:synthetic_only] ? nil : setup[:idmap]["moon01"]
      Runner.live_pace
      Runner.live_existing(setup, LIVE_STRICT, "moon", "id", _live_id) do
        client.Moon(nil).list({"planet_id" => setup[:idmap]["planet01"]}, nil)
      end
    end

    # Bootstrap entity data from existing test data.
    moon_ref01_data_raw = Vs.items(Helpers.to_map(
      Vs.getpath(setup[:data], "existing.moon")))
    moon_ref01_data = nil
    if moon_ref01_data_raw.length > 0
      moon_ref01_data = Helpers.to_map(moon_ref01_data_raw[0][1])
    end

    Runner.live_pace if setup[:live]
    # LIST
    moon_ref01_ent = client.Moon(nil)
    moon_ref01_match = {
      "planet_id" => setup[:idmap]["planet01"],
    }

    moon_ref01_list_result = moon_ref01_ent.list(moon_ref01_match, nil)
    assert moon_ref01_list_result.is_a?(Array)

    Runner.live_pace if setup[:live]
    # LOAD
    moon_ref01_match_dt0 = {
      "id" => moon_ref01_data["id"],
    }
    moon_ref01_match_dt0["planet_id"] = [String, Numeric, TrueClass, FalseClass].any? { |c| moon_ref01_data["planet_id"].is_a?(c) } ? moon_ref01_data["planet_id"] : (setup[:idmap]["planet_id"] || setup[:idmap]["planet01"])
    moon_ref01_data_dt0_loaded = moon_ref01_ent.load(moon_ref01_match_dt0, nil)
    moon_ref01_data_dt0_load_result = Helpers.to_map(moon_ref01_data_dt0_loaded.respond_to?(:data_get) ? moon_ref01_data_dt0_loaded.data_get : moon_ref01_data_dt0_loaded)
    assert !moon_ref01_data_dt0_load_result.nil?
    assert Runner.live_same_id(moon_ref01_data_dt0_load_result["id"], moon_ref01_data["id"])

      return
    end

    if setup[:live]
      ["planet01"].each do |_live_key|
        if setup[:synthetic_only] || setup[:idmap][_live_key].nil?
          Runner.live_miss(LIVE_STRICT, "Live entity test blocked: needs #{_live_key} via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        end
      end
    end
    client = setup[:client]

    Runner.live_pace if setup[:live]
    # CREATE
    moon_ref01_ent = client.Moon(nil)
    moon_ref01_data = Helpers.to_map(Vs.getprop(
      Vs.getpath(setup[:data], "new.moon"), "moon_ref01"))
    moon_ref01_data["planet_id"] = setup[:idmap]["planet01"]

    moon_ref01_data_result = moon_ref01_ent.create(moon_ref01_data, nil)
    moon_ref01_data = Helpers.to_map(moon_ref01_data_result.respond_to?(:data_get) ? moon_ref01_data_result.data_get : moon_ref01_data_result)
    assert !moon_ref01_data.nil?
    assert !moon_ref01_data["id"].nil?

    Runner.live_pace if setup[:live]
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

    Runner.live_pace if setup[:live]
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
    assert Runner.live_same_id(moon_ref01_resdata_up0["id"], moon_ref01_data_up0_up["id"])
    assert_equal moon_ref01_resdata_up0[moon_ref01_markdef_up0_name], moon_ref01_markdef_up0_value

    Runner.live_pace if setup[:live]
    # LOAD
    moon_ref01_match_dt0 = {
      "id" => moon_ref01_data["id"],
    }
    moon_ref01_match_dt0["planet_id"] = [String, Numeric, TrueClass, FalseClass].any? { |c| moon_ref01_data["planet_id"].is_a?(c) } ? moon_ref01_data["planet_id"] : (setup[:idmap]["planet_id"] || setup[:idmap]["planet01"])
    moon_ref01_data_dt0_loaded = moon_ref01_ent.load(moon_ref01_match_dt0, nil)
    moon_ref01_data_dt0_load_result = Helpers.to_map(moon_ref01_data_dt0_loaded.respond_to?(:data_get) ? moon_ref01_data_dt0_loaded.data_get : moon_ref01_data_dt0_loaded)
    assert !moon_ref01_data_dt0_load_result.nil?
    assert Runner.live_same_id(moon_ref01_data_dt0_load_result["id"], moon_ref01_data["id"])

    Runner.live_pace if setup[:live]
    # REMOVE
    moon_ref01_match_rm0 = {
      "id" => moon_ref01_data["id"],
    }
    moon_ref01_match_rm0["planet_id"] = setup[:idmap]["planet_id"] || setup[:idmap]["planet01"]
    moon_ref01_ent.remove(moon_ref01_match_rm0, nil)

    Runner.live_pace if setup[:live]
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
  entity_data_source = File.read(entity_data_file, encoding: "UTF-8")
  entity_data = JSON.parse(entity_data_source)

  options = {}
  options["entity"] = entity_data["existing"]

  client = VoxgigSolardemoSDK.test(options, extra)

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

  # Whether *_ENTID supplied the idmap, read before env_override consumes
  # it: without it, the ids a live flow binds are the fixture's synthetic ones.
  entid_env_raw = ENV["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"]
  idmap_overridden = !entid_env_raw.nil? && entid_env_raw.strip.start_with?("{")

  env = Runner.env_override({
    "VOXGIG_SOLARDEMO_TEST_MOON_ENTID" => idmap,
    "VOXGIG_SOLARDEMO_TEST_LIVE" => "FALSE",
    "VOXGIG_SOLARDEMO_TEST_EXPLAIN" => "FALSE",
  })

  idmap_resolved = Helpers.to_map(
    env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"])
  if idmap_resolved.nil?
    idmap_resolved = Helpers.to_map(idmap)
  end
  if idmap_resolved["planet_id"].nil?
    idmap_resolved["planet_id"] = idmap_resolved["planet01"]
  end

  if env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE"
    merged_opts = Vs.merge([
      # FIRST, so the generated fields below win: sdk-test-control.json's
      # test.client.options adds to the live client, it does not redirect it.
      Runner.live_client_options,
      {
      },
      extra || {},
    ])
    client = VoxgigSolardemoSDK.new(Helpers.to_map(merged_opts))
  end

  live = env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE"
  {
    client: client,
    data: entity_data,
    idmap: idmap_resolved,
    env: env,
    explain: env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
    live: live,
    synthetic_only: live && !idmap_overridden,
    now: (Time.now.to_f * 1000).to_i,
  }
end
