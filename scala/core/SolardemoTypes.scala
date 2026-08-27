package voxgig.solardemosdk.core

// Typed reference models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels (source of truth: @voxgig/apidef VALID_CANON). Do
// not edit by hand.
//
// These case classes are documentation/DX reference shapes ONLY. The SDK ops
// take and return the loose object model (java.util.Map[String, Object] /
// Object) at runtime, so these types are not wired into the op signatures —
// use them to describe a payload before converting it to a map. Every
// component is a boxed (nullable) type, so an optional (req:false) key needs
// no distinct rendering.

object SolardemoTypes {

  final case class Moon(diameter: java.lang.Double, id: String, kind: String, name: String, planet_id: String)

  final case class MoonLoadMatch(id: String, planet_id: String)

  final case class MoonListMatch(planet_id: String)

  final case class MoonCreateData(planet_id: String, diameter: java.lang.Double, id: String, kind: String, name: String)

  final case class MoonUpdateData(id: String, planet_id: String, diameter: java.lang.Double, kind: String, name: String)

  final case class MoonRemoveMatch(id: String, planet_id: String)

  final case class Planet(diameter: java.lang.Double, forbid: java.lang.Boolean, id: String, kind: String, name: String, ok: java.lang.Boolean, start: java.lang.Boolean, state: String, stop: java.lang.Boolean, why: String)

  final case class PlanetLoadMatch(id: String)

  final case class PlanetListMatch(diameter: java.lang.Double, forbid: java.lang.Boolean, id: String, kind: String, name: String, ok: java.lang.Boolean, start: java.lang.Boolean, state: String, stop: java.lang.Boolean, why: String)

  final case class PlanetCreateData(diameter: java.lang.Double, forbid: java.lang.Boolean, id: String, kind: String, name: String, ok: java.lang.Boolean, start: java.lang.Boolean, state: String, stop: java.lang.Boolean, why: String)

  final case class PlanetUpdateData(id: String, diameter: java.lang.Double, forbid: java.lang.Boolean, kind: String, name: String, ok: java.lang.Boolean, start: java.lang.Boolean, state: String, stop: java.lang.Boolean, why: String)

  final case class PlanetRemoveMatch(id: String)

}
