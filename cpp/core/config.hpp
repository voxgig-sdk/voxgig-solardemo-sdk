// Generated API configuration (mirrors Config_java / core/config.go).

#ifndef SDK_CORE_CONFIG_HPP
#define SDK_CORE_CONFIG_HPP

#include <memory>
#include <string>

#include "../core/struct.hpp"
#include "../core/types.hpp"
#include "../feature/base.hpp"
#include "../feature/test.hpp"

namespace sdk {

inline const char* config_json() {
  return
    "{\"main\":{\"name\":\"Solardemo\",\"slug\":\"solardemo\",\"version\":\"0.1.0\",\"target\":\"cpp\"},\"feature\":{\"test\":{\"options\":{\"active\":false},\"transport\":\"base\"}},\"options\":{\"base\":\"http://localhost:8901\",\"headers\":{\"content-type\":\"application/json\"},\"entity\":{\"moon\":{},\"planet\":{}}},\"entity\":{\"moon\":{\"fields\":[{\"name\":\"diameter\",\"req\":true,\"type\":\"`$NUMBER`\"},{\"name\":\"id\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"kind\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"name\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"planet_id\",\"req\":true,\"type\":\"`$STRING`\"}],\"name\":\"moon\",\"op\":{\"create\":{\"input\":\"data\",\"name\":\"create\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"planet_id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/moon\",\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\"],\"select\":{\"exist\":[\"planet_id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"list\":{\"input\":\"data\",\"name\":\"list\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"planet_id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}/moon\",\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\"],\"select\":{\"exist\":[\"planet_id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"load\":{\"input\":\"data\",\"name\":\"load\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"moon_id\",\"reqd\":true,\"type\":\"`$STRING`\"},{\"kind\":\"param\",\"name\":\"planet_id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_id}\",\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"se"
    "lect\":{\"exist\":[\"id\",\"planet_id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"remove\":{\"input\":\"data\",\"name\":\"remove\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"moon_id\",\"reqd\":true,\"type\":\"`$STRING`\"},{\"kind\":\"param\",\"name\":\"planet_id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"DELETE\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_id}\",\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"select\":{\"exist\":[\"id\",\"planet_id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"update\":{\"input\":\"data\",\"name\":\"update\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"moon_id\",\"reqd\":true,\"type\":\"`$STRING`\"},{\"kind\":\"param\",\"name\":\"planet_id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"PUT\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_id}\",\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"select\":{\"exist\":[\"id\",\"planet_id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]}},\"relations\":{\"ancestors\":[[\"planet\"]]}},\"planet\":{\"fields\":[{\"name\":\"diameter\",\"req\":true,\"type\":\"`$NUMBER`\"},{\"name\":\"forbid\",\"type\":\"`$BOOLEAN`\"},{\"name\":\"id\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"kind\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"name\",\"req\":true,\"type\":\"`$STRING`\"},{\"name\":\"ok\",\"type\":\"`$BOOLEAN`\"},{\"name\":\"start\",\"type\":\"`$BOOLEAN`\"},{\"name\":\"state\",\"type\":\"`$STRING`\"},{\"name\":\"stop\",\"type\":\"`$BOOLEAN`\"},{\"name\":\"why\",\"type\":\"`$STRING`\"}],\"name\":\"planet\",\"op\":{\"create\":{\"input\":\"data\",\"name\":\"create\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\""
    "orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/forbid\",\"parts\":[\"api\",\"planet\",\"{id}\",\"forbid\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"select\":{\"$action\":\"forbid\",\"exist\":[\"id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}},{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/terraform\",\"parts\":[\"api\",\"planet\",\"{id}\",\"terraform\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"select\":{\"$action\":\"terraform\",\"exist\":[\"id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}},{\"args\":{},\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet\",\"parts\":[\"api\",\"planet\"],\"select\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"list\":{\"input\":\"data\",\"name\":\"list\",\"points\":[{\"args\":{},\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet\",\"parts\":[\"api\",\"planet\"],\"select\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"load\":{\"input\":\"data\",\"name\":\"load\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}\",\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"select\":{\"exist\":[\"id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"remove\":{\"input\":\"data\",\"name\":\"remove\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"DELETE\",\"orig\":\"/api/planet/{planet_id}\",\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"select\":{\"exist\":["
    "\"id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]},\"update\":{\"input\":\"data\",\"name\":\"update\",\"points\":[{\"args\":{\"params\":[{\"kind\":\"param\",\"name\":\"id\",\"orig\":\"planet_id\",\"reqd\":true,\"type\":\"`$STRING`\"}]},\"kind\":\"http\",\"method\":\"PUT\",\"orig\":\"/api/planet/{planet_id}\",\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"select\":{\"exist\":[\"id\"]},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"}}]}},\"relations\":{\"ancestors\":[]}}}}";
}

inline Value makeConfig() { return vs::parse_json(config_json()); }

// SHARED CONFIG (sdkgen rung L2).
//
// The SDK reads the config on every request and never writes to it, so one
// instance is shared by every client rather than rebuilt per client - this is
// the difference between parsing the embedded JSON once and once per client.
//
// A function-local static in an inline function is one object across every
// translation unit, and its initialisation is thread-safe by the standard.
// Value holds shared_ptr nodes, so copying the returned Value shares the
// structure rather than duplicating it.
//
// The result is SHARED: treat it as read-only. Callers that need to mutate
// should use makeConfig, which always parses a fresh copy.
inline const Value& sharedConfig() {
  static const Value shared = makeConfig();
  return shared;
}

inline FeaturePtr makeFeature(const std::string& name) {
  if (name == "test") return std::make_shared<TestFeature>();
  return std::make_shared<BaseFeature>();
}

} // namespace sdk

#endif // SDK_CORE_CONFIG_HPP
