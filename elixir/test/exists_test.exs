defmodule VoxgigSolardemo.ExistsTest do
  use ExUnit.Case

  test "should create test sdk" do
    testsdk = VoxgigSolardemo.test()
    assert testsdk != nil
  end
end
