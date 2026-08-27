# Moon entity test (offline, mock transport)

defmodule Solardemo.MoonEntityTest do
  use ExUnit.Case

  alias Voxgig.Struct, as: S
  alias Solardemo.Helpers, as: H
  alias Solardemo.Json

  defp fixture do
    Json.parse(File.read!("../.sdk/test/entity/moon/MoonTestData.json"))
  end

  defp mk_sdk do
    existing = H.or_(S.getpath(fixture(), "existing"), S.jm([]))
    Solardemo.test(S.jm(["entity", existing]))
  end

  defp first_id do
    existing = H.or_(S.getpath(fixture(), "existing.moon"), S.jm([]))
    keys = S.keysof(existing)
    if keys == [], do: nil, else: hd(keys)
  end

  test "should create instance" do
    sdk = Solardemo.test()
    ent = Solardemo.moon(sdk)
    assert ent != nil
  end

  test "should list records" do
    sdk = mk_sdk()
    ent = Solardemo.moon(sdk)
    # The op resolves to one ENTITY per record; the record is reached with
    # data_get. See AGENTS.md "Entity operations return ENTITIES".
    result = Solardemo.Entity.Moon.list(ent, S.jm([]))
    assert S.islist(result)
    if S.size(result) > 0 do
      Enum.each(0..(S.size(result) - 1), fn i ->
        assert S.ismap(Solardemo.EntityBase.data_get(S.getelem(result, i)))
      end)
    end
  end

  test "should load an existing record" do
    id = first_id()

    if id != nil do
      sdk = mk_sdk()
      ent = Solardemo.moon(sdk)
      loaded = Solardemo.Entity.Moon.load(ent, S.jm(["id", id]))
      rec = Solardemo.EntityBase.data_get(loaded)
      assert S.ismap(rec)
      assert S.getprop(rec, "id") == id
    end
  end

  test "should create then read back" do
    sdk = Solardemo.test(S.jm(["entity", S.jm(["moon", S.jm([])])]))
    ent = Solardemo.moon(sdk)
    created = Solardemo.Entity.Moon.create(ent, S.jm(["name", "test-create"]))
    made = Solardemo.EntityBase.data_get(created)
    assert S.ismap(made)
    assert S.getprop(made, "id") != nil
  end
end
