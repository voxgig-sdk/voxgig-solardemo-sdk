// Solardemo SDK client. All transport and pipeline behaviour lives in the
// SdkClient base (core/types.hpp); this class binds the API-specific entity
// accessors and the test-mode constructor.

#ifndef SDK_CORE_CLIENT_HPP
#define SDK_CORE_CLIENT_HPP

#include <memory>

#include "../core/types.hpp"
#include "../entity/entities.hpp"

namespace sdk {

class SolardemoSDK : public SdkClient {
public:
  explicit SolardemoSDK(Value options = Value::undef()) : SdkClient(options) {}


  // Moon entity bound to this client.
  std::shared_ptr<MoonEntity> moon(Value entopts = Value::undef()) {
    return std::make_shared<MoonEntity>(this, entopts);
  }

  // Planet entity bound to this client.
  std::shared_ptr<PlanetEntity> planet(Value entopts = Value::undef()) {
    return std::make_shared<PlanetEntity>(this, entopts);
  }


  // testSDK builds a client in test mode: the test feature is activated,
  // installing the in-memory mock transport (no network activity).
  static std::shared_ptr<SolardemoSDK> testSDK() {
    return testSDK(Value::undef(), Value::undef());
  }

  static std::shared_ptr<SolardemoSDK> testSDK(Value testopts, Value sdkopts) {
    auto sdk = std::make_shared<SolardemoSDK>(SdkClient::testOptions(testopts, sdkopts));
    sdk->mode = "test";
    return sdk;
  }

  // Convenience no-arg constructor.
  static std::shared_ptr<SolardemoSDK> create() {
    return std::make_shared<SolardemoSDK>(Value::undef());
  }
};

using SolardemoSDKPtr = std::shared_ptr<SolardemoSDK>;

} // namespace sdk

#endif // SDK_CORE_CLIENT_HPP
