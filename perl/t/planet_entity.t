#!perl
# Planet entity test

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

{
  my $testsdk = VoxgigSolardemoSDK->test(undef, undef);
  my $ent = $testsdk->Planet(undef);
  ok(defined $ent, 'planet: create instance');
}

{
  package VoxgigSolardemoEntityTestPlanetFailHook;
  our @ISA = ('VoxgigSolardemoBaseFeature');

  sub new {
    my ($class) = @_;
    my $self = VoxgigSolardemoBaseFeature::new($class);
    $self->{name} = 'failhook';
    $self->{unexpected} = 0;
    return $self;
  }

  sub init { }
  sub PreSpec { die "planet hook failed\n" }
  sub PreUnexpected { $_[0]->{unexpected}++; return }
}

{
  my $offline = { net => { offline => 1 } };
  my $died = !eval {
    my $next = VoxgigSolardemoSDK->test($offline, undef)->Planet(undef)->stream('list', undef, undef);
    1 while defined $next->();
    1;
  };
  like($died ? "$@" : '', qr/offline/, 'planet: a failed stream raises');

  ok(eval {
    my $next = VoxgigSolardemoSDK->test($offline, undef)->Planet(undef)
      ->stream('list', undef, { ctrl => { throw => 0 } });
    1 while defined $next->();
    1;
  }, 'planet: under throw false a failed stream ends');

  if (VoxgigSolardemoConfig::shared_config()->{feature}{rbac}) {
    my $denied = VoxgigSolardemoSDK->test(undef, { feature => { rbac => { active => 1, deny => 1 } } });
    my $denyerr = eval {
      my $next = $denied->Planet(undef)->stream('list', undef, undef);
      1 while defined $next->();
      undef;
    } // $@;
    is(ref $denyerr ? $denyerr->{code} : undef, 'rbac_denied',
      'planet: a denied stream raises');
  }
}

{
  my $explain = {};
  my $ctrl = { explain => $explain };
  my $next = VoxgigSolardemoSDK->test(undef, undef)->Planet(undef)
    ->stream('list', undef, { ctrl => $ctrl });
  1 while defined $next->();
  is_deeply([sort keys %$ctrl], ['explain'], 'planet: the stream leaves the caller ctrl');
  ok($explain == $ctrl->{explain} && 0 < keys %$explain,
    'planet: the caller explain record is filled');
}

{
  my $hook = VoxgigSolardemoEntityTestPlanetFailHook->new;
  my $client = VoxgigSolardemoSDK->new({ feature => { test => { active => 1 } }, extend => [$hook] });

  my $err = eval { $client->Planet(undef)->list(undef, undef); undef } // $@;
  like("$err", qr/hook failed/, 'planet: a dying hook fails the operation');
  ok(0 < $hook->{unexpected}, 'planet: PreUnexpected fired');

  my $fired = $hook->{unexpected};
  my $out = eval { $client->Planet(undef)->list(undef, { throw => 0 }) };
  ok(!$@ && !defined $out, 'planet: under throw false the call returns undef');
  ok($fired < $hook->{unexpected}, 'planet: PreUnexpected fired under throw false');
}

{
  my $seed = { entity => { 'planet' => { l1 => { id => 'l1' }, l2 => { id => 'l2' } } } };
  my $items = VoxgigSolardemoSDK->test($seed, undef)->Planet(undef)->list(undef, undef);
  # list resolves to one entity per record; data_get reads the record.
  is(scalar(@$items), 2, 'planet: list answers each seeded record');
  my $entities = grep {
    Scalar::Util::blessed($_) && $_->can('data_get') && Voxgig::Struct::ismap($_->data_get)
  } @$items;
  is($entities, 2, 'planet: each listed item is an entity carrying its record');
}

SKIP: {
  skip('feature not present in this SDK: validate', 1)
    unless VoxgigSolardemoConfig::shared_config()->{feature}{validate};
  my $client = VoxgigSolardemoSDK->test(undef, { feature => { validate => { active => 1 } } });
  my $err = eval { $client->Planet(undef)->list({ 'diameter' => 'x' }, undef); undef } // $@;
  is(ref $err ? $err->{code} : undef, 'validate_failed',
    'planet: an invalid request fails with validate_failed');
}

