package voxgig.solardemosdk.sdktest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;

import voxgig.solardemosdk.core.SolardemoSDK;

public class ExistsTest {

  @Test
  public void testMode() {
    SolardemoSDK testsdk = SolardemoSDK.testSDK();
    assertNotNull(testsdk, "expected non-nil SDK");
  }
}
