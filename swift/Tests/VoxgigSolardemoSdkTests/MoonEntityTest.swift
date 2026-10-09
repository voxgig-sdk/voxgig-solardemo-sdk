// moon entity test (generated from the API model).

import XCTest

@testable import VoxgigSolardemoSdk

final class MoonEntityTest: XCTestCase {
  func testInstance() {
    let sdk = VoxgigSolardemoSDK.testSDK(nil, nil)
    let ent = sdk.Moon()
    XCTAssertEqual(ent.getName(), "moon")
  }

  // An invalid request fails with validate's own error, before it is sent.
  func testValidate() throws {
    try XCTSkipUnless(MoonEntityTest.hasFeature("validate"), "feature not present in this SDK: validate")
    let client = VoxgigSolardemoSDK.testSDK(nil, vm(("feature", .map(vm(("validate", .map(vm(("active", .bool(true))))))))))
    var err: Error? = nil
    do { _ = try client.Moon().list(vm(("planet_id", .int(1))), nil) } catch { err = error }
    XCTAssertEqual((err as? VoxgigSolardemoError)?.code, "validate_failed",
      "expected validate_failed, got \(String(describing: err))")
  }

  // True when this SDK was generated with the named feature.
  static func hasFeature(_ name: String) -> Bool {
    gp(SdkConfig.makeConfig(), "feature").asMap?.entries[name] != nil
  }
}
