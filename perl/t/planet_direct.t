#!perl
# Planet direct test

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Cwd ();

use SolardemoSDK;
require(Cwd::abs_path("$FindBin::Bin/runner.pm"));

DIRECT_LIST: {
  my $setup = planet_direct_setup([
    { 'id' => 'direct01' },
    { 'id' => 'direct02' },
  ]);
  my ($_should_skip, $_reason) = SolardemoTestRunner::is_control_skipped(
    'direct', 'direct-list-planet', $setup->{live} ? 'live' : 'unit');
  if ($_should_skip) {
    note($_reason || 'skipped via sdk-test-control.json');
    pass('direct-list-planet: skipped via sdk-test-control.json');
    last DIRECT_LIST;
  }
  my $client = $setup->{client};

  my $result = $client->direct({
    'path' => 'api/planet',
    'method' => 'GET',
    'params' => {},
  });
  if ($setup->{live}) {
    # Live mode is lenient: synthetic IDs frequently 4xx and the list-
    # response shape varies wildly across public APIs. Skip rather than
    # fail when the call doesn't return a usable list.
    if (defined $result->{err}) {
      note("list call failed (likely synthetic IDs against live API): $result->{err}");
      pass('direct-list-planet: skipped (live)');
      last DIRECT_LIST;
    }
    unless ($result->{ok}) {
      note('list call not ok (likely synthetic IDs against live API)');
      pass('direct-list-planet: skipped (live)');
      last DIRECT_LIST;
    }
    my $status = SolardemoHelpers::to_int($result->{status});
    if ($status < 200 || $status >= 300) {
      note("expected 2xx status, got $status");
      pass('direct-list-planet: skipped (live)');
      last DIRECT_LIST;
    }
    pass('direct-list-planet: live ok');
  }
  else {
    ok(!defined $result->{err}, 'direct-list-planet: no error');
    ok($result->{ok}, 'direct-list-planet: ok');
    is(SolardemoHelpers::to_int($result->{status}), 200, 'direct-list-planet: status');
    ok(Voxgig::Struct::islist($result->{data}), 'direct-list-planet: data is array');
    is(scalar @{ $result->{data} }, 2, 'direct-list-planet: data length');
    is(scalar @{ $setup->{calls} }, 1, 'direct-list-planet: 1 call');
  }
}

DIRECT_LOAD: {
  my $setup = planet_direct_setup({ 'id' => 'direct01' });
  my ($_should_skip, $_reason) = SolardemoTestRunner::is_control_skipped(
    'direct', 'direct-load-planet', $setup->{live} ? 'live' : 'unit');
  if ($_should_skip) {
    note($_reason || 'skipped via sdk-test-control.json');
    pass('direct-load-planet: skipped via sdk-test-control.json');
    last DIRECT_LOAD;
  }
  if ($setup->{live}) {
    note('live direct-load needs real ID - set *_ENTID env var with real IDs to run');
    pass('direct-load-planet: skipped (live)');
    last DIRECT_LOAD;
  }
  my $client = $setup->{client};

  my $params = {};
  my $query = {};
  unless ($setup->{live}) {
    $params->{'id'} = 'direct01';
  }

  my $result = $client->direct({
    'path' => 'api/planet/{id}',
    'method' => 'GET',
    'params' => $params,
    'query' => $query,
  });
  if ($setup->{live}) {
    # Live mode is lenient: synthetic IDs frequently 4xx. Skip rather
    # than fail when the load endpoint isn't reachable with the IDs
    # we can construct from setup idmap.
    if (defined $result->{err}) {
      note("load call failed (likely synthetic IDs against live API): $result->{err}");
      pass('direct-load-planet: skipped (live)');
      last DIRECT_LOAD;
    }
    unless ($result->{ok}) {
      note('load call not ok (likely synthetic IDs against live API)');
      pass('direct-load-planet: skipped (live)');
      last DIRECT_LOAD;
    }
    my $status = SolardemoHelpers::to_int($result->{status});
    if ($status < 200 || $status >= 300) {
      note("expected 2xx status, got $status");
      pass('direct-load-planet: skipped (live)');
      last DIRECT_LOAD;
    }
    pass('direct-load-planet: live ok');
  }
  else {
    ok(!defined $result->{err}, 'direct-load-planet: no error');
    ok($result->{ok}, 'direct-load-planet: ok');
    is(SolardemoHelpers::to_int($result->{status}), 200, 'direct-load-planet: status');
    ok(defined $result->{data}, 'direct-load-planet: data');
    if (Voxgig::Struct::ismap($result->{data})) {
      is($result->{data}{id}, 'direct01', 'direct-load-planet: id');
    }
    is(scalar @{ $setup->{calls} }, 1, 'direct-load-planet: 1 call');
  }
}


sub planet_direct_setup {
  my ($mockres) = @_;
  SolardemoTestRunner::load_env_local();

  my $calls = [];

  my $env = SolardemoTestRunner::env_override({
    'SOLARDEMO_TEST_PLANET_ENTID' => {},
    'SOLARDEMO_TEST_LIVE' => 'FALSE',
  });

  my $live = ((($env->{'SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') ? 1 : 0;

  if ($live) {
    # live_client_options() FIRST so the generated fields below win:
    # sdk-test-control.json's test.client.options adds to the live client,
    # it does not redirect it (a later key wins in a Perl hash literal).
    my $client = SolardemoSDK->new({
      %{ SolardemoTestRunner::live_client_options() },
    });
    return {
      'client' => $client,
      'calls' => $calls,
      'live' => 1,
      'idmap' => {},
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

  my $client = SolardemoSDK->new({
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
