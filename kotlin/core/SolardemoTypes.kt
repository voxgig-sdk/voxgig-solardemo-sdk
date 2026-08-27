package voxgig.solardemosdk.core

// Typed reference models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels (source of truth: @voxgig/apidef VALID_CANON). Do
// not edit by hand.
//
// These types are documentation/DX reference shapes ONLY. The SDK ops take and
// return the loose object model (MutableMap<String, Any?> / Any?) at runtime,
// so these types are not wired into the op signatures — use them to describe a
// payload before converting it to a map. Every component is a nullable type, so
// an optional (req:false) key needs no distinct rendering.

@Suppress("unused")
object SolardemoTypes {

  data class Moon(val diameter: Double?, val id: String?, val kind: String?, val name: String?, val planet_id: String?)

  data class MoonLoadMatch(val id: String?, val planet_id: String?)

  data class MoonListMatch(val planet_id: String?)

  data class MoonCreateData(val planet_id: String?, val diameter: Double?, val id: String?, val kind: String?, val name: String?)

  data class MoonUpdateData(val id: String?, val planet_id: String?, val diameter: Double?, val kind: String?, val name: String?)

  data class MoonRemoveMatch(val id: String?, val planet_id: String?)

  data class Planet(val diameter: Double?, val forbid: Boolean?, val id: String?, val kind: String?, val name: String?, val ok: Boolean?, val start: Boolean?, val state: String?, val stop: Boolean?, val why: String?)

  data class PlanetLoadMatch(val id: String?)

  data class PlanetListMatch(val diameter: Double?, val forbid: Boolean?, val id: String?, val kind: String?, val name: String?, val ok: Boolean?, val start: Boolean?, val state: String?, val stop: Boolean?, val why: String?)

  data class PlanetCreateData(val diameter: Double?, val forbid: Boolean?, val id: String?, val kind: String?, val name: String?, val ok: Boolean?, val start: Boolean?, val state: String?, val stop: Boolean?, val why: String?)

  data class PlanetUpdateData(val id: String?, val diameter: Double?, val forbid: Boolean?, val kind: String?, val name: String?, val ok: Boolean?, val start: Boolean?, val state: String?, val stop: Boolean?, val why: String?)

  data class PlanetRemoveMatch(val id: String?)

}
