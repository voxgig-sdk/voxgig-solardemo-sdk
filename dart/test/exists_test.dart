import 'harness.dart';

import '../lib/VoxgigSolardemoSDK.dart';

void tests() {
  describe('exists', () {
    test('test-mode', (t) async {
      final testsdk = VoxgigSolardemoSDK.test();
      equal(true, null != testsdk);
    });
  });
}
