package voxgig.solardemosdk.core;

import java.util.Map;

/**
 * Solardemo SDK client. All transport and pipeline behaviour lives in
 * the SdkClient base (core/SdkClient.java); this class binds the
 * API-specific entity accessors and the test-mode constructor.
 */
public class SolardemoSDK extends SdkClient {

  public SolardemoSDK() {
    this(null);
  }

  public SolardemoSDK(Map<String, Object> options) {
    super(options);
  }


  /**
   * Returns a moon entity bound to this client.
   * Idiomatic usage: client.moon(null).list(null, null) or
   * client.moon(null).load(Map.of("id", ...), null).
   */
  public SdkEntity moon(Map<String, Object> entopts) {
    return new voxgig.solardemosdk.entity.MoonEntity(this, entopts);
  }

  /**
   * Returns a planet entity bound to this client.
   * Idiomatic usage: client.planet(null).list(null, null) or
   * client.planet(null).load(Map.of("id", ...), null).
   */
  public SdkEntity planet(Map<String, Object> entopts) {
    return new voxgig.solardemosdk.entity.PlanetEntity(this, entopts);
  }


  // testSDK builds a client in test mode: the test feature is activated,
  // installing the in-memory mock transport (no network activity).
  public static SolardemoSDK testSDK() {
    return testSDK(null, null);
  }

  public static SolardemoSDK testSDK(
      Map<String, Object> testopts, Map<String, Object> sdkopts) {
    SolardemoSDK sdk = new SolardemoSDK(SdkClient.testOptions(testopts, sdkopts));
    sdk.mode = "test";
    return sdk;
  }
}
