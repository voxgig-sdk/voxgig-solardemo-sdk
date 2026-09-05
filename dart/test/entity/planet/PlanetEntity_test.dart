// ignore_for_file: unused_import, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import '../../harness.dart';
import '../../utility.dart';

import '../../../lib/SolardemoSDK.dart';
import '../../../lib/utility/voxgig_struct.dart' as vs;

void tests() {
  describe('PlanetEntity', () {
    test('instance', (t) async {
      final testsdk = SolardemoSDK.test();
      final ent = testsdk.Planet();
      ok(null != ent);
    });

test('stream', (t) async {
      // stream() runs the list op through the full pipeline and yields each
      // result item. Seed two entities via test mode; with the `streaming`
      // feature active it yields the feature's incremental items, else it
      // falls back to the materialised items — either way every item yields.
      final seed = <String, dynamic>{
        'entity': {
          'planet': {
            'strm01': <String, dynamic>{'id': 'strm01'},
            'strm02': <String, dynamic>{'id': 'strm02'},
          }
        }
      };

      final sdkopts = <String, dynamic>{};
      if (null != config.feature['streaming']) {
        sdkopts['feature'] = {
          'streaming': {'active': true}
        };
      }

      final testsdk = SolardemoSDK.test(seed, sdkopts);
      final ent = testsdk.Planet();

      final seen = [];
      await for (final item in ent.stream('list', <String, dynamic>{})) {
        seen.add(item);
      }
      equal(2, seen.length);

      // Fallback: with streaming inactive, stream() still yields both items
      // from the materialised result.
      final plainsdk = SolardemoSDK.test(seed);
      final plainent = plainsdk.Planet();
      final seen2 = [];
      await for (final item in plainent.stream('list', <String, dynamic>{})) {
        seen2.add(item);
      }
      equal(2, seen2.length);
    });


    test('basic', (t) async {

      final live = 'TRUE' == Platform.environment['SOLARDEMO_TEST_LIVE'];
      for (final op in ['create', 'list', 'update', 'load', 'remove']) {
        if (maybeSkipControl(t, 'entityOp', 'planet.' + op, live)) {
          return;
        }
      }

      final setup = basicSetup();
      // The basic flow consumes synthetic IDs and field values from the
      // fixture (entity TestData.json). Those don't exist on the live API.
      // Skip live runs unless the user provided a real ENTID env override.
      if (true == setup['syntheticOnly']) {
        t.skip('live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live');
        return;
      }
      final client = setup['client'];
      final struct = setup['struct'];

      final isempty = struct.isempty;
      final select = struct.select;


      // CREATE
      final planet_ref01_ent = client.Planet();
      dynamic planet_ref01_data = setup['data']['new']['planet']['planet_ref01'];

      planet_ref01_data = (await planet_ref01_ent.create(planet_ref01_data)).data();
      ok(null != planet_ref01_data['id']);


      // LIST
      final planet_ref01_match = <String, dynamic>{};

      final planet_ref01_list = (await planet_ref01_ent.list(planet_ref01_match)).map((e) => e.data()).toList();

      ok(!isempty(select(
          planet_ref01_list,
          {'id': planet_ref01_data['id']})));


      // UPDATE
      final planet_ref01_data_up0 = <String, dynamic>{};
      planet_ref01_data_up0['id'] = planet_ref01_data['id'];

      final planet_ref01_markdef_up0 = <String, dynamic>{
        'name': 'kind',
        'value': 'Mark01-planet_ref01_' + setup['now'].toString(),
      };
      planet_ref01_data_up0[planet_ref01_markdef_up0['name']] = planet_ref01_markdef_up0['value'];

      final planet_ref01_resdata_up0 = (await planet_ref01_ent.update(planet_ref01_data_up0)).data();
      ok(planet_ref01_resdata_up0['id'] == planet_ref01_data_up0['id']);

      ok(planet_ref01_resdata_up0[planet_ref01_markdef_up0['name']] == planet_ref01_markdef_up0['value']);


      // LOAD
      final planet_ref01_match_dt0 = <String, dynamic>{};
      planet_ref01_match_dt0['id'] = planet_ref01_data['id'];
      final planet_ref01_data_dt0 = (await planet_ref01_ent.load(planet_ref01_match_dt0)).data();
      ok(planet_ref01_data_dt0['id'] == planet_ref01_data['id']);


      // REMOVE
      final planet_ref01_match_rm0 = <String, dynamic>{'id': planet_ref01_data['id']};
      await planet_ref01_ent.remove(planet_ref01_match_rm0);


      // LIST
      final planet_ref01_match_rt0 = <String, dynamic>{};

      final planet_ref01_list_rt0 = (await planet_ref01_ent.list(planet_ref01_match_rt0)).map((e) => e.data()).toList();

      ok(isempty(select(
          planet_ref01_list_rt0,
          {'id': planet_ref01_data['id']})));


    });
  });
}


Map<String, dynamic> basicSetup([dynamic extra]) {
  final options = <String, dynamic>{};

  final entityDataFile = resolveTestPath(
      '../.sdk/test/entity/planet/PlanetTestData.json');

  final entityDataSource = File(entityDataFile).readAsStringSync();

  final entityData = jsonDecode(entityDataSource);

  options['entity'] = entityData['existing'];

  var client = SolardemoSDK.test(options, extra);
  final struct = client.utility().struct;
  final merge = struct.merge;
  final transform = struct.transform;

  dynamic idmap = transform(
      <dynamic>['planet01', 'planet02', 'planet03'],
      <String, dynamic>{
        '`\$PACK`': <dynamic>[
          '',
          <String, dynamic>{
            '`\$KEY`': '`\$COPY`',
            '`\$VAL`': <dynamic>['`\$FORMAT`', 'upper', '`\$COPY`'],
          }
        ]
      });

  // Detect whether the user provided a real ENTID JSON via env var. The
  // basic flow consumes synthetic IDs from the fixture file; without an
  // override those synthetic IDs reach the live API and 4xx. Surface this
  // to the test so it can skip rather than fail.
  final idmapEnvVal =
      Platform.environment['SOLARDEMO_TEST_PLANET_ENTID'];
  final idmapOverridden =
      null != idmapEnvVal && idmapEnvVal.trim().startsWith('{');

  final env = envOverride({
    'SOLARDEMO_TEST_PLANET_ENTID': idmap,
    'SOLARDEMO_TEST_LIVE': 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN': 'FALSE',
  });

  idmap = env['SOLARDEMO_TEST_PLANET_ENTID'];

  final live = 'TRUE' == env['SOLARDEMO_TEST_LIVE'];

  if (live) {
    client = SolardemoSDK(merge([
      // FIRST, so the generated fields below win: sdk-test-control.json's
      // test.client.options adds to the live client, it does not redirect it.
      liveClientOptions(),
      <String, dynamic>{
      },
      // 'extra ?? {}', not a bare 'extra': merge returns null when the last
      // entry is null, and basicSetup is normally called with no argument at
      // all - so a bare 'extra' silently discarded the apikey and server
      // values above and handed the SDK null.
      extra ?? <String, dynamic>{}
    ]));
  }

  final setup = <String, dynamic>{
    'idmap': idmap,
    'env': env,
    'options': options,
    'client': client,
    'struct': struct,
    'data': entityData,
    'explain': 'TRUE' == env['SOLARDEMO_TEST_EXPLAIN'],
    'live': live,
    'syntheticOnly': live && !idmapOverridden,
    'now': DateTime.now().millisecondsSinceEpoch,
  };

  return setup;
}

