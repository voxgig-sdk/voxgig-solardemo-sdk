// ignore_for_file: unused_import, unused_local_variable, non_constant_identifier_names

import 'dart:convert';

import '../../harness.dart';
import '../../utility.dart';

import '../../../lib/SolardemoSDK.dart';

void tests() {
  describe('PlanetDirect', () {
    test('direct-exists', (t) async {
      final sdk = SolardemoSDK({
        'system': {
          'fetch': (dynamic url, dynamic init) async => <String, dynamic>{}
        }
      });
      ok(null != sdk);
    });


    test('direct-load-planet', (t) async {
      final setup = directSetup({'id': 'direct01'});
      if (maybeSkipControl(
          t, 'direct', 'direct-load-planet', true == setup['live'])) {
        return;
      }
      final client = setup['client'];
      final calls = setup['calls'];

      final params = <String, dynamic>{};
      final query = <String, dynamic>{};
      if (true == setup['live']) {
        final listResult = await client.direct({
          'path': 'api/planet',
          'method': 'GET',
          'params': {

          },
        });
        if (true != listResult['ok']) {
          return; // skip: list call failed (likely synthetic IDs against live API)
        }
        final listArr = unwrapListData(listResult['data']);
        if (null == listArr || 0 == listArr.length) {
          return; // skip: no entities to load in live mode
        }
        final candidateId =
            (listArr[0] is Map ? listArr[0]['id'] : null) ??
                (listArr[0] is Map ? listArr[0]['id'] : null);
        if (null == candidateId) {
          return; // skip: list response shape does not expose load identifier
        }
        params['id'] = candidateId;

      } else {
        params['id'] = 'direct01';
      }

      final result = await client.direct({
        'path': 'api/planet/{id}',
        'method': 'GET',
        'params': params,
        'query': query,
      });

      if (true == setup['live']) {
        // Live mode is lenient: synthetic IDs frequently 4xx. Skip rather
        // than fail when the load endpoint isn't reachable.
        if (true != result['ok'] ||
            result['status'] < 200 ||
            result['status'] >= 300) {
          return;
        }
      } else {
        ok(true == result['ok']);
        ok(200 == result['status']);
        ok(null != result['data']);
        ok('direct01' == result['data']['id']);
        ok(1 == calls.length);
        ok('GET' == calls[0]['init']['method']);
        ok(calls[0]['url'].toString().contains('direct01'));
      }
    });

    test('direct-list-planet', (t) async {
      final setup = directSetup([
        {'id': 'direct01'},
        {'id': 'direct02'}
      ]);
      if (maybeSkipControl(
          t, 'direct', 'direct-list-planet', true == setup['live'])) {
        return;
      }
      final client = setup['client'];
      final calls = setup['calls'];

      final params = <String, dynamic>{};
      final query = <String, dynamic>{};

      final result = await client.direct({
        'path': 'api/planet',
        'method': 'GET',
        'params': params,
        'query': query,
      });

      if (true == setup['live']) {
        // Live mode is lenient: synthetic IDs frequently 4xx and the list-
        // response shape varies wildly across public APIs. Skip rather than
        // fail when the call doesn't return a usable list.
        if (true != result['ok'] ||
            result['status'] < 200 ||
            result['status'] >= 300) {
          return;
        }
        final listArr = unwrapListData(result['data']);
        if (listArr is! List) {
          return;
        }
      } else {
        ok(true == result['ok']);
        ok(200 == result['status']);
        ok(null != result['data']);
        final listArr = unwrapListData(result['data']);
        ok(listArr is List);
        ok(2 == listArr.length);
        ok(1 == calls.length);
        ok('GET' == calls[0]['init']['method']);
      }
    });

  });
}


Map<String, dynamic> directSetup([dynamic mockres]) {
  final calls = <Map<String, dynamic>>[];

  final env = envOverride({
    'SOLARDEMO_TEST_PLANET_ENTID': <String, dynamic>{},
    'SOLARDEMO_TEST_LIVE': 'FALSE',
  });

  final live = 'TRUE' == env['SOLARDEMO_TEST_LIVE'];

  if (live) {
    final client = SolardemoSDK({
    });

    dynamic idmap = env['SOLARDEMO_TEST_PLANET_ENTID'];
    if (idmap is String && idmap.startsWith('{')) {
      idmap = jsonDecode(idmap);
    }

    return {'client': client, 'calls': calls, 'live': live, 'idmap': idmap};
  }

  mockFetch(dynamic url, dynamic init) async {
    calls.add({'url': url, 'init': init});
    return {
      'status': 200,
      'statusText': 'OK',
      'headers': <String, dynamic>{},
      'json': () => mockres ?? {'id': 'direct01'},
    };
  }

  final client = SolardemoSDK({
    'base': 'http://localhost:8080',
    'system': {'fetch': mockFetch},
  });

  return {
    'client': client,
    'calls': calls,
    'live': live,
    'idmap': <String, dynamic>{},
  };
}

// direct() returns the raw response body. List endpoints often wrap the
// array in an envelope (e.g. { data: [...] }, { entities: [...] }). The
// test transforms the raw body to extract the first list — either the body
// itself or the first list property of an envelope map.
dynamic unwrapListData(dynamic data) {
  if (data is List) {
    return data;
  }
  if (data is Map) {
    for (final v in data.values) {
      if (v is List) {
        return v;
      }
    }
  }
  return null;
}
  
