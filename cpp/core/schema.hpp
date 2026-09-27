// VoxgigSolardemo SDK: generated schemas. Do not edit.
//
// Built from the model: `main.kit.optspec` and each feature's
// `config.options` for the option spec; entity `fields{}.type` for the
// entity specs.

#ifndef SDK_CORE_SCHEMA_HPP
#define SDK_CORE_SCHEMA_HPP

#include "../core/struct.hpp"

namespace sdk {

inline const char* optspec_json() {
  return
    "{\"allow\":{\"method\":\"GET,PUT,POST,PATCH,DELETE,OPTIONS\",\"op\":\"create,update,load,list,remove,command,direct,graphql\"},\"apikey\":\"\",\"auth\":{\"basic\":false,\"in\":\"\",\"name\":\"\",\"prefix\":\"\"},\"base\":\"http://localhost:8000\",\"clean\":{\"keys\":\"key,token,id\"},\"entity\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false,\"alias\":{}}},\"extend\":\"`$ANY`\",\"headers\":{\"`$CHILD`\":\"`$STRING`\"},\"prefix\":\"\",\"secret\":\"\",\"server\":{\"`$CHILD`\":\"\"},\"suffix\":\"\",\"system\":{\"fetch\":\"`$ANY`\"},\"test\":{\"active\":false,\"entity\":{\"`$OPEN`\":true}},\"utility\":{},\"feature\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false},\"debug\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"max\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"redact\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"onEntry\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"idempotency\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"header\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"methods\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"ops\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"keygen\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"metrics\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"paging\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"afterVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"cursorParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"firstVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"limitParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"pageParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"startPage\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"limit\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"ops\""
    ":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"ratelimit\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"burst\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"rate\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"retry\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"factor\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"maxDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"minDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"retries\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"statuses\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"jitter\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"secrets\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"cache\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"exchange\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"name\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"providers\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"test\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"entity\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"net\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"]},\"`$NIL`\"],\"timeout\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"ms\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"clearTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"setTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"]}}";
}

inline const char* entityspec_json() {
  return
    "{}";
}

// SHARED SPECS, the shape sharedConfig uses and for the same reasons: the
// spec is read on every client construction and never mutated, so a per-call
// parse would be pure waste. A function-local static in an inline function is
// one object across every translation unit, and its initialisation is
// thread-safe by the standard.
//
// The results are SHARED: treat them as read-only. makeOptions validates
// AGAINST the spec and writes into the options, never into the spec.
inline const Value& sharedOptspec() {
  static const Value shared = vs::parse_json(optspec_json());
  return shared;
}

inline const Value& sharedEntityspec() {
  static const Value shared = vs::parse_json(entityspec_json());
  return shared;
}

}  // namespace sdk

#endif  // SDK_CORE_SCHEMA_HPP
