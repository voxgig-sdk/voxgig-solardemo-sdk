// Generated basic-flow test for the moon entity (model-driven,
// unit mode; mirrors the rust/go TestEntity generator).

#include "runner_support.hpp"

using namespace sdk;
using namespace sdk::rs;

struct MoonSetup {
  std::shared_ptr<SolardemoSDK> client;
  Value data;
  Value idmap;
  Value env;
  bool live = false;
  bool synthetic_only = false;
  long long now = 0;
};

static MoonSetup moon_basic_setup(const Value& extra) {
  load_env_local();

  std::string entity_data_file = "../.sdk/test/entity/moon/MoonTestData.json";
  Value entity_data = vs::parse_json(read_file(entity_data_file));

  Value options = vmap({{"entity", getp(entity_data, "existing")}});
  auto client = SolardemoSDK::testSDK(options, extra);

  // idmap via transform (upper-cased id name synthetics), matching the donors.
  Value idmap = Struct::transform(
      vlist({Value("moon01"), Value("moon02"), Value("moon03"), Value("planet01"), Value("planet02"), Value("planet03")}),
      vmap({{"`$PACK`", vlist({
        Value(""),
        vmap({
          {"`$KEY`", Value("`$COPY`")},
          {"`$VAL`", vlist({Value("`$FORMAT`"), Value("upper"), Value("`$COPY`")})}
        })
      })}}));
  if (!idmap.is_map()) idmap = vmap();

  Value env = env_override(vmap({
    {"SOLARDEMO_TEST_MOON_ENTID", idmap},
    {"SOLARDEMO_TEST_LIVE", Value("FALSE")},
    {"SOLARDEMO_TEST_EXPLAIN", Value("FALSE")}
  }));

  Value idmap_resolved = Helpers::toMapAny(getp(env, "SOLARDEMO_TEST_MOON_ENTID"));
  if (!idmap_resolved.is_map()) idmap_resolved = idmap;

  if (getp(idmap_resolved, "planet_id").is_undef()) {
    setp(idmap_resolved, "planet_id", getp(idmap_resolved, "planet01"));
  }

  bool live = getp(env, "SOLARDEMO_TEST_LIVE") == Value("TRUE");

  MoonSetup s;
  s.client = client;
  s.data = entity_data;
  s.idmap = idmap_resolved;
  s.env = env;
  s.live = live;
  s.synthetic_only = false;
  s.now = now_ms();
  return s;
}

static void moon_entity_instance() {
  auto testsdk = SolardemoSDK::testSDK();
  auto ent = testsdk->moon();
  ASSERT_EQ(ent->getName(), std::string("moon"), "entity name");
}


static void moon_entity_stream() {
  // stream() runs the list op through the full pipeline and returns the
  // result items. Seed two entities via test mode; with the streaming feature
  // active it yields the feature's incremental items, else it falls back to
  // the materialised items — either way every item is yielded.
  Value seed = vmap({{"entity", vmap({{"moon", vmap({
      {"strm01", vmap({{"id", Value("strm01")}})},
      {"strm02", vmap({{"id", Value("strm02")}})}})}})}});
  Value sdkopts = vmap({{"feature",
      vmap({{"streaming", vmap({{"active", Value(true)}})}})}});

  auto strsdk = SolardemoSDK::testSDK(seed, sdkopts);
  auto se = strsdk->moon();
  std::vector<Value> items = se->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)items.size(), 2, "stream yields both seeded items");

  auto plainsdk = SolardemoSDK::testSDK(seed, Value::undef());
  auto pe = plainsdk->moon();
  std::vector<Value> pitems = pe->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)pitems.size(), 2, "fallback stream yields both items");
}

