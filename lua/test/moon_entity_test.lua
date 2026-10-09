-- Moon entity test

local json = require("dkjson")
local vs = require("utility.struct.struct")
local sdk = require("voxgig-solardemo_sdk")
local helpers = require("core.helpers")
local runner = require("test.runner")

local _test_dir = debug.getinfo(1, "S").source:match("^@(.+/)")  or "./"

-- main.kit.test.live.strict is true (the default is true): a live
-- request that fails, or a live test missing an input it needs,
-- fails the test.
-- An account with no record for a test to read skips it either way.
local LIVE_STRICT = true


describe("MoonEntity", function()
  it("should create instance", function()
    local testsdk = sdk.test(nil, nil)
    local ent = testsdk:Moon(nil)
    assert.is_not_nil(ent)
  end)

  it("should refuse an invalid request", function()
    local config = require("config_shared")()
    if type(config.feature) ~= "table" or config.feature.validate == nil then
      pending("feature not present in this SDK: validate")
      return
    end
    local client = sdk.test(nil, { feature = { validate = { active = true } } })
    local _, err = client:Moon(nil):list({ ["planet_id"] = 1 }, nil)
    assert.are.equal("validate_failed", type(err) == "table" and err.code or nil)
  end)

  it("should run basic flow", function()
    local setup = moon_basic_setup(nil)
    -- Per-op sdk-test-control.json skip.
    local _live = setup.live or false
    for _, _op in ipairs({"create", "list", "update", "load", "remove"}) do
      local _should_skip, _reason = runner.is_control_skipped("entityOp", "moon." .. _op, _live and "live" or "unit")
      if _should_skip then
        pending(_reason or "skipped via sdk-test-control.json")
        return
      end
    end
    if setup.live then
      for _, _live_key in ipairs({"planet01"}) do
        if setup.synthetic_only or setup.idmap[_live_key] == nil then
          runner.live_miss(pending, LIVE_STRICT, "Live entity test blocked: needs " .. _live_key .. " via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        end
      end
    end
    local client = setup.client

    -- CREATE
    local moon_ref01_ent = client:Moon(nil)
    local moon_ref01_data = helpers.to_map(vs.getprop(
      vs.getpath(setup.data, "new.moon"), "moon_ref01"))
    moon_ref01_data["planet_id"] = setup.idmap["planet01"]

    local moon_ref01_data_result, err = moon_ref01_ent:create(moon_ref01_data, nil)
    assert.is_nil(err)
    moon_ref01_data = helpers.to_map(type(moon_ref01_data_result) == 'table' and moon_ref01_data_result.data_get and moon_ref01_data_result:data_get() or moon_ref01_data_result)
    assert.is_not_nil(moon_ref01_data)
    assert.is_not_nil(moon_ref01_data["id"])

    -- LIST
    local moon_ref01_match = {
      ["planet_id"] = setup.idmap["planet01"],
    }

    local moon_ref01_list_result, err = moon_ref01_ent:list(moon_ref01_match, nil)
    assert.is_nil(err)
    assert.is_table(moon_ref01_list_result)

    local found_item = vs.select(
      runner.entity_list_to_data(moon_ref01_list_result),
      { id = moon_ref01_data["id"] })
    assert.is_false(vs.isempty(found_item))

    -- UPDATE
    local moon_ref01_data_up0_up = {
      id = moon_ref01_data["id"],
      ["planet_id"] = setup.idmap["planet_id"],
    }

    local moon_ref01_markdef_up0_name = "kind"
    local moon_ref01_markdef_up0_value = "Mark01-moon_ref01_" .. tostring(setup.now)
    moon_ref01_data_up0_up[moon_ref01_markdef_up0_name] = moon_ref01_markdef_up0_value

    local moon_ref01_resdata_up0_result, err = moon_ref01_ent:update(moon_ref01_data_up0_up, nil)
    assert.is_nil(err)
    local moon_ref01_resdata_up0 = helpers.to_map(type(moon_ref01_resdata_up0_result) == 'table' and moon_ref01_resdata_up0_result.data_get and moon_ref01_resdata_up0_result:data_get() or moon_ref01_resdata_up0_result)
    assert.is_not_nil(moon_ref01_resdata_up0)
    assert.are.equal(moon_ref01_resdata_up0["id"], moon_ref01_data_up0_up["id"])
    assert.are.equal(moon_ref01_resdata_up0[moon_ref01_markdef_up0_name], moon_ref01_markdef_up0_value)

    -- LOAD
    local moon_ref01_match_dt0 = {
      id = moon_ref01_data["id"],
    }
    moon_ref01_match_dt0["planet_id"] = setup.idmap["planet_id"] or setup.idmap["planet01"]
    local moon_ref01_data_dt0_loaded, err = moon_ref01_ent:load(moon_ref01_match_dt0, nil)
    assert.is_nil(err)
    local moon_ref01_data_dt0_load_result = helpers.to_map(type(moon_ref01_data_dt0_loaded) == 'table' and moon_ref01_data_dt0_loaded.data_get and moon_ref01_data_dt0_loaded:data_get() or moon_ref01_data_dt0_loaded)
    assert.is_not_nil(moon_ref01_data_dt0_load_result)
    assert.are.equal(moon_ref01_data_dt0_load_result["id"], moon_ref01_data["id"])

    -- REMOVE
    local moon_ref01_match_rm0 = {
      id = moon_ref01_data["id"],
    }
    moon_ref01_match_rm0["planet_id"] = setup.idmap["planet_id"] or setup.idmap["planet01"]
    local _, err = moon_ref01_ent:remove(moon_ref01_match_rm0, nil)
    assert.is_nil(err)

    -- LIST
    local moon_ref01_match_rt0 = {
      ["planet_id"] = setup.idmap["planet01"],
    }

    local moon_ref01_list_rt0_result, err = moon_ref01_ent:list(moon_ref01_match_rt0, nil)
    assert.is_nil(err)
    assert.is_table(moon_ref01_list_rt0_result)

    local not_found_item = vs.select(
      runner.entity_list_to_data(moon_ref01_list_rt0_result),
      { id = moon_ref01_data["id"] })
    assert.is_true(vs.isempty(not_found_item))

  end)
end)

function moon_basic_setup(extra)
  runner.load_env_local()

  local entity_data_file = _test_dir .. "../../.sdk/test/entity/moon/MoonTestData.json"
  local f = io.open(entity_data_file, "r")
  if f == nil then
    error("failed to read moon test data: " .. entity_data_file)
  end
  local entity_data_source = f:read("*a")
  f:close()

  local entity_data = json.decode(entity_data_source)

  local options = {}
  options["entity"] = entity_data["existing"]

  local client = sdk.test(options, extra)

  -- Generate idmap via transform.
  local idmap = vs.transform(
    { "moon01", "moon02", "moon03", "planet01", "planet02", "planet03" },
    {
      ["`$PACK`"] = { "", {
        ["`$KEY`"] = "`$COPY`",
        ["`$VAL`"] = { "`$FORMAT`", "upper", "`$COPY`" },
      }},
    }
  )

  -- Whether *_ENTID supplied the idmap, read before env_override consumes
  -- it: without it, the ids a live flow binds are the fixture's synthetic ones.
  local entid_env_raw = os.getenv("VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
  local idmap_overridden = entid_env_raw ~= nil and entid_env_raw:match("^%s*{") ~= nil

  local env = runner.env_override({
    ["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"] = idmap,
    ["VOXGIG_SOLARDEMO_TEST_LIVE"] = "FALSE",
    ["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] = "FALSE",
  })

  local idmap_resolved = helpers.to_map(
    env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"])
  if idmap_resolved == nil then
    idmap_resolved = helpers.to_map(idmap)
  end
  if idmap_resolved["planet_id"] == nil then
    idmap_resolved["planet_id"] = idmap_resolved["planet01"]
  end

  if env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE" then
    local merged_opts = vs.merge({
      -- FIRST, so the generated fields below win: sdk-test-control.json's
      -- test.client.options adds to the live client, it does not redirect it.
      runner.live_client_options(),
      {
      },
      extra or {},
    })
    client = sdk.new(helpers.to_map(merged_opts))
  end

  local live = env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE"
  return {
    client = client,
    data = entity_data,
    idmap = idmap_resolved,
    env = env,
    explain = env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
    live = live,
    synthetic_only = live and not idmap_overridden,
    now = os.time() * 1000,
  }
end
