# VoxgigSolardemo SDK feature factory

require_relative 'feature/base_feature'
require_relative 'feature/debug_feature'
require_relative 'feature/idempotency_feature'
require_relative 'feature/metrics_feature'
require_relative 'feature/paging_feature'
require_relative 'feature/ratelimit_feature'
require_relative 'feature/retry_feature'
require_relative 'feature/secrets_feature'
require_relative 'feature/test_feature'
require_relative 'feature/timeout_feature'


module VoxgigSolardemoFeatures
  def self.make_feature(name)
    case name
    when "base"
      VoxgigSolardemoBaseFeature.new
    when "debug"
      VoxgigSolardemoDebugFeature.new
    when "idempotency"
      VoxgigSolardemoIdempotencyFeature.new
    when "metrics"
      VoxgigSolardemoMetricsFeature.new
    when "paging"
      VoxgigSolardemoPagingFeature.new
    when "ratelimit"
      VoxgigSolardemoRatelimitFeature.new
    when "retry"
      VoxgigSolardemoRetryFeature.new
    when "secrets"
      VoxgigSolardemoSecretsFeature.new
    when "test"
      VoxgigSolardemoTestFeature.new
    when "timeout"
      VoxgigSolardemoTimeoutFeature.new
    else
      VoxgigSolardemoBaseFeature.new
    end
  end
end
