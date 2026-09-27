# Planet entity test (offline, mock transport)

defmodule VoxgigSolardemo.PlanetEntityTest do
  use ExUnit.Case

  alias Voxgig.Struct, as: S
  alias VoxgigSolardemo.Helpers, as: H
  alias VoxgigSolardemo.Json

  defp fixture do
    Json.parse(File.read!("../.sdk/test/entity/planet/PlanetTestData.json"))
  end

  defp mk_sdk do
    existing = H.or_(S.getpath(fixture(), "existing"), S.jm([]))
    VoxgigSolardemo.test(S.jm(["entity", existing]))
  end

  defp first_id do
    existing = H.or_(S.getpath(fixture(), "existing.planet"), S.jm([]))
    keys = S.keysof(existing)
    if keys == [], do: nil, else: hd(keys)
  end

  test "should create instance" do
    sdk = VoxgigSolardemo.test()
    ent = VoxgigSolardemo.planet(sdk)
    assert ent != nil
  end

  test "should list records" do
    sdk = mk_sdk()
    ent = VoxgigSolardemo.planet(sdk)
    # The op resolves to one ENTITY per record; the record is reached with
    # data_get. See AGENTS.md "Entity operations return ENTITIES".
    result = VoxgigSolardemo.Entity.Planet.list(ent, S.jm([]))
    assert S.islist(result)
    if S.size(result) > 0 do
      Enum.each(0..(S.size(result) - 1), fn i ->
        assert S.ismap(VoxgigSolardemo.EntityBase.data_get(S.getelem(result, i)))
      end)
    end
  end

  test "should load an existing record" do
    id = first_id()

    if id != nil do
      sdk = mk_sdk()
      ent = VoxgigSolardemo.planet(sdk)
      loaded = VoxgigSolardemo.Entity.Planet.load(ent, S.jm(["id", id]))
      rec = VoxgigSolardemo.EntityBase.data_get(loaded)
      assert S.ismap(rec)
      assert S.getprop(rec, "id") == id
    end
  end

  test "should create then read back" do
    sdk = VoxgigSolardemo.test(S.jm(["entity", S.jm(["planet", S.jm([])])]))
    ent = VoxgigSolardemo.planet(sdk)
    created = VoxgigSolardemo.Entity.Planet.create(ent, S.jm(["name", "test-create"]))
    made = VoxgigSolardemo.EntityBase.data_get(created)
    assert S.ismap(made)
    assert S.getprop(made, "id") != nil
  end
end
