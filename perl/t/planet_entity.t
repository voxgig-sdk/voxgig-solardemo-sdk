#!perl
# Planet entity test

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
  my $ent = $testsdk->Planet(undef);
  ok(defined $ent, 'planet: create instance');
}

BASIC_FLOW: {
  my $setup = planet_basic_setup(undef);
  my $_live = $setup->{live} ? 1 : 0;
  # Per-op sdk-test-control.json skip.
  for my $_op (('create', 'list', 'update', 'load', 'remove')) {
    my ($_should_skip, $_reason) = SolardemoTestRunner::is_control_skipped(
      'entityOp', "planet." . $_op, $_live ? 'live' : 'unit');
    if ($_should_skip) {
      note($_reason || 'skipped via sdk-test-control.json');
      pass('planet: basic flow skipped via sdk-test-control.json');
      last BASIC_FLOW;
    }
  }
  # The basic flow consumes synthetic IDs from the fixture. In live mode
  # without an *_ENTID env override, those IDs hit the live API and 4xx.
  if ($setup->{synthetic_only}) {
    note('live entity test uses synthetic IDs from fixture - set SOLARDEMO_TEST_PLANET_ENTID JSON to run live');
    pass('planet: basic flow skipped (synthetic IDs only)');
    last BASIC_FLOW;
  }
  my $client = $setup->{client};
  my %V;

  # CREATE
  $V{planet_ref01_ent} = $client->Planet(undef);
  $V{planet_ref01_data} = SolardemoHelpers::to_map(SolardemoHelpers::gp(
    SolardemoHelpers::gpath($setup->{data}, 'new.planet'), 'planet_ref01'));

  $V{planet_ref01_data_result} = $V{planet_ref01_ent}->create($V{planet_ref01_data}, undef);
  $V{planet_ref01_data} = SolardemoHelpers::to_map(ref($V{planet_ref01_data_result}) && $V{planet_ref01_data_result}->can('data_get') ? $V{planet_ref01_data_result}->data_get : $V{planet_ref01_data_result});
  ok(defined $V{planet_ref01_data}, 'planet create: data');
  ok(defined $V{planet_ref01_data}{id}, 'planet create: id');

  # LIST
  $V{planet_ref01_match} = {};

  $V{planet_ref01_list_result} = $V{planet_ref01_ent}->list($V{planet_ref01_match}, undef);
  ok(Voxgig::Struct::islist($V{planet_ref01_list_result}), 'planet list: is array');

  $V{found_item} = Voxgig::Struct::select(
    SolardemoTestRunner::entity_list_to_data($V{planet_ref01_list_result}),
    { 'id' => $V{planet_ref01_data}{id} });
  ok(!Voxgig::Struct::isempty($V{found_item}), 'planet list: item exists');

  # UPDATE
  $V{planet_ref01_data_up0_up} = {
    'id' => $V{planet_ref01_data}{id},
  };

  $V{planet_ref01_markdef_up0_name} = 'kind';
  $V{planet_ref01_markdef_up0_value} = 'Mark01-planet_ref01_' . $setup->{now};
  $V{planet_ref01_data_up0_up}{ $V{planet_ref01_markdef_up0_name} } = $V{planet_ref01_markdef_up0_value};

  $V{planet_ref01_resdata_up0_result} = $V{planet_ref01_ent}->update($V{planet_ref01_data_up0_up}, undef);
  $V{planet_ref01_resdata_up0} = SolardemoHelpers::to_map(ref($V{planet_ref01_resdata_up0_result}) && $V{planet_ref01_resdata_up0_result}->can('data_get') ? $V{planet_ref01_resdata_up0_result}->data_get : $V{planet_ref01_resdata_up0_result});
  ok(defined $V{planet_ref01_resdata_up0}, 'planet update: data');
  is($V{planet_ref01_resdata_up0}{id}, $V{planet_ref01_data_up0_up}{id}, 'planet update: id');
  is($V{planet_ref01_resdata_up0}{ $V{planet_ref01_markdef_up0_name} }, $V{planet_ref01_markdef_up0_value}, 'planet update: mark');

  # LOAD
  $V{planet_ref01_match_dt0} = {
    'id' => $V{planet_ref01_data}{id},
  };
  $V{planet_ref01_data_dt0_loaded} = $V{planet_ref01_ent}->load($V{planet_ref01_match_dt0}, undef);
  $V{planet_ref01_data_dt0_load_result} = SolardemoHelpers::to_map(ref($V{planet_ref01_data_dt0_loaded}) && $V{planet_ref01_data_dt0_loaded}->can('data_get') ? $V{planet_ref01_data_dt0_loaded}->data_get : $V{planet_ref01_data_dt0_loaded});
  ok(defined $V{planet_ref01_data_dt0_load_result}, 'planet load: data');
  is($V{planet_ref01_data_dt0_load_result}{id}, $V{planet_ref01_data}{id}, 'planet load: id');

  # REMOVE
  $V{planet_ref01_match_rm0} = {
    'id' => $V{planet_ref01_data}{id},
  };
  $V{planet_ref01_ent}->remove($V{planet_ref01_match_rm0}, undef);
  pass('planet remove: completed');

  # LIST
  $V{planet_ref01_match_rt0} = {};

  $V{planet_ref01_list_rt0_result} = $V{planet_ref01_ent}->list($V{planet_ref01_match_rt0}, undef);
  ok(Voxgig::Struct::islist($V{planet_ref01_list_rt0_result}), 'planet list: is array');

  $V{not_found_item} = Voxgig::Struct::select(
    SolardemoTestRunner::entity_list_to_data($V{planet_ref01_list_rt0_result}),
    { 'id' => $V{planet_ref01_data}{id} });
  ok(Voxgig::Struct::isempty($V{not_found_item}), 'planet list: item not exists');

}

sub planet_basic_setup {
  my ($extra) = @_;
  SolardemoTestRunner::load_env_local();

  my $entity_data_file = Cwd::abs_path(
    "$FindBin::Bin/../../.sdk/test/entity/planet/PlanetTestData.json");
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
    ['planet01', 'planet02', 'planet03'],
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
  my $entid_env_raw = $ENV{'SOLARDEMO_TEST_PLANET_ENTID'};
  my $idmap_overridden = (defined $entid_env_raw && $entid_env_raw =~ /^\s*\{/) ? 1 : 0;

  my $env = SolardemoTestRunner::env_override({
    'SOLARDEMO_TEST_PLANET_ENTID' => $idmap,
    'SOLARDEMO_TEST_LIVE' => 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN' => 'FALSE',
  });

  my $idmap_resolved = SolardemoHelpers::to_map($env->{'SOLARDEMO_TEST_PLANET_ENTID'});
  if (!defined $idmap_resolved) {
    $idmap_resolved = SolardemoHelpers::to_map($idmap);
  }

  if ((($env->{'SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') {
    my $merged_opts = Voxgig::Struct::merge([
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
