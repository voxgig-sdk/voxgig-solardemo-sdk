# VoxgigSolardemo SDK feature factory

use strict;
use warnings;

use File::Basename ();
use Cwd ();

my $__dir;
BEGIN { $__dir = File::Basename::dirname(Cwd::abs_path(__FILE__)) }
require(Cwd::abs_path("$__dir/feature/base_feature.pm"));
require(Cwd::abs_path("$__dir/feature/debug_feature.pm"));
require(Cwd::abs_path("$__dir/feature/idempotency_feature.pm"));
require(Cwd::abs_path("$__dir/feature/metrics_feature.pm"));
require(Cwd::abs_path("$__dir/feature/paging_feature.pm"));
require(Cwd::abs_path("$__dir/feature/ratelimit_feature.pm"));
require(Cwd::abs_path("$__dir/feature/retry_feature.pm"));
require(Cwd::abs_path("$__dir/feature/secrets_feature.pm"));
require(Cwd::abs_path("$__dir/feature/test_feature.pm"));
require(Cwd::abs_path("$__dir/feature/timeout_feature.pm"));

package VoxgigSolardemoFeatures;

sub make_feature {
  my ($name) = @_;
  $name = '' unless defined $name;
  return VoxgigSolardemoBaseFeature->new if 'base' eq $name;
  return VoxgigSolardemoDebugFeature->new if 'debug' eq $name;
  return VoxgigSolardemoIdempotencyFeature->new if 'idempotency' eq $name;
  return VoxgigSolardemoMetricsFeature->new if 'metrics' eq $name;
  return VoxgigSolardemoPagingFeature->new if 'paging' eq $name;
  return VoxgigSolardemoRatelimitFeature->new if 'ratelimit' eq $name;
  return VoxgigSolardemoRetryFeature->new if 'retry' eq $name;
  return VoxgigSolardemoSecretsFeature->new if 'secrets' eq $name;
  return VoxgigSolardemoTestFeature->new if 'test' eq $name;
  return VoxgigSolardemoTimeoutFeature->new if 'timeout' eq $name;
  return VoxgigSolardemoBaseFeature->new;
}

1;
