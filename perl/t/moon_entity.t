#!perl
# Moon entity test

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Cwd ();

use SolardemoSDK;
require(Cwd::abs_path("$FindBin::Bin/runner.pm"));

{
  my $testsdk = SolardemoSDK->test(undef, undef);
  my $ent = $testsdk->Moon(undef);
  ok(defined $ent, 'moon: create instance');
}

BASIC_FLOW: {
  my $setup = moon_basic_setup(undef);
  my $_live = $setup->{live} ? 1 : 0;
  # Per-op sdk-test-control.json skip.
  for my $_op (('create', 'list', 'update', 'load', 'remove')) {
    my ($_should_skip, $_reason) = SolardemoTestRunner::is_control_skipped(
      'entityOp', "moon." . $_op, $_live ? 'live' : 'unit');
    if ($_should_skip) {
      note($_reason || 'skipped via sdk-test-control.json');
      pass('moon: basic flow skipped via sdk-test-control.json');
      last BASIC_FLOW;
    }
  }
  # The basic flow consumes synthetic IDs from the fixture. In live mode
  # without an *_ENTID env override, those IDs hit the live API and 4xx.
  if ($setup->{synthetic_only}) {
    note('live entity test uses synthetic IDs from fixture - set SOLARDEMO_TEST_MOON_ENTID JSON to run live');
    pass('moon: basic flow skipped (synthetic IDs only)');
    last BASIC_FLOW;
  }
  my $client = $setup->{client};
  my %V;

  # CREATE
  $V{moon_ref01_ent} = $client->Moon(undef);
  $V{moon_ref01_data} = SolardemoHelpers::to_map(SolardemoHelpers::gp(
    SolardemoHelpers::gpath($setup->{data}, 'new.moon'), 'moon_ref01'));
  $V{moon_ref01_data}{'planet_id'} = $setup->{idmap}{'planet01'};

  $V{moon_ref01_data_result} = $V{moon_ref01_ent}->create($V{moon_ref01_data}, undef);
  $V{moon_ref01_data} = SolardemoHelpers::to_map(ref($V{moon_ref01_data_result}) && $V{moon_ref01_data_result}->can('data_get') ? $V{moon_ref01_data_result}->data_get : $V{moon_ref01_data_result});
  ok(defined $V{moon_ref01_data}, 'moon create: data');
  ok(defined $V{moon_ref01_data}{id}, 'moon create: id');

  # LIST
  $V{moon_ref01_match} = {
    'planet_id' => $setup->{idmap}{'planet01'},
  };

  $V{moon_ref01_list_result} = $V{moon_ref01_ent}->list($V{moon_ref01_match}, undef);
  ok(Voxgig::Struct::islist($V{moon_ref01_list_result}), 'moon list: is array');

  $V{found_item} = Voxgig::Struct::select(
    SolardemoTestRunner::entity_list_to_data($V{moon_ref01_list_result}),
    { 'id' => $V{moon_ref01_data}{id} });
  ok(!Voxgig::Struct::isempty($V{found_item}), 'moon list: item exists');

  # UPDATE
  $V{moon_ref01_data_up0_up} = {
    'id' => $V{moon_ref01_data}{id},
    'planet_id' => $setup->{idmap}{'planet_id'},
  };

  $V{moon_ref01_markdef_up0_name} = 'kind';
  $V{moon_ref01_markdef_up0_value} = 'Mark01-moon_ref01_' . $setup->{now};
  $V{moon_ref01_data_up0_up}{ $V{moon_ref01_markdef_up0_name} } = $V{moon_ref01_markdef_up0_value};

  $V{moon_ref01_resdata_up0_result} = $V{moon_ref01_ent}->update($V{moon_ref01_data_up0_up}, undef);
  $V{moon_ref01_resdata_up0} = SolardemoHelpers::to_map(ref($V{moon_ref01_resdata_up0_result}) && $V{moon_ref01_resdata_up0_result}->can('data_get') ? $V{moon_ref01_resdata_up0_result}->data_get : $V{moon_ref01_resdata_up0_result});
  ok(defined $V{moon_ref01_resdata_up0}, 'moon update: data');
  is($V{moon_ref01_resdata_up0}{id}, $V{moon_ref01_data_up0_up}{id}, 'moon update: id');
  is($V{moon_ref01_resdata_up0}{ $V{moon_ref01_markdef_up0_name} }, $V{moon_ref01_markdef_up0_value}, 'moon update: mark');

  # LOAD
  $V{moon_ref01_match_dt0} = {
    'id' => $V{moon_ref01_data}{id},
  };
  $V{moon_ref01_data_dt0_loaded} = $V{moon_ref01_ent}->load($V{moon_ref01_match_dt0}, undef);
  $V{moon_ref01_data_dt0_load_result} = SolardemoHelpers::to_map(ref($V{moon_ref01_data_dt0_loaded}) && $V{moon_ref01_data_dt0_loaded}->can('data_get') ? $V{moon_ref01_data_dt0_loaded}->data_get : $V{moon_ref01_data_dt0_loaded});
  ok(defined $V{moon_ref01_data_dt0_load_result}, 'moon load: data');
  is($V{moon_ref01_data_dt0_load_result}{id}, $V{moon_ref01_data}{id}, 'moon load: id');

  # REMOVE
  $V{moon_ref01_match_rm0} = {
    'id' => $V{moon_ref01_data}{id},
  };
  $V{moon_ref01_ent}->remove($V{moon_ref01_match_rm0}, undef);
  pass('moon remove: completed');

  # LIST
  $V{moon_ref01_match_rt0} = {
    'planet_id' => $setup->{idmap}{'planet01'},
  };

  $V{moon_ref01_list_rt0_result} = $V{moon_ref01_ent}->list($V{moon_ref01_match_rt0}, undef);
  ok(Voxgig::Struct::islist($V{moon_ref01_list_rt0_result}), 'moon list: is array');

  $V{not_found_item} = Voxgig::Struct::select(
    SolardemoTestRunner::entity_list_to_data($V{moon_ref01_list_rt0_result}),
    { 'id' => $V{moon_ref01_data}{id} });
  ok(Voxgig::Struct::isempty($V{not_found_item}), 'moon list: item not exists');

}

