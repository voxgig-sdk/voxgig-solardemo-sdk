(* VoxgigSolardemo SDK: generated schemas. Do not edit.
 *
 * Built from the model: main.kit.optspec and each feature's config.options
 * for the option spec; entity fields{}.type for the entity specs.
 *
 * opt_spec_value () - the option spec make_options validates client options
 * against. entity_spec_value () - per-entity data and request specs, keyed by
 * entity name. Both parse once and memoise: the spec is read on every client
 * construction and never mutated, so a per-call parse would be pure waste.
 *
 * The returned values are SHARED: treat them as read-only. make_options
 * validates AGAINST the spec and writes into the options, never into it. *)

open Voxgig_struct

let optspec_data = "{\"allow\":{\"method\":\"GET,PUT,POST,PATCH,DELETE,OPTIONS\",\"op\":\"create,update,load,list,remove,command,direct,graphql\"},\"apikey\":\"\",\"auth\":{\"basic\":false,\"in\":\"\",\"name\":\"\",\"prefix\":\"\"},\"base\":\"http://localhost:8000\",\"clean\":{\"keys\":\"key,token,id\"},\"entity\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false,\"alias\":{}}},\"extend\":\"`$ANY`\",\"headers\":{\"`$CHILD`\":\"`$STRING`\"},\"prefix\":\"\",\"secret\":\"\",\"server\":{\"`$CHILD`\":\"\"},\"suffix\":\"\",\"system\":{\"fetch\":\"`$ANY`\"},\"test\":{\"active\":false,\"entity\":{\"`$OPEN`\":true}},\"utility\":{},\"feature\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false},\"debug\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"max\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"redact\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"onEntry\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"idempotency\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"header\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"methods\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"ops\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"keygen\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"metrics\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"paging\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"afterVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"cursorParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"firstVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"limitParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"pageParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"startPage\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"limit\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"ops\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"ratelimit\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"burst\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"rate\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"retry\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"factor\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"maxDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"minDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"retries\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"statuses\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"jitter\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"secrets\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"cache\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"exchange\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"name\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"providers\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"test\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"entity\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"net\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"]},\"`$NIL`\"],\"timeout\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"ms\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"clearTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"setTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"]}}"

let entityspec_data = "{}"

let optspec_memo : value option ref = ref None

let entityspec_memo : value option ref = ref None

let opt_spec_value () : value =
  match !optspec_memo with
  | Some v -> v
  | None ->
    let v = Sdk_json.json_read optspec_data in
    optspec_memo := Some v;
    v

let entity_spec_value () : value =
  match !entityspec_memo with
  | Some v -> v
  | None ->
    let v = Sdk_json.json_read entityspec_data in
    entityspec_memo := Some v;
    v
