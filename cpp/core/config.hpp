// Generated API configuration (mirrors Config_java / core/config.go).

#ifndef SDK_CORE_CONFIG_HPP
#define SDK_CORE_CONFIG_HPP

#include <memory>
#include <string>
#include <vector>

#include "../core/struct.hpp"
#include "../core/types.hpp"
#include "../feature/base.hpp"
#include "../feature/debug.hpp"
#include "../feature/idempotency.hpp"
#include "../feature/metrics.hpp"
#include "../feature/paging.hpp"
#include "../feature/ratelimit.hpp"
#include "../feature/retry.hpp"
#include "../feature/secrets.hpp"
#include "../feature/test.hpp"
#include "../feature/timeout.hpp"

namespace sdk {

inline const char* config_json() {
  return
    "{\"main\":{\"name\":\"VoxgigSolardemo\",\"slug\":\"voxgig-solardemo\",\"version\":\"0.1.0\",\"target\":\"cpp\"},\"feature\":{\"debug\":{\"options\":{\"active\":false,\"max\":100,\"redact\":[\"authorization\",\"cookie\",\"set-cookie\",\"api-key\",\"apikey\",\"x-api-key\",\"idempotency-key\"]},\"optspec\":{\"now\":\"`$FUNCTION`\",\"onEntry\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"none\"},\"idempotency\":{\"options\":{\"active\":false,\"header\":\"Idempotency-Key\",\"methods\":[\"POST\",\"PUT\",\"PATCH\",\"DELETE\"],\"ops\":[\"create\",\"update\",\"remove\"]},\"optspec\":{\"keygen\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"none\"},\"metrics\":{\"options\":{\"active\":false},\"optspec\":{\"now\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"none\"},\"paging\":{\"options\":{\"active\":false,\"afterVar\":\"after\",\"cursorParam\":\"cursor\",\"firstVar\":\"first\",\"limitParam\":\"limit\",\"pageParam\":\"page\",\"startPage\":1},\"optspec\":{\"limit\":\"`$NUMBER`\",\"ops\":\"`$LIST`\"},\"strict\":false,\"transport\":\"none\"},\"ratelimit\":{\"options\":{\"active\":false,\"burst\":5,\"rate\":5},\"optspec\":{\"now\":\"`$FUNCTION`\",\"sleep\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"wrap\"},\"retry\":{\"options\":{\"active\":false,\"factor\":2,\"maxDelay\":2000,\"minDelay\":50,\"retries\":2,\"statuses\":[408,425,429,500,502,503,504]},\"optspec\":{\"jitter\":\"`$BOOLEAN`\",\"sleep\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"wrap\"},\"secrets\":{\"options\":{\"active\":false,\"cache\":true,\"exchange\":{\"active\":false,\"method\":\"POST\",\"path\":\"auth/token\",\"refresh\":\"\",\"request\":\"refresh_token\",\"response\":\"access_token\",\"retries\":1,\"statuses\":[401]},\"name\":\"apikey\",\"providers\":[]},\"optspec\":{},\"strict\":false,\"transport\":\"wrap\"},\"test\":{\"options\":{\"active\":false},\"optspec\":{\"entity\":\"`$MAP`\",\"net\":\"`$MAP`\"},\"strict\":false,\"transport\":\"base\"},\"timeout\":{\"options\":{\"active\":fal"
    "se,\"ms\":30000},\"optspec\":{\"clearTimer\":\"`$FUNCTION`\",\"setTimer\":\"`$FUNCTION`\"},\"strict\":false,\"transport\":\"wrap\"}},\"options\":{\"base\":\"http://localhost:8901\",\"headers\":{\"content-type\":\"application/json\"},\"entity\":{\"moon\":{},\"planet\":{}}},\"entity\":{\"moon\":{\"fields\":[{\"name\":\"diameter\",\"title\":\"Diameter\",\"type\":\"`$NUMBER`\",\"req\":true,\"format\":\"float\"},{\"name\":\"id\",\"title\":\"Id\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"kind\",\"title\":\"Kind\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"name\",\"title\":\"Name\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"planet_id\",\"title\":\"Planet Id\",\"type\":\"`$STRING`\",\"req\":true}],\"id\":{\"field\":\"id\",\"name\":\"id\"},\"name\":\"moon\",\"op\":{\"create\":{\"input\":\"data\",\"name\":\"create\",\"points\":[{\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/moon\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"planet_id\"},{\"lit\":\"moon\"}],\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\"],\"rename\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"planet_id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"planet_id\"]}}]},\"list\":{\"input\":\"data\",\"name\":\"list\",\"points\":[{\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}/moon\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"planet_id\"},{\"lit\":\"moon\"}],\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\"],\"rename\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"planet_id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"planet_id\"]}}]},\"load\":{\"input\":\"data\",\"name\":\"load\",\"points\":[{\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_"
    "id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"planet_id\"},{\"lit\":\"moon\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"moon_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true},{\"name\":\"planet_id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\",\"planet_id\"]}}]},\"remove\":{\"input\":\"data\",\"name\":\"remove\",\"points\":[{\"kind\":\"http\",\"method\":\"DELETE\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"planet_id\"},{\"lit\":\"moon\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"moon_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true},{\"name\":\"planet_id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\",\"planet_id\"]}}]},\"update\":{\"input\":\"data\",\"name\":\"update\",\"points\":[{\"kind\":\"http\",\"method\":\"PUT\",\"orig\":\"/api/planet/{planet_id}/moon/{moon_id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"planet_id\"},{\"lit\":\"moon\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{planet_id}\",\"moon\",\"{id}\"],\"rename\":{\"param\":{\"moon_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"moon_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true},{\"name\":\"planet_id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\",\"planet_id\"]}}]}},\"relations\":{\"ancestors\""
    ":[[\"$.main.kit.entity.planet\"]]}},\"planet\":{\"fields\":[{\"name\":\"diameter\",\"title\":\"Diameter\",\"type\":\"`$NUMBER`\",\"req\":true,\"format\":\"float\"},{\"name\":\"forbidReason\",\"title\":\"Forbid Reason\",\"type\":\"`$STRING`\",\"short\":\"Why the planet is forbidden, carried from the forbid action's `why`.\",\"readOnly\":true},{\"name\":\"forbidState\",\"title\":\"Forbid State\",\"type\":\"`$STRING`\",\"short\":\"Set by the forbid action, and absent until it first runs.\",\"readOnly\":true},{\"name\":\"id\",\"title\":\"Id\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"kind\",\"title\":\"Kind\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"name\",\"title\":\"Name\",\"type\":\"`$STRING`\",\"req\":true},{\"name\":\"terraformState\",\"title\":\"Terraform State\",\"type\":\"`$STRING`\",\"short\":\"Set by the terraform action, and absent until it first runs.\",\"readOnly\":true}],\"id\":{\"field\":\"id\",\"name\":\"id\"},\"name\":\"planet\",\"op\":{\"create\":{\"input\":\"data\",\"name\":\"create\",\"points\":[{\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/forbid\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"id\"},{\"lit\":\"forbid\"}],\"parts\":[\"api\",\"planet\",\"{id}\",\"forbid\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"$action\":\"forbid\",\"exist\":[\"id\"]}},{\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet/{planet_id}/terraform\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"id\"},{\"lit\":\"terraform\"}],\"parts\":[\"api\",\"planet\",\"{id}\",\"terraform\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":t"
    "rue}]},\"select\":{\"$action\":\"terraform\",\"exist\":[\"id\"]}},{\"kind\":\"http\",\"method\":\"POST\",\"orig\":\"/api/planet\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"}],\"parts\":[\"api\",\"planet\"],\"rename\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{},\"select\":{}}]},\"list\":{\"input\":\"data\",\"name\":\"list\",\"points\":[{\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"}],\"parts\":[\"api\",\"planet\"],\"rename\":{},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{},\"select\":{}}]},\"load\":{\"input\":\"data\",\"name\":\"load\",\"points\":[{\"kind\":\"http\",\"method\":\"GET\",\"orig\":\"/api/planet/{planet_id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\"]}}]},\"remove\":{\"input\":\"data\",\"name\":\"remove\",\"points\":[{\"kind\":\"http\",\"method\":\"DELETE\",\"orig\":\"/api/planet/{planet_id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{\"params\":[{\"name\":\"id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\"]}}]},\"update\":{\"input\":\"data\",\"name\":\"update\",\"points\":[{\"kind\":\"http\",\"method\":\"PUT\",\"orig\":\"/api/planet/{planet_id}\",\"segments\":[{\"lit\":\"api\"},{\"lit\":\"planet\"},{\"var\":\"id\"}],\"parts\":[\"api\",\"planet\",\"{id}\"],\"rename\":{\"param\":{\"planet_id\":\"id\"}},\"transform\":{\"req\":\"`reqdata`\",\"res\":\"`body`\"},\"args\":{"
    "\"params\":[{\"name\":\"id\",\"orig\":\"planet_id\",\"type\":\"`$STRING`\",\"kind\":\"param\",\"reqd\":true}]},\"select\":{\"exist\":[\"id\"]}}]}},\"relations\":{\"ancestors\":[]}}}}";
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
  if (name == "debug") return std::make_shared<DebugFeature>();
  if (name == "idempotency") return std::make_shared<IdempotencyFeature>();
  if (name == "metrics") return std::make_shared<MetricsFeature>();
  if (name == "paging") return std::make_shared<PagingFeature>();
  if (name == "ratelimit") return std::make_shared<RatelimitFeature>();
  if (name == "retry") return std::make_shared<RetryFeature>();
  if (name == "secrets") return std::make_shared<SecretsFeature>();
  if (name == "test") return std::make_shared<TestFeature>();
  if (name == "timeout") return std::make_shared<TimeoutFeature>();
  return std::make_shared<BaseFeature>();
}

// The plugin definitions the model selected per feature (type-erased; see
// feature/<name>/kinds.cpp). Empty for a feature with none, and for a
// model with no plugin-bearing feature active.
std::vector<std::shared_ptr<void>> secrets_plugins();

inline std::vector<std::shared_ptr<void>> featurePlugins(const std::string& name) {
  if (name == "secrets") return secrets_plugins();
  (void)name;
  return {};
}

} // namespace sdk

#endif // SDK_CORE_CONFIG_HPP
