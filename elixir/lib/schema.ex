# VoxgigSolardemo Elixir SDK: generated schemas. Do not edit.
#
# Generated from the model: `main.kit.optspec` and each feature's
# `config.options` for OPTSPEC; entity `fields{}.type` for ENTITYSPEC.

defmodule VoxgigSolardemo.Schema do
  @optspec_data "{\"allow\":{\"method\":\"GET,PUT,POST,PATCH,DELETE,OPTIONS\",\"op\":\"create,update,patch,load,list,remove,command,direct,graphql\"},\"apikey\":\"\",\"auth\":{\"basic\":false,\"in\":\"\",\"name\":\"\",\"prefix\":\"\"},\"base\":\"http://localhost:8000\",\"clean\":{\"active\":true,\"hint\":\"0\",\"keys\":\"key,secret,token,password,passwd,authorization,cookie,credential,signature\",\"mask\":\"[redacted]\",\"min\":\"4\",\"values\":\"\"},\"entity\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false,\"alias\":{}}},\"extend\":\"`$ANY`\",\"headers\":{\"`$CHILD`\":\"`$STRING`\"},\"prefix\":\"\",\"secret\":\"\",\"server\":{\"`$CHILD`\":\"\"},\"suffix\":\"\",\"system\":{\"fetch\":\"`$ANY`\"},\"test\":{\"active\":false,\"entity\":{\"`$OPEN`\":true}},\"utility\":{},\"feature\":{\"`$CHILD`\":{\"`$OPEN`\":true,\"active\":false},\"debug\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"max\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"redact\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"onEntry\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"idempotency\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"header\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"methods\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"ops\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"keygen\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"metrics\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"paging\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"afterVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"cursorParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"firstVar\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"limitParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"pageParam\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"startPage\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"limit\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"ops\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"ratelimit\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"burst\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"rate\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"retry\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"factor\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"maxDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"minDelay\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"retries\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"statuses\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"],\"jitter\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"sleep\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"],\"secrets\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"cache\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"exchange\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"name\":[\"`$ONE`\",\"`$STRING`\",[\"`$EXACT`\",\"\"],\"`$NIL`\"],\"providers\":[\"`$ONE`\",\"`$LIST`\",\"`$NIL`\"]},\"`$NIL`\"],\"test\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"entity\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"],\"net\":[\"`$ONE`\",\"`$MAP`\",\"`$NIL`\"]},\"`$NIL`\"],\"timeout\":[\"`$ONE`\",{\"`$OPEN`\":true,\"active\":[\"`$ONE`\",\"`$BOOLEAN`\",\"`$NIL`\"],\"ms\":[\"`$ONE`\",\"`$NUMBER`\",\"`$NIL`\"],\"clearTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"now\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"],\"setTimer\":[\"`$ONE`\",\"`$FUNCTION`\",\"`$NIL`\"]},\"`$NIL`\"]}}"

  @entityspec_data "{}"

  # Parsed once per VM and held in :persistent_term. The parse yields struct
  # nodes, which are handles into this VM's heap, so a compile-time literal
  # would point into the heap of whichever VM compiled the module.
  def optspec, do: memo(:optspec, @optspec_data)

  def entityspec, do: memo(:entityspec, @entityspec_data)

  defp memo(name, data) do
    key = {__MODULE__, name}

    case :persistent_term.get(key, nil) do
      nil ->
        spec = VoxgigSolardemo.Json.parse(data)
        :persistent_term.put(key, spec)
        spec

      spec ->
        spec
    end
  end
end
