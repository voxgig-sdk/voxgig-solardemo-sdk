import 'harness.dart';

import '../lib/SolardemoSDK.dart';

void tests() {
  describe('exists', () {
    test('test-mode', (t) async {
      final testsdk = SolardemoSDK.test();
      equal(true, null != testsdk);
    });
  });
}