BASIC_FLOW: {
  my $setup = planet_basic_setup(undef);
  my $_live = $setup->{live} ? 1 : 0;
  # Per-op sdk-test-control.json skip.
  for my $_op (('create', 'list', 'update', 'load', 'remove')) {
    my ($_should_skip, $_reason) = VoxgigSolardemoTestRunner::is_control_skipped(
      'entityOp', "planet." . $_op, $_live ? 'live' : 'unit');
    if ($_should_skip) {
      note($_reason || 'skipped via sdk-test-control.json');
      pass('planet: basic flow skipped via sdk-test-control.json');
      last BASIC_FLOW;
    }
  }
  my $client = $setup->{client};
  my %V;

  # CREATE
  $V{planet_ref01_ent} = $client->Planet(undef);
  $V{planet_ref01_data} = VoxgigSolardemoHelpers::to_map(VoxgigSolardemoHelpers::gp(
    VoxgigSolardemoHelpers::gpath($setup->{data}, 'new.planet'), 'planet_ref01'));

  $V{planet_ref01_data_result} = $V{planet_ref01_ent}->create($V{planet_ref01_data}, undef);
  $V{planet_ref01_data} = VoxgigSolardemoHelpers::to_map(ref($V{planet_ref01_data_result}) && $V{planet_ref01_data_result}->can('data_get') ? $V{planet_ref01_data_result}->data_get : $V{planet_ref01_data_result});
  ok(defined $V{planet_ref01_data}, 'planet create: data');
  ok(defined $V{planet_ref01_data}{id}, 'planet create: id');

  # LIST
  $V{planet_ref01_match} = {};

  $V{planet_ref01_list_result} = $V{planet_ref01_ent}->list($V{planet_ref01_match}, undef);
  ok(Voxgig::Struct::islist($V{planet_ref01_list_result}), 'planet list: is array');

  $V{found_item} = Voxgig::Struct::select(
    VoxgigSolardemoTestRunner::entity_list_to_data($V{planet_ref01_list_result}),
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
  $V{planet_ref01_resdata_up0} = VoxgigSolardemoHelpers::to_map(ref($V{planet_ref01_resdata_up0_result}) && $V{planet_ref01_resdata_up0_result}->can('data_get') ? $V{planet_ref01_resdata_up0_result}->data_get : $V{planet_ref01_resdata_up0_result});
  ok(defined $V{planet_ref01_resdata_up0}, 'planet update: data');
  is($V{planet_ref01_resdata_up0}{id}, $V{planet_ref01_data_up0_up}{id}, 'planet update: id');
  is($V{planet_ref01_resdata_up0}{ $V{planet_ref01_markdef_up0_name} }, $V{planet_ref01_markdef_up0_value}, 'planet update: mark');

  # LOAD
  $V{planet_ref01_match_dt0} = {
    'id' => $V{planet_ref01_data}{id},
  };
  $V{planet_ref01_data_dt0_loaded} = $V{planet_ref01_ent}->load($V{planet_ref01_match_dt0}, undef);
  $V{planet_ref01_data_dt0_load_result} = VoxgigSolardemoHelpers::to_map(ref($V{planet_ref01_data_dt0_loaded}) && $V{planet_ref01_data_dt0_loaded}->can('data_get') ? $V{planet_ref01_data_dt0_loaded}->data_get : $V{planet_ref01_data_dt0_loaded});
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
    VoxgigSolardemoTestRunner::entity_list_to_data($V{planet_ref01_list_rt0_result}),
    { 'id' => $V{planet_ref01_data}{id} });
  ok(Voxgig::Struct::isempty($V{not_found_item}), 'planet list: item not exists');

}

sub planet_basic_setup {
  my ($extra) = @_;
  VoxgigSolardemoTestRunner::load_env_local();

  my $entity_data_file = Cwd::abs_path(
    "$FindBin::Bin/../../.sdk/test/entity/planet/PlanetTestData.json");
  my $entity_data = do {
    open my $fh, '<:raw', $entity_data_file or die "Cannot open $entity_data_file: $!";
    local $/;
    Voxgig::Struct::parse_json(<$fh>);
  };

  my $options = {};
  $options->{entity} = $entity_data->{existing};

  my $client = VoxgigSolardemoSDK->test($options, $extra);

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

  # Whether *_ENTID supplied the idmap, read before env_override consumes
  # it: without it, the ids a live flow binds are the fixture's synthetic ones.
  my $entid_env_raw = $ENV{'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID'};
  my $idmap_overridden = (defined $entid_env_raw && $entid_env_raw =~ /^\s*\{/) ? 1 : 0;

  my $env = VoxgigSolardemoTestRunner::env_override({
    'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID' => $idmap,
    'VOXGIG_SOLARDEMO_TEST_LIVE' => 'FALSE',
    'VOXGIG_SOLARDEMO_TEST_EXPLAIN' => 'FALSE',
  });

  my $idmap_resolved = VoxgigSolardemoHelpers::to_map($env->{'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID'});
  if (!defined $idmap_resolved) {
    $idmap_resolved = VoxgigSolardemoHelpers::to_map($idmap);
  }

  if ((($env->{'VOXGIG_SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') {
    my $merged_opts = Voxgig::Struct::merge([
      # FIRST, so the generated fields below win: sdk-test-control.json's
      # test.client.options adds to the live client, it does not redirect it.
      VoxgigSolardemoTestRunner::live_client_options(),
      {
      },
      (Voxgig::Struct::ismap($extra) ? $extra : {}),
    ]);
    $client = VoxgigSolardemoSDK->new(VoxgigSolardemoHelpers::to_map($merged_opts));
  }

  my $live = ((($env->{'VOXGIG_SOLARDEMO_TEST_LIVE'}) || '') eq 'TRUE') ? 1 : 0;
  return {
    'client' => $client,
    'data' => $entity_data,
    'idmap' => $idmap_resolved,
    'env' => $env,
    'explain' => ((($env->{'VOXGIG_SOLARDEMO_TEST_EXPLAIN'}) || '') eq 'TRUE') ? 1 : 0,
    'live' => $live,
    'synthetic_only' => ($live && !$idmap_overridden) ? 1 : 0,
    'now' => VoxgigSolardemoHelpers::now_ms(),
  };
}

done_testing();
