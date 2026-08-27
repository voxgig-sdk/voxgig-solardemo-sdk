// Generated basic-flow test for the planet entity (model-driven,
// unit mode; mirrors the rust/go TestEntity generator).

#include "runner_support.hpp"

using namespace sdk;
using namespace sdk::rs;

struct PlanetSetup {
  std::shared_ptr<SolardemoSDK> client;
  Value data;
  Value idmap;
  Value env;
  bool live = false;
  bool synthetic_only = false;
  long long now = 0;
};

static PlanetSetup planet_basic_setup(const Value& extra) {
  load_env_local();

  std::string entity_data_file = "../.sdk/test/entity/planet/PlanetTestData.json";
  Value entity_data = vs::parse_json(read_file(entity_data_file));

  Value options = vmap({{"entity", getp(entity_data, "existing")}});
  auto client = SolardemoSDK::testSDK(options, extra);

  // idmap via transform (upper-cased id name synthetics), matching the donors.
  Value idmap = Struct::transform(
      vlist({Value("planet01"), Value("planet02"), Value("planet03")}),
      vmap({{"`$PACK`", vlist({
        Value(""),
        vmap({
          {"`$KEY`", Value("`$COPY`")},
          {"`$VAL`", vlist({Value("`$FORMAT`"), Value("upper"), Value("`$COPY`")})}
        })
      })}}));
  if (!idmap.is_map()) idmap = vmap();

  Value env = env_override(vmap({
    {"SOLARDEMO_TEST_PLANET_ENTID", idmap},
    {"SOLARDEMO_TEST_LIVE", Value("FALSE")},
    {"SOLARDEMO_TEST_EXPLAIN", Value("FALSE")}
  }));

  Value idmap_resolved = Helpers::toMapAny(getp(env, "SOLARDEMO_TEST_PLANET_ENTID"));
  if (!idmap_resolved.is_map()) idmap_resolved = idmap;

  bool live = getp(env, "SOLARDEMO_TEST_LIVE") == Value("TRUE");

  PlanetSetup s;
  s.client = client;
  s.data = entity_data;
  s.idmap = idmap_resolved;
  s.env = env;
  s.live = live;
  s.synthetic_only = false;
  s.now = now_ms();
  return s;
}

static void planet_entity_instance() {
  auto testsdk = SolardemoSDK::testSDK();
  auto ent = testsdk->planet();
  ASSERT_EQ(ent->getName(), std::string("planet"), "entity name");
}


static void planet_entity_stream() {
  // stream() runs the list op through the full pipeline and returns the
  // result items. Seed two entities via test mode; with the streaming feature
  // active it yields the feature's incremental items, else it falls back to
  // the materialised items — either way every item is yielded.
  Value seed = vmap({{"entity", vmap({{"planet", vmap({
      {"strm01", vmap({{"id", Value("strm01")}})},
      {"strm02", vmap({{"id", Value("strm02")}})}})}})}});
  Value sdkopts = vmap({{"feature",
      vmap({{"streaming", vmap({{"active", Value(true)}})}})}});

  auto strsdk = SolardemoSDK::testSDK(seed, sdkopts);
  auto se = strsdk->planet();
  std::vector<Value> items = se->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)items.size(), 2, "stream yields both seeded items");

  auto plainsdk = SolardemoSDK::testSDK(seed, Value::undef());
  auto pe = plainsdk->planet();
  std::vector<Value> pitems = pe->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)pitems.size(), 2, "fallback stream yields both items");
}