sub moon_basic_setup {
  my ($extra) = @_;
  SolardemoTestRunner::load_env_local();

  my $entity_data_file = Cwd::abs_path(
    "$FindBin::Bin/../../.sdk/test/entity/moon/MoonTestData.json");
  my $entity_data = do {
    open my $fh, '<:raw', $entity_data_file or die "Cannot open $entity_data_file: $!";
    local $/;
    Voxgig::Struct::parse_json(<$fh>);
  };

  my $options = {};
  $options->{entity} = $entity_data->{existing};

  my $client = SolardemoSDK->test($options, $extra);

  # Generate idmap via transform.
  my $idmap = Voxgig::Struct::transform(
    ['moon01', 'moon02', 'moon03', 'planet01', 'planet02', 'planet03'],
    {
      '`$PACK`' => ['', {
        '`$KEY`' => '`$COPY`',
        '`$VAL`' => ['`$FORMAT`', 'upper', '`$COPY`'],
      }],
    }
  );

  # Detect ENTID env override before env_override consumes it. When live
  # mode is on without a real override, the basic test runs against
  # synthetic IDs from the fixture and 4xx's. Surface this so the test can
  # skip.
  my $entid_env_raw = $ENV{'SOLARDEMO_TEST_MOON_ENTID'};
  my $idmap_overridden = (defined $entid_env_raw && $entid_env_raw =~ /^\s*\{/) ? 1 : 0;

  my $env = SolardemoTestRunner::env_override({
    'SOLARDEMO_TEST_MOON_ENTID' => $idmap,
    'SOLARDEMO_TEST_LIVE' => 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN' => 'FALSE',
  });

  my $idmap_resolved = SolardemoHelpers::to_map($env->{'SOLARDEMO_TEST_MOON_ENTID'});
  if (!defined $idmap_resolved) {
    $idmap_resolved = SolardemoHelpers::to_map($idmap);
  }
  if (!defined $idmap_resolved->{'planet_id'}) {
    $idmap_resolved->{'planet_id'} = $idmap_resolved->{'planet01'};
  }

  if ((($env->{'SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') {
    my $merged_opts = Voxgig::Struct::merge([
      # FIRST, so the generated fields below win: sdk-test-control.json's
      # test.client.options adds to the live client, it does not redirect it.
      SolardemoTestRunner::live_client_options(),
      {
      },
      (Voxgig::Struct::ismap($extra) ? $extra : {}),
    ]);
    $client = SolardemoSDK->new(SolardemoHelpers::to_map($merged_opts));
  }

  my $live = ((($env->{'SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') ? 1 : 0;
  return {
    'client' => $client,
    'data' => $entity_data,
    'idmap' => $idmap_resolved,
    'env' => $env,
    'explain' => ((($env->{'SOLARDEMO_TEST_EXPLAIN'}) || '') eq 'TRUE') ? 1 : 0,
    'live' => $live,
    'synthetic_only' => ($live && !$idmap_overridden) ? 1 : 0,
    'now' => SolardemoHelpers::now_ms(),
  };
}

done_testing();
