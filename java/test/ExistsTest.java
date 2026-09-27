package voxgig.voxgigsolardemosdk.sdktest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;

import voxgig.voxgigsolardemosdk.core.VoxgigSolardemoSDK;

public class ExistsTest {

  @Test
  public void testMode() {
    VoxgigSolardemoSDK testsdk = VoxgigSolardemoSDK.testSDK();
    assertNotNull(testsdk, "expected non-nil SDK");
  }
}
