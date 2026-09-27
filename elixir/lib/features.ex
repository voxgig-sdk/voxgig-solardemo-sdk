# VoxgigSolardemo SDK feature factory

defmodule VoxgigSolardemo.Features do
  def make_feature(name) do
    case name do
      "debug" -> VoxgigSolardemo.Feature.Debug.new()
      "idempotency" -> VoxgigSolardemo.Feature.Idempotency.new()
      "metrics" -> VoxgigSolardemo.Feature.Metrics.new()
      "paging" -> VoxgigSolardemo.Feature.Paging.new()
      "ratelimit" -> VoxgigSolardemo.Feature.Ratelimit.new()
      "retry" -> VoxgigSolardemo.Feature.Retry.new()
      "secrets" -> VoxgigSolardemo.Feature.Secrets.new()
      "test" -> VoxgigSolardemo.Feature.Test.new()
      "timeout" -> VoxgigSolardemo.Feature.Timeout.new()
      _ -> VoxgigSolardemo.Feature.new()
    end
  end
end
