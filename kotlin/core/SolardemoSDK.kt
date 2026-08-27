package voxgig.solardemosdk.core

/**
 * Solardemo SDK client. All transport and pipeline behaviour lives in the
 * SdkClient base (core/SdkClient.kt); this class binds the API-specific
 * entity accessors and the test-mode constructor.
 */
class SolardemoSDK(options: MutableMap<String, Any?>?) : SdkClient(options) {

  constructor() : this(null)


  /**
   * Returns a moon entity bound to this client.
   * Idiomatic usage: client.moon(null).list(null, null) or
   * client.moon(null).load(mutableMapOf("id" to ...), null).
   */
  fun moon(entopts: MutableMap<String, Any?>?): SdkEntity {
    return voxgig.solardemosdk.entity.MoonEntity(this, entopts)
  }

  /**
   * Returns a planet entity bound to this client.
   * Idiomatic usage: client.planet(null).list(null, null) or
   * client.planet(null).load(mutableMapOf("id" to ...), null).
   */
  fun planet(entopts: MutableMap<String, Any?>?): SdkEntity {
    return voxgig.solardemosdk.entity.PlanetEntity(this, entopts)
  }


  companion object {
    // testSDK builds a client in test mode: the test feature is activated,
    // installing the in-memory mock transport (no network activity).
    fun testSDK(): SolardemoSDK = testSDK(null, null)

    fun testSDK(
      testopts: MutableMap<String, Any?>?,
      sdkopts: MutableMap<String, Any?>?,
    ): SolardemoSDK {
      val sdk = SolardemoSDK(testOptions(testopts, sdkopts))
      sdk.mode = "test"
      return sdk
    }
  }
}
