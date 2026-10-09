// Generated basic-flow test for the planet entity (model-driven,
// unit mode; mirrors the rust/go TestEntity generator).

#include "runner_support.hpp"

using namespace sdk;
using namespace sdk::rs;

struct PlanetSetup {
  std::shared_ptr<VoxgigSolardemoSDK> client;
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
  auto client = VoxgigSolardemoSDK::testSDK(options, extra);

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
    {"VOXGIG_SOLARDEMO_TEST_PLANET_ENTID", idmap},
    {"VOXGIG_SOLARDEMO_TEST_LIVE", Value("FALSE")},
    {"VOXGIG_SOLARDEMO_TEST_EXPLAIN", Value("FALSE")}
  }));

  Value idmap_resolved = Helpers::toMapAny(getp(env, "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID"));
  if (!idmap_resolved.is_map()) idmap_resolved = idmap;

  bool live = getp(env, "VOXGIG_SOLARDEMO_TEST_LIVE") == Value("TRUE");

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
  auto testsdk = VoxgigSolardemoSDK::testSDK();
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

  auto strsdk = VoxgigSolardemoSDK::testSDK(seed, sdkopts);
  auto se = strsdk->planet();
  std::vector<Value> items = se->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)items.size(), 2, "stream yields both seeded items");

  auto plainsdk = VoxgigSolardemoSDK::testSDK(seed, Value::undef());
  auto pe = plainsdk->planet();
  std::vector<Value> pitems = pe->stream("list", Value::undef(), Value::undef());
  ASSERT_EQ((int)pitems.size(), 2, "fallback stream yields both items");
}

static bool planet_has_feature(const std::string& name) {
  Value fm = Helpers::toMapAny(getp(sharedConfig(), "feature"));
  return fm.is_map() && !getp(fm, name).is_undef();
}

class PlanetFailHook : public BaseFeature {
public:
  int unexpected = 0;
  PlanetFailHook() : BaseFeature("failhook", "0.0.1", true) {}
  void preSpec(CtxPtr ctx) override {
    throw std::runtime_error("planet hook failed");
  }
  void preUnexpected(CtxPtr ctx) override {
    unexpected++;
  }
};

static void planet_entity_stream_error() {
  Value offline = vmap({{"net", vmap({{"offline", Value(true)}})}});
  std::string msg;
  try {
    VoxgigSolardemoSDK::testSDK(offline, Value::undef())->planet()
        ->stream("list", Value::undef(), Value::undef());
  } catch (const SdkErrorPtr& err) {
    msg = err->getMessage();
  }
  ASSERT_TRUE(msg.find("offline") != std::string::npos,
      "stream: a failed operation fails the stream");

  bool raised = false;
  try {
    VoxgigSolardemoSDK::testSDK(offline, Value::undef())->planet()
        ->stream("list", Value::undef(), vmap({{"ctrl", vmap({{"throw", Value(false)}})}}));
  } catch (const SdkErrorPtr&) {
    raised = true;
  }
  ASSERT_FALSE(raised, "stream: under throw false a failed stream ends");

  if (planet_has_feature("rbac")) {
    std::string code;
    try {
      VoxgigSolardemoSDK::testSDK(Value::undef(), vmap({{"feature", vmap({{"rbac",
          vmap({{"active", Value(true)}, {"deny", Value(true)}})}})}}))->planet()
          ->stream("list", Value::undef(), Value::undef());
    } catch (const SdkErrorPtr& err) {
      code = err->code;
    }
    ASSERT_EQ(code, std::string("rbac_denied"), "stream: a denied operation fails the stream");
  }
}

static void planet_entity_stream_ctrl() {
  Value explain = vmap();
  Value ctrl = vmap({{"explain", explain}});
  VoxgigSolardemoSDK::testSDK()->planet()->stream("list", Value::undef(), vmap({{"ctrl", ctrl}}));
  ASSERT_TRUE(getp(ctrl, "stream").is_undef(), "stream: the caller's ctrl gains no key");
  ASSERT_TRUE(!explain.as_map()->empty(), "stream: the caller's explain record is filled");
}

static void planet_entity_unexpected() {
  auto hook = std::make_shared<PlanetFailHook>();
  auto client = VoxgigSolardemoSDK::testSDK();
  client->getRootCtx()->utility->featureAdd(client->getRootCtx(), hook);

  std::string msg;
  try {
    client->planet()->list(Value::undef(), Value::undef());
  } catch (const SdkErrorPtr& err) {
    msg = err->getMessage();
  }
  ASSERT_TRUE(msg.find("hook failed") != std::string::npos, "a throwing hook fails the operation");
  ASSERT_TRUE(0 < hook->unexpected, "a throwing hook fires PreUnexpected");

  int fired = hook->unexpected;
  client->planet()->list(Value::undef(), vmap({{"throw", Value(false)}}));
  ASSERT_TRUE(fired < hook->unexpected, "under throw false PreUnexpected fires too");
}

static void planet_entity_validate() {
  if (!planet_has_feature("validate")) {
    std::cerr << "skip: feature not present in this SDK: validate\n";
    return;
  }
  auto vsdk = VoxgigSolardemoSDK::testSDK(Value::undef(), vmap({{"feature",
      vmap({{"validate", vmap({{"active", Value(true)}})}})}}));
  std::string code;
  try {
    vsdk->planet()->list(vmap({{"diameter", Value("x")}}), Value::undef());
  } catch (const SdkErrorPtr& err) {
    code = err->code;
  }
  ASSERT_EQ(code, std::string("validate_failed"), "an invalid request fails with validate_failed");
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
  T_RUN(planet_entity_stream_error);
  T_RUN(planet_entity_stream_ctrl);
  T_RUN(planet_entity_unexpected);
  T_RUN(planet_entity_validate);
  T_RUN(planet_entity_basic);
  return sdktest::summary("planet_entity_test");
}
