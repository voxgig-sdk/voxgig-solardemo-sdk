package KOTLINPACKAGE.sdktest

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test

import KOTLINPACKAGE.core.VoxgigSolardemoSDK

class ExistsTest {

  @Test
  fun testMode() {
    val testsdk = VoxgigSolardemoSDK.testSDK()
    assertNotNull(testsdk, "expected non-nil SDK")
  }
}
