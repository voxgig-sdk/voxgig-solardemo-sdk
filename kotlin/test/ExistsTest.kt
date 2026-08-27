package voxgig.solardemosdk.sdktest

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test

import voxgig.solardemosdk.core.SolardemoSDK

class ExistsTest {

  @Test
  fun testMode() {
    val testsdk = SolardemoSDK.testSDK()
    assertNotNull(testsdk, "expected non-nil SDK")
  }
}
