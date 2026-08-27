# Solardemo SDK feature factory

defmodule Solardemo.Features do
  def make_feature(name) do
    case name do
      "test" -> Solardemo.Feature.Test.new()
      _ -> Solardemo.Feature.new()
    end
  end
end
