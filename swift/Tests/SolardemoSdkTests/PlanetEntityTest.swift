// planet entity test (generated from the API model).

import XCTest

@testable import SolardemoSdk

final class PlanetEntityTest: XCTestCase {
  func testInstance() {
    let sdk = SolardemoSDK.testSDK(nil, nil)
    let ent = sdk.Planet()
    XCTAssertEqual(ent.getName(), "planet")
  }

  func testStream() async throws {
    // Seed two records (under the test feature's entity key) and activate
    // the streaming feature.
    let fixtures = vm(("entity", .map(vm(("planet", .map(vm(
      ("s1", .map(vm(("id", .string("s1"))))),
      ("s2", .map(vm(("id", .string("s2"))))))))))))
    let sdkopts = vm(
      ("feature", .map(vm(("streaming", .map(vm(("active", .bool(true)))))))))
    let sdk = SolardemoSDK.testSDK(fixtures, sdkopts)
    let ent = sdk.Planet()

    // Materialised list result for the same op.
    let listed = try ent.list(VMap(), nil)
    let listedN = listed.asList?.items.count ?? 0

    // stream("list") yields items via the streaming feature's iterator.
    var streamed: [Value] = []
    let seq = try ent.stream("list", VMap(), nil)
    for await item in seq { streamed.append(item) }
    XCTAssertGreaterThan(streamed.count, 0, "expected stream to yield items")
    XCTAssertEqual(streamed.count, listedN)

    // Fallback: with streaming inactive, stream still yields the materialised
    // items.
    let sdk2 = SolardemoSDK.testSDK(fixtures, nil)
    let ent2 = sdk2.Planet()
    var streamed2: [Value] = []
    let seq2 = try ent2.stream("list", VMap(), nil)
    for await item in seq2 { streamed2.append(item) }
    XCTAssertEqual(streamed2.count, listedN)
  }
}
