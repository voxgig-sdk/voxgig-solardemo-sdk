defmodule Solardemo.ExistsTest do
  use ExUnit.Case

  test "should create test sdk" do
    testsdk = Solardemo.test()
    assert testsdk != nil
  end
end
