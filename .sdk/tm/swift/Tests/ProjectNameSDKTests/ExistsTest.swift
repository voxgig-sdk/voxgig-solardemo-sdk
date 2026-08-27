// Solardemo SDK exists test.

import XCTest

@testable import SolardemoSdk

final class ExistsTest: XCTestCase {
  func testMode() {
    let testsdk = SolardemoSDK.testSDK(nil, nil)
    XCTAssertEqual(testsdk.mode, "test")
  }
}