static void moon_entity_basic() {
  auto setup = moon_basic_setup(Value::undef());
  std::string mode = setup.live ? "live" : "unit";
  for (const std::string& op : std::vector<std::string>{"create", "list", "update", "load", "remove"}) {
    auto sk = is_control_skipped("entityOp", std::string("moon.") + op, mode);
    if (sk.first) { std::cerr << "skip: " << (sk.second.empty()? "sdk-test-control.json" : sk.second) << "\n"; return; }
  }
  auto client = setup.client;
  // CREATE
  auto moon_ref01_ent = client->moon();
  Value moon_ref01_data = Helpers::toMapAny(getp(Struct::getpath(setup.data, {"new", "moon"}), "moon_ref01"));
  if (!moon_ref01_data.is_map()) moon_ref01_data = vmap();
  setp(moon_ref01_data, "planet_id", getp(setup.idmap, "planet01"));
  {
    Value moon_ref01_data_result = moon_ref01_ent->create(Struct::clone(moon_ref01_data), Value::undef())->data();
    moon_ref01_data = Helpers::toMapAny(moon_ref01_data_result);
    if (!moon_ref01_data.is_map()) moon_ref01_data = vmap();
    ASSERT_TRUE(moon_ref01_data.is_map(), "expected create result to be a map");
    ASSERT_TRUE(!getp(moon_ref01_data, "id").is_undef(), "expected created entity to have an id");
  }

  // LIST
  Value moon_ref01_match = vmap();
  setp(moon_ref01_match, "planet_id", getp(setup.idmap, "planet01"));
  auto moon_ref01_list_ents = moon_ref01_ent->list(Struct::clone(moon_ref01_match), Value::undef());
  // list resolves to one ENTITY per record; the flow asserts on the records.
  Value moon_ref01_list = vlist();
  for (const auto& e : moon_ref01_list_ents) { moon_ref01_list.as_list()->push_back(e->data()); }
  ASSERT_TRUE(moon_ref01_list.is_list(), "expected list result to be an array");
  {
    std::vector<Value> found = Struct::select(entity_list_to_data(moon_ref01_list), vmap({{"id", getp(moon_ref01_data, "id")}}));
    ASSERT_TRUE(!found.empty(), "expected to find created entity in list");
  }

  // UPDATE
  Value moon_ref01_data_up0_up = vmap();
  setp(moon_ref01_data_up0_up, "id", getp(moon_ref01_data, "id"));
  setp(moon_ref01_data_up0_up, "planet_id", getp(setup.idmap, "planet_id"));
  std::string moon_ref01_data_up0_markval = std::string("Mark01-moon_ref01_") + std::to_string(setup.now);
  setp(moon_ref01_data_up0_up, "kind", Value(moon_ref01_data_up0_markval));
  Value moon_ref01_resdata_up0_result = moon_ref01_ent->update(Struct::clone(moon_ref01_data_up0_up), Value::undef())->data();
  Value moon_ref01_resdata_up0 = Helpers::toMapAny(moon_ref01_resdata_up0_result);
  if (!moon_ref01_resdata_up0.is_map()) moon_ref01_resdata_up0 = vmap();
  ASSERT_TRUE(moon_ref01_resdata_up0.is_map(), "expected update result to be a map");
  ASSERT_EQ_VAL(getp(moon_ref01_resdata_up0, "id"), getp(moon_ref01_data_up0_up, "id"), "expected update result id to match");
  ASSERT_EQ_VAL(getp(moon_ref01_resdata_up0, "kind"), Value(moon_ref01_data_up0_markval), "expected kind to be updated");

  // LOAD
  Value moon_ref01_match_dt0 = vmap({{"id", getp(moon_ref01_data, "id")}});
  Value moon_ref01_data_dt0_loaded = moon_ref01_ent->load(Struct::clone(moon_ref01_match_dt0), Value::undef())->data();
  Value moon_ref01_data_dt0_load_result = Helpers::toMapAny(moon_ref01_data_dt0_loaded);
  ASSERT_TRUE(moon_ref01_data_dt0_load_result.is_map(), "expected load result to be a map");
  ASSERT_EQ_VAL(getp(moon_ref01_data_dt0_load_result, "id"), getp(moon_ref01_data, "id"), "expected load result id to match");

  // REMOVE
  {
    Value moon_ref01_match_rm0 = vmap({{"id", getp(moon_ref01_data, "id")}});
    moon_ref01_ent->remove(Struct::clone(moon_ref01_match_rm0), Value::undef());
  }

  // LIST
  Value moon_ref01_match_rt0 = vmap();
  setp(moon_ref01_match_rt0, "planet_id", getp(setup.idmap, "planet01"));
  auto moon_ref01_list_rt0_ents = moon_ref01_ent->list(Struct::clone(moon_ref01_match_rt0), Value::undef());
  // list resolves to one ENTITY per record; the flow asserts on the records.
  Value moon_ref01_list_rt0 = vlist();
  for (const auto& e : moon_ref01_list_rt0_ents) { moon_ref01_list_rt0.as_list()->push_back(e->data()); }
  ASSERT_TRUE(moon_ref01_list_rt0.is_list(), "expected list result to be an array");
  {
    std::vector<Value> found = Struct::select(entity_list_to_data(moon_ref01_list_rt0), vmap({{"id", getp(moon_ref01_data, "id")}}));
    ASSERT_TRUE(found.empty(), "expected removed entity to not be in list");
  }

}

int main() {
  T_RUN(moon_entity_instance);
  T_RUN(moon_entity_stream);
  T_RUN(moon_entity_basic);
  return sdktest::summary("moon_entity_test");
}
