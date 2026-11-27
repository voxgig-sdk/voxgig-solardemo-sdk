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

let optspec_data = "{\"allow\":{\"method\":\"GET,PUT,POST,PATCH,DELETE,OPTIONS\",\"op\":\"create,update,patch,load,list,remove,command,direct,graphql\"},\"apikey\":\"\",\"auth\":{\"basic\":false,\"in\":\"\",\"name\":\"\",\"prefix\":\"\"},\"base\":\"http://localhost:8000\",\"clean\":{\"active\":true,\"hint\":\"0\",\"keys\":\"key,secret,token,password,passwd,authorization,cookie,credential,signature\",\"mask\":\"[redacted]\",\"min\":\"4\",\"values\":\"\"},\"entity\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false,\"alias\":{}}},\"extend\":\"`$ANY`\",\"headers\":{\"`$CHILD`\":\"`$STRING`\"},\"prefix\":\"\",\"secret\":\"\",\"server\":{\"`$CHILD`\":\"\"},\"suffix\":\"\",\"system\":{\"fetch\":\"`$ANY`\"},\"test\":{\"active\":false,\"entity\":{\"`$OPEN`\":true}},\"utility\":{},\"feature\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false},\"debug\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"max\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"redact\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"],\"now\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"],\"onEntry\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"idempotency\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"header\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"methods\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"],\"ops\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"],\"keygen\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"metrics\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"now\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"paging\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"afterVar\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"cursorParam\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"firstVar\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"limitParam\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"pageParam\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"startPage\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"limit\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"ops\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"ratelimit\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"burst\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"rate\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"now\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"],\"sleep\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"retry\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"factor\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"maxDelay\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"minDelay\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"retries\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"statuses\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"],\"jitter\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"sleep\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"secrets\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"cache\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"exchange\":[\"`$NOF`\",{\"min\":1},\"`$MAP`\",\"`$NIL`\"],\"name\":[\"`$NOF`\",{\"min\":1},\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"providers\":[\"`$NOF`\",{\"min\":1},\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"test\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"entity\":[\"`$NOF`\",{\"min\":1},\"`$MAP`\",\"`$NIL`\"],\"net\":[\"`$NOF`\",{\"min\":1},\"`$MAP`\",\"`$NIL`\"]},\"`$NIL`\"],\"timeout\":[\"`$NOF`\",{\"min\":1},{\"`$OPEN`\":true,\"active\":[\"`$NOF`\",{\"min\":1},\"`$BOOLEAN`\",\"`$NIL`\"],\"ms\":[\"`$NOF`\",{\"min\":1},\"`$NUMBER`\",\"`$NIL`\"],\"clearTimer\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"],\"now\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"],\"setTimer\":[\"`$NOF`\",{\"min\":1},\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"]}}"

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
