# Planet entity test

require "minitest/autorun"
require "json"
require_relative "../VoxgigSolardemo_sdk"
require_relative "runner"

class PlanetEntityTest < Minitest::Test
  # main.kit.test.live.strict is true (the default is true): a live
  # request that fails, or a live test missing an input it needs,
  # fails the test.
  # An account with no record for a test to read skips it either way.
  LIVE_STRICT = true

  def test_create_instance
    testsdk = VoxgigSolardemoSDK.test(nil, nil)
    ent = testsdk.Planet(nil)
    assert !ent.nil?
  end

  def test_list_entities
    seed = {
      "entity" => {
        "planet" => {
          "l1" => { "id" => "l1" },
          "l2" => { "id" => "l2" },
        },
      },
    }
    items = VoxgigSolardemoSDK.test(seed, nil).Planet(nil).list(nil, nil)
    # list resolves to one entity per record; data_get reads the record.
    assert_equal 2, items.length
    items.each do |item|
      assert item.respond_to?(:data_get)
      assert item.data_get.is_a?(Hash)
    end
  end

  # The entity stream(action, ...) method runs the op pipeline and
  # returns an Enumerator over result items. With the streaming feature active
  # it yields the feature's incremental output; otherwise it falls back to the
  # materialised list so stream always yields.
  def test_stream
    seed = {
      "entity" => {
        "planet" => {
          "s1" => { "id" => "s1" },
          "s2" => { "id" => "s2" },
          "s3" => { "id" => "s3" },
        },
      },
    }

    # Fallback: streaming inactive -> yields the materialised list items.
    base = VoxgigSolardemoSDK.test(seed, nil)
    seen = base.Planet(nil).stream("list", nil, nil).to_a
    assert_equal 3, seen.length

    # Inbound: streaming active -> yields each item from the feature.
    cfg = VoxgigSolardemoConfig.shared_config
    if cfg["feature"].is_a?(Hash) && cfg["feature"].key?("streaming")
      sdk = VoxgigSolardemoSDK.test(seed, { "feature" => { "streaming" => { "active" => true } } })
      got = []
      sdk.Planet(nil).stream("list", nil, nil).each do |item|
        if item.is_a?(Array)
          got.concat(item)
        else
          got << item
        end
      end
      assert_equal 3, got.length
    end
  end

  class FailHook < VoxgigSolardemoBaseFeature
    attr_reader :unexpected

    def initialize
      super()
      @name = "failhook"
      @unexpected = 0
    end

    def PreSpec(ctx)
      raise "planet hook failed"
    end

    def PreUnexpected(ctx)
      @unexpected += 1
    end
  end

  def test_stream_error
    offline = { "net" => { "offline" => true } }
    err = assert_raises(StandardError) do
      VoxgigSolardemoSDK.test(offline, nil).Planet(nil).stream("list", nil, nil).to_a
    end
    assert_match(/offline/, err.message)

    VoxgigSolardemoSDK.test(offline, nil).Planet(nil)
      .stream("list", nil, { "ctrl" => { "throw" => false } }).to_a

    cfg = VoxgigSolardemoConfig.shared_config
    if cfg["feature"].is_a?(Hash) && cfg["feature"].key?("rbac")
      denied = VoxgigSolardemoSDK.test(nil, { "feature" => { "rbac" => { "active" => true, "deny" => true } } })
      err = assert_raises(StandardError) do
        denied.Planet(nil).stream("list", nil, nil).to_a
      end
      assert_equal "rbac_denied", err.code
    end
  end

  def test_stream_ctrl
    explain = {}
    ctrl = { "explain" => explain }
    VoxgigSolardemoSDK.test(nil, nil).Planet(nil).stream("list", nil, { "ctrl" => ctrl }).to_a
    assert_equal ["explain"], ctrl.keys
    assert_same explain, ctrl["explain"]
    refute_empty explain
  end

  def test_unexpected
    hook = FailHook.new
    client = VoxgigSolardemoSDK.new({ "feature" => { "test" => { "active" => true } }, "extend" => [hook] })

    err = assert_raises(StandardError) do
      client.Planet(nil).list(nil, nil)
    end
    assert_match(/hook failed/, err.message)
    assert_operator hook.unexpected, :>, 0

    fired = hook.unexpected
    assert_nil client.Planet(nil).list(nil, { "throw" => false })
    assert_operator hook.unexpected, :>, fired
  end

  def test_validate_list_response
    cfg = VoxgigSolardemoConfig.shared_config
    unless cfg["feature"].is_a?(Hash) && cfg["feature"].key?("validate")
      skip("feature not present in this SDK: validate")
    end
    opts = { "feature" => { "validate" => { "active" => true, "request" => false, "response" => true } } }
    listed = VoxgigSolardemoSDK.test({ "entity" => { "planet" => { "v1" => { "diameter" => 1, "kind" => "x", "name" => "x" } } } }, opts).Planet(nil).list(nil, nil)
    assert_equal ["v1"], listed.map { |ent| ent.data_get["id"] }
    err = assert_raises(StandardError) do
      VoxgigSolardemoSDK.test({ "entity" => { "planet" => { "v1" => { "diameter" => "x", "kind" => "x", "name" => "x" } } } }, opts).Planet(nil).list(nil, nil)
    end
    assert_equal "validate_failed", err.code
  end

  def test_validate
    cfg = VoxgigSolardemoConfig.shared_config
    unless cfg["feature"].is_a?(Hash) && cfg["feature"].key?("validate")
      skip("feature not present in this SDK: validate")
    end
    client = VoxgigSolardemoSDK.test(nil, { "feature" => { "validate" => { "active" => true } } })
    err = assert_raises(StandardError) do
      client.Planet(nil).list({ "diameter" => "x" }, nil)
    end
    assert_equal "validate_failed", err.code
  end

  def test_basic_flow
    setup = planet_basic_setup(nil)
    # Per-op sdk-test-control.json skip.
    _live = setup[:live] || false
    ["create", "list", "update", "load", "remove"].each do |_op|
      _should_skip, _reason = Runner.is_control_skipped("entityOp", "planet." + _op, _live ? "live" : "unit")
      if _should_skip
        skip(_reason || "skipped via sdk-test-control.json")
        return
      end
    end
    if setup[:live] && ENV["VOXGIG_GETONLY_GUARD"] == "TRUE"
      puts "LIVE STEP {\"id\":\"planet.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/forbid\"}"
      puts "LIVE STEP {\"id\":\"planet.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}\"}"
      puts "LIVE STEP {\"id\":\"planet.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}\"}"
      puts "LIVE STEP {\"id\":\"planet.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}"
    client = setup[:client]
    if setup[:live]
      _live_id = setup[:synthetic_only] ? nil : setup[:idmap]["planet01"]
      Runner.live_pace
      Runner.live_existing(setup, LIVE_STRICT, "planet", "id", _live_id) do
        client.Planet(nil).list({}, nil)
      end
    end

    # Bootstrap entity data from existing test data.
    planet_ref01_data_raw = Vs.items(Helpers.to_map(
      Vs.getpath(setup[:data], "existing.planet")))
    planet_ref01_data = nil
    if planet_ref01_data_raw.length > 0
      planet_ref01_data = Helpers.to_map(planet_ref01_data_raw[0][1])
    end

    Runner.live_pace if setup[:live]
    # LIST
    planet_ref01_ent = client.Planet(nil)
    planet_ref01_match = {}

    planet_ref01_list_result = planet_ref01_ent.list(planet_ref01_match, nil)
    assert planet_ref01_list_result.is_a?(Array)

    Runner.live_pace if setup[:live]
    # LOAD
    planet_ref01_match_dt0 = {
      "id" => planet_ref01_data["id"],
    }
    planet_ref01_data_dt0_loaded = planet_ref01_ent.load(planet_ref01_match_dt0, nil)
    planet_ref01_data_dt0_load_result = Helpers.to_map(planet_ref01_data_dt0_loaded.respond_to?(:data_get) ? planet_ref01_data_dt0_loaded.data_get : planet_ref01_data_dt0_loaded)
    assert !planet_ref01_data_dt0_load_result.nil?
    assert Runner.live_same_id(planet_ref01_data_dt0_load_result["id"], planet_ref01_data["id"])

      return
    end

    client = setup[:client]

    Runner.live_pace if setup[:live]
    # CREATE
    planet_ref01_ent = client.Planet(nil)
    planet_ref01_data = Helpers.to_map(Vs.getprop(
      Vs.getpath(setup[:data], "new.planet"), "planet_ref01"))

    planet_ref01_data_result = planet_ref01_ent.create(planet_ref01_data, nil)
    planet_ref01_data = Helpers.to_map(planet_ref01_data_result.respond_to?(:data_get) ? planet_ref01_data_result.data_get : planet_ref01_data_result)
    assert !planet_ref01_data.nil?
    assert !planet_ref01_data["id"].nil?

    Runner.live_pace if setup[:live]
    # LIST
    planet_ref01_match = {}

    planet_ref01_list_result = planet_ref01_ent.list(planet_ref01_match, nil)
    assert planet_ref01_list_result.is_a?(Array)

    found_item = Vs.select(
      Runner.entity_list_to_data(planet_ref01_list_result),
      { "id" => planet_ref01_data["id"] })
    assert !Vs.isempty(found_item)

    Runner.live_pace if setup[:live]
    # UPDATE
    planet_ref01_data_up0_up = {
      "id" => planet_ref01_data["id"],
    }

    planet_ref01_markdef_up0_name = "kind"
    planet_ref01_markdef_up0_value = "Mark01-planet_ref01_#{setup[:now]}"
    planet_ref01_data_up0_up[planet_ref01_markdef_up0_name] = planet_ref01_markdef_up0_value

    planet_ref01_resdata_up0_result = planet_ref01_ent.update(planet_ref01_data_up0_up, nil)
    planet_ref01_resdata_up0 = Helpers.to_map(planet_ref01_resdata_up0_result.respond_to?(:data_get) ? planet_ref01_resdata_up0_result.data_get : planet_ref01_resdata_up0_result)
    assert !planet_ref01_resdata_up0.nil?
    assert Runner.live_same_id(planet_ref01_resdata_up0["id"], planet_ref01_data_up0_up["id"])
    assert_equal planet_ref01_resdata_up0[planet_ref01_markdef_up0_name], planet_ref01_markdef_up0_value

    Runner.live_pace if setup[:live]
    # LOAD
    planet_ref01_match_dt0 = {
      "id" => planet_ref01_data["id"],
    }
    planet_ref01_data_dt0_loaded = planet_ref01_ent.load(planet_ref01_match_dt0, nil)
    planet_ref01_data_dt0_load_result = Helpers.to_map(planet_ref01_data_dt0_loaded.respond_to?(:data_get) ? planet_ref01_data_dt0_loaded.data_get : planet_ref01_data_dt0_loaded)
    assert !planet_ref01_data_dt0_load_result.nil?
    assert Runner.live_same_id(planet_ref01_data_dt0_load_result["id"], planet_ref01_data["id"])

    Runner.live_pace if setup[:live]
    # REMOVE
    planet_ref01_match_rm0 = {
      "id" => planet_ref01_data["id"],
    }
    planet_ref01_ent.remove(planet_ref01_match_rm0, nil)

    Runner.live_pace if setup[:live]
    # LIST
    planet_ref01_match_rt0 = {}

    planet_ref01_list_rt0_result = planet_ref01_ent.list(planet_ref01_match_rt0, nil)
    assert planet_ref01_list_rt0_result.is_a?(Array)

    not_found_item = Vs.select(
      Runner.entity_list_to_data(planet_ref01_list_rt0_result),
      { "id" => planet_ref01_data["id"] })
    assert Vs.isempty(not_found_item)

  end
