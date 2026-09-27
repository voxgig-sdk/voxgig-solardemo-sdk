// VoxgigSolardemo SDK exists test.

import XCTest

@testable import VoxgigSolardemoSdk

final class ExistsTest: XCTestCase {
  func testMode() {
    let testsdk = VoxgigSolardemoSDK.testSDK(nil, nil)
    XCTAssertEqual(testsdk.mode, "test")
  }
}
