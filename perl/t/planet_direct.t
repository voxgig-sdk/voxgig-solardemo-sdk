#!perl
# Planet direct test

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Cwd ();

use VoxgigSolardemoSDK;
require(Cwd::abs_path("$FindBin::Bin/runner.pm"));

# main.kit.test.live.strict is true (the default is true): a live
# request that fails, or a live test missing an input it needs,
# fails the test.
# An account with no record for a test to read skips it either way.
use constant LIVE_STRICT => 1;

sub live_ok {
  my ($result) = @_;
  my $status = VoxgigSolardemoHelpers::to_int($result->{status});
  return !defined $result->{err} && $result->{ok} && $status >= 200 && $status < 300;
}

DIRECT_LIST: {
  my $setup = planet_direct_setup([
    { 'id' => 'direct01' },
    { 'id' => 'direct02' },
  ]);
  my ($_should_skip, $_reason) = VoxgigSolardemoTestRunner::is_control_skipped(
    'direct', 'direct-list-planet', $setup->{live} ? 'live' : 'unit');
  if ($_should_skip) {
    note($_reason || 'skipped via sdk-test-control.json');
    pass('direct-list-planet: skipped via sdk-test-control.json');
    last DIRECT_LIST;
  }
  my $client = $setup->{client};

  my $params = {};

  my $result = $client->direct({
    'path' => 'api/planet',
    'method' => 'GET',
    'params' => $params,
  });
  if ($setup->{live}) {
    if (!live_ok($result)) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-list-planet', 'Live list failed: ' . VoxgigSolardemoTestRunner::live_describe($result));
      last DIRECT_LIST;
    }
    if (!defined VoxgigSolardemoTestRunner::live_list($result->{data})) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-list-planet', 'Live list returned no list: ' . VoxgigSolardemoTestRunner::live_describe($result));
      last DIRECT_LIST;
    }
    pass('direct-list-planet: live ok');
  }
  else {
    ok(!defined $result->{err}, 'direct-list-planet: no error');
    ok($result->{ok}, 'direct-list-planet: ok');
    is(VoxgigSolardemoHelpers::to_int($result->{status}), 200, 'direct-list-planet: status');
    ok(Voxgig::Struct::islist($result->{data}), 'direct-list-planet: data is array');
    is(scalar @{ $result->{data} }, 2, 'direct-list-planet: data length');
    is(scalar @{ $setup->{calls} }, 1, 'direct-list-planet: 1 call');
  }
}

DIRECT_LOAD: {
  my $setup = planet_direct_setup({ 'id' => 'direct01' });
  my ($_should_skip, $_reason) = VoxgigSolardemoTestRunner::is_control_skipped(
    'direct', 'direct-load-planet', $setup->{live} ? 'live' : 'unit');
  if ($_should_skip) {
    note($_reason || 'skipped via sdk-test-control.json');
    pass('direct-load-planet: skipped via sdk-test-control.json');
    last DIRECT_LOAD;
  }
  my $client = $setup->{client};

  my $params = {};
  my $query = {};
  if ($setup->{live}) {
    my $list_result = $client->direct({
      'path' => 'api/planet',
      'method' => 'GET',
      'params' => {},
    });
    if (!live_ok($list_result)) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-load-planet', 'Live list discovery failed: ' . VoxgigSolardemoTestRunner::live_describe($list_result));
      last DIRECT_LOAD;
    }
    my $records = VoxgigSolardemoTestRunner::live_list($list_result->{data});
    if (!defined $records) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-load-planet', 'Live list discovery returned no list: ' . VoxgigSolardemoTestRunner::live_describe($list_result));
      last DIRECT_LOAD;
    }
    if (!@$records) {
      VoxgigSolardemoTestRunner::live_empty('direct-load-planet', 'The account has no planet record to load');
      last DIRECT_LOAD;
    }
    my $first = ref $records->[0] eq 'HASH' ? $records->[0] : {};
    my $found = $first->{'id'} // $first->{'id'};
    if (!defined $found) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-load-planet', 'Live load blocked: discovery returned no usable identity');
      last DIRECT_LOAD;
    }
    $params->{'id'} = $found;
  }
  else {
    $params->{'id'} = 'direct01';
  }

  my $result = $client->direct({
    'path' => 'api/planet/{id}',
    'method' => 'GET',
    'params' => $params,
    'query' => $query,
  });
  if ($setup->{live}) {
    if (!live_ok($result)) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-load-planet', 'Live load failed: ' . VoxgigSolardemoTestRunner::live_describe($result));
      last DIRECT_LOAD;
    }
    if (!defined $result->{data}) {
      VoxgigSolardemoTestRunner::live_miss(LIVE_STRICT, 'direct-load-planet', 'Live load returned no data: ' . VoxgigSolardemoTestRunner::live_describe($result));
      last DIRECT_LOAD;
    }
    pass('direct-load-planet: live ok');
  }
  else {
    ok(!defined $result->{err}, 'direct-load-planet: no error');
    ok($result->{ok}, 'direct-load-planet: ok');
    is(VoxgigSolardemoHelpers::to_int($result->{status}), 200, 'direct-load-planet: status');
    ok(defined $result->{data}, 'direct-load-planet: data');
    if (Voxgig::Struct::ismap($result->{data})) {
      is($result->{data}{id}, 'direct01', 'direct-load-planet: id');
    }
    is(scalar @{ $setup->{calls} }, 1, 'direct-load-planet: 1 call');
  }
}


sub planet_direct_setup {
  my ($mockres) = @_;
  VoxgigSolardemoTestRunner::load_env_local();

  my $calls = [];

  my $env = VoxgigSolardemoTestRunner::env_override({
    'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID' => {},
    'VOXGIG_SOLARDEMO_TEST_LIVE' => 'FALSE',
  });

  my $live = ((($env->{'VOXGIG_SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') ? 1 : 0;

  if ($live) {
    # live_client_options() FIRST so the generated fields below win:
    # sdk-test-control.json's test.client.options adds to the live client,
    # it does not redirect it (a later key wins in a Perl hash literal).
    my $client = VoxgigSolardemoSDK->new({
      %{ VoxgigSolardemoTestRunner::live_client_options() },
    });
    my $idmap = $env->{'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID'};
    return {
      'client' => $client,
      'calls' => $calls,
      'live' => 1,
      'idmap' => ref $idmap eq 'HASH' ? $idmap : {},
    };
  }

  my $mock_fetch = sub {
    my ($url, $init) = @_;
    push @$calls, { 'url' => $url, 'init' => $init };
    return ({
      'status' => 200,
      'statusText' => 'OK',
      'headers' => {},
      'json' => sub {
        return defined $mockres ? $mockres : { 'id' => 'direct01' };
      },
      'body' => 'mock',
    }, undef);
  };

  my $client = VoxgigSolardemoSDK->new({
    'base' => 'http://localhost:8080',
    'system' => {
      'fetch' => $mock_fetch,
    },
  });

  return {
    'client' => $client,
    'calls' => $calls,
    'live' => 0,
    'idmap' => {},
  };
}

done_testing();