end

def planet_basic_setup(extra)
  Runner.load_env_local

  entity_data_file = File.join(__dir__, "..", "..", ".sdk", "test", "entity", "planet", "PlanetTestData.json")
  entity_data_source = File.read(entity_data_file, encoding: "UTF-8")
  entity_data = JSON.parse(entity_data_source)

  options = {}
  options["entity"] = entity_data["existing"]

  client = VoxgigSolardemoSDK.test(options, extra)

  # Generate idmap via transform.
  idmap = Vs.transform(
    ["planet01", "planet02", "planet03"],
    {
      "`$PACK`" => ["", {
        "`$KEY`" => "`$COPY`",
        "`$VAL`" => ["`$FORMAT`", "upper", "`$COPY`"],
      }],
    }
  )

  # Whether *_ENTID supplied the idmap, read before env_override consumes
  # it: without it, the ids a live flow binds are the fixture's synthetic ones.
  entid_env_raw = ENV["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"]
  idmap_overridden = !entid_env_raw.nil? && entid_env_raw.strip.start_with?("{")

  env = Runner.env_override({
    "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID" => idmap,
    "VOXGIG_SOLARDEMO_TEST_LIVE" => "FALSE",
    "VOXGIG_SOLARDEMO_TEST_EXPLAIN" => "FALSE",
  })

  idmap_resolved = Helpers.to_map(
    env["VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"])
  if idmap_resolved.nil?
    idmap_resolved = Helpers.to_map(idmap)
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
