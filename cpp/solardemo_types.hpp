// Typed reference models for the Solardemo SDK (C++).
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params. The C++ SDK runtime is Value-based, so these structs are
// DOCUMENTATION / convenience types only — the SDK neither includes nor
// requires this header. Array fields surface as std::vector<Value>, object
// fields as std::map<std::string, Value>, and any/null fields as sdk::Value.
// Optional (req:false) members are flagged with a trailing "// optional"
// comment. Do not edit by hand.

#ifndef SDK_SOLARDEMO_TYPES_HPP
#define SDK_SOLARDEMO_TYPES_HPP

#include <cstdint>
#include <map>
#include <string>
#include <vector>

#include "core/types.hpp"

namespace sdk {
namespace types {

struct Moon {
  double diameter;
  std::string id;
  std::string kind;
  std::string name;
  std::string planet_id;
};

struct MoonLoadMatch {
  std::string id;
  std::string planet_id;
};

struct MoonListMatch {
  std::string planet_id;
};

struct MoonCreateData {
  std::string planet_id;
  double diameter;
  std::string id;
  std::string kind;
  std::string name;
};

struct MoonUpdateData {
  std::string id;
  std::string planet_id;
  double diameter;  // optional
  std::string kind;  // optional
  std::string name;  // optional
};

struct MoonRemoveMatch {
  std::string id;
  std::string planet_id;
};

struct Planet {
  double diameter;
  bool forbid;  // optional
  std::string id;
  std::string kind;
  std::string name;
  bool ok;  // optional
  bool start;  // optional
  std::string state;  // optional
  bool stop;  // optional
  std::string why;  // optional
};

struct PlanetLoadMatch {
  std::string id;
};

struct PlanetListMatch {
  double diameter;  // optional
  bool forbid;  // optional
  std::string id;  // optional
  std::string kind;  // optional
  std::string name;  // optional
  bool ok;  // optional
  bool start;  // optional
  std::string state;  // optional
  bool stop;  // optional
  std::string why;  // optional
};

struct PlanetCreateData {
  double diameter;
  bool forbid;  // optional
  std::string id;
  std::string kind;
  std::string name;
  bool ok;  // optional
  bool start;  // optional
  std::string state;  // optional
  bool stop;  // optional
  std::string why;  // optional
};

struct PlanetUpdateData {
  std::string id;
  double diameter;  // optional
  bool forbid;  // optional
  std::string kind;  // optional
  std::string name;  // optional
  bool ok;  // optional
  bool start;  // optional
  std::string state;  // optional
  bool stop;  // optional
  std::string why;  // optional
};

struct PlanetRemoveMatch {
  std::string id;
};

} // namespace types
} // namespace sdk

#endif // SDK_SOLARDEMO_TYPES_HPP
