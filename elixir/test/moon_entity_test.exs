# Moon entity test (offline, mock transport)

defmodule VoxgigSolardemo.MoonEntityTest do
  use ExUnit.Case

  alias Voxgig.Struct, as: S

  test "should create instance" do
    sdk = VoxgigSolardemo.test()
    ent = VoxgigSolardemo.moon(sdk)
    assert ent != nil
  end

  test "should refuse an invalid request" do
    if VoxgigSolardemo.FeatureHarness.has_feature("validate") do
      client = VoxgigSolardemo.test(nil, S.jm(["feature", S.jm(["validate", S.jm(["active", true])])]))

      err =
        assert_raise VoxgigSolardemo.Error, fn ->
          VoxgigSolardemo.Entity.Moon.list(VoxgigSolardemo.moon(client), S.jm(["planet_id", 1]))
        end

      assert err.code == "validate_failed"
    end
  end
end