static void planet_entity_basic() {
  auto setup = planet_basic_setup(Value::undef());
  std::string mode = setup.live ? "live" : "unit";
  for (const std::string& op : std::vector<std::string>{"create", "list", "update", "load", "remove"}) {
    auto sk = is_control_skipped("entityOp", std::string("planet.") + op, mode);
    if (sk.first) { std::cerr << "skip: " << (sk.second.empty()? "sdk-test-control.json" : sk.second) << "\n"; return; }
  }
  auto client = setup.client;
  // CREATE
  auto planet_ref01_ent = client->planet();
  Value planet_ref01_data = Helpers::toMapAny(getp(Struct::getpath(setup.data, {"new", "planet"}), "planet_ref01"));
  if (!planet_ref01_data.is_map()) planet_ref01_data = vmap();
  {
    Value planet_ref01_data_result = planet_ref01_ent->create(Struct::clone(planet_ref01_data), Value::undef())->data();
    planet_ref01_data = Helpers::toMapAny(planet_ref01_data_result);
    if (!planet_ref01_data.is_map()) planet_ref01_data = vmap();
    ASSERT_TRUE(planet_ref01_data.is_map(), "expected create result to be a map");
    ASSERT_TRUE(!getp(planet_ref01_data, "id").is_undef(), "expected created entity to have an id");
  }

  // LIST
  Value planet_ref01_match = vmap();
  auto planet_ref01_list_ents = planet_ref01_ent->list(Struct::clone(planet_ref01_match), Value::undef());
  // list resolves to one ENTITY per record; the flow asserts on the records.
  Value planet_ref01_list = vlist();
  for (const auto& e : planet_ref01_list_ents) { planet_ref01_list.as_list()->push_back(e->data()); }
  ASSERT_TRUE(planet_ref01_list.is_list(), "expected list result to be an array");
  {
    std::vector<Value> found = Struct::select(entity_list_to_data(planet_ref01_list), vmap({{"id", getp(planet_ref01_data, "id")}}));
    ASSERT_TRUE(!found.empty(), "expected to find created entity in list");
  }

  // UPDATE
  Value planet_ref01_data_up0_up = vmap();
  setp(planet_ref01_data_up0_up, "id", getp(planet_ref01_data, "id"));
  std::string planet_ref01_data_up0_markval = std::string("Mark01-planet_ref01_") + std::to_string(setup.now);
  setp(planet_ref01_data_up0_up, "kind", Value(planet_ref01_data_up0_markval));
  Value planet_ref01_resdata_up0_result = planet_ref01_ent->update(Struct::clone(planet_ref01_data_up0_up), Value::undef())->data();
  Value planet_ref01_resdata_up0 = Helpers::toMapAny(planet_ref01_resdata_up0_result);
  if (!planet_ref01_resdata_up0.is_map()) planet_ref01_resdata_up0 = vmap();
  ASSERT_TRUE(planet_ref01_resdata_up0.is_map(), "expected update result to be a map");
  ASSERT_EQ_VAL(getp(planet_ref01_resdata_up0, "id"), getp(planet_ref01_data_up0_up, "id"), "expected update result id to match");
  ASSERT_EQ_VAL(getp(planet_ref01_resdata_up0, "kind"), Value(planet_ref01_data_up0_markval), "expected kind to be updated");

  // LOAD
  Value planet_ref01_match_dt0 = vmap({{"id", getp(planet_ref01_data, "id")}});
  Value planet_ref01_data_dt0_loaded = planet_ref01_ent->load(Struct::clone(planet_ref01_match_dt0), Value::undef())->data();
  Value planet_ref01_data_dt0_load_result = Helpers::toMapAny(planet_ref01_data_dt0_loaded);
  ASSERT_TRUE(planet_ref01_data_dt0_load_result.is_map(), "expected load result to be a map");
  ASSERT_EQ_VAL(getp(planet_ref01_data_dt0_load_result, "id"), getp(planet_ref01_data, "id"), "expected load result id to match");

  // REMOVE
  {
    Value planet_ref01_match_rm0 = vmap({{"id", getp(planet_ref01_data, "id")}});
    planet_ref01_ent->remove(Struct::clone(planet_ref01_match_rm0), Value::undef());
  }

  // LIST
  Value planet_ref01_match_rt0 = vmap();
  auto planet_ref01_list_rt0_ents = planet_ref01_ent->list(Struct::clone(planet_ref01_match_rt0), Value::undef());
  // list resolves to one ENTITY per record; the flow asserts on the records.
  Value planet_ref01_list_rt0 = vlist();
  for (const auto& e : planet_ref01_list_rt0_ents) { planet_ref01_list_rt0.as_list()->push_back(e->data()); }
  ASSERT_TRUE(planet_ref01_list_rt0.is_list(), "expected list result to be an array");
  {
    std::vector<Value> found = Struct::select(entity_list_to_data(planet_ref01_list_rt0), vmap({{"id", getp(planet_ref01_data, "id")}}));
    ASSERT_TRUE(found.empty(), "expected removed entity to not be in list");
  }

}

int main() {
  T_RUN(planet_entity_instance);
  T_RUN(planet_entity_stream);
  T_RUN(planet_entity_basic);
  return sdktest::summary("planet_entity_test");
}
