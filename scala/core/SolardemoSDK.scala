package voxgig.solardemosdk.core

import java.util.{Map => JMap}

// Solardemo SDK client. All transport and pipeline behaviour lives in the
// SdkClient base (core/SdkClient.scala); this class binds the API-specific
// entity accessors and the test-mode constructor.
class SolardemoSDK(options: JMap[String, Object]) extends SdkClient(options) {

  def this() = this(null)


  /**
   * Returns a moon entity bound to this client.
   * Idiomatic usage: client.moon(null).list(null, null) or
   * client.moon(null).load(java.util.Map.of("id", ...), null).
   */
  def moon(entopts: java.util.Map[String, Object]): SdkEntity =
    new voxgig.solardemosdk.entity.MoonEntity(this, entopts)

  /**
   * Returns a planet entity bound to this client.
   * Idiomatic usage: client.planet(null).list(null, null) or
   * client.planet(null).load(java.util.Map.of("id", ...), null).
   */
  def planet(entopts: java.util.Map[String, Object]): SdkEntity =
    new voxgig.solardemosdk.entity.PlanetEntity(this, entopts)


}

object SolardemoSDK {

  // testSDK builds a client in test mode: the test feature is activated,
  // installing the in-memory mock transport (no network activity).
  def testSDK(): SolardemoSDK = testSDK(null, null)

  def testSDK(testopts: JMap[String, Object], sdkopts: JMap[String, Object]): SolardemoSDK = {
    val sdk = new SolardemoSDK(SdkClient.testOptions(testopts, sdkopts))
    sdk.mode = "test"
    sdk
  }
}
