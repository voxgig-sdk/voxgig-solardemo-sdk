// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types are mapped
// from the canonical type sentinels. Do not edit by hand.
//
// These are DOCUMENTARY: the SDK runtime is dynamic (ops take/return the
// `Value` enum), so nothing consumes these structs yet — they mirror the
// entity/op shapes for reference and IDE support.

import Foundation

/// Moon is the typed data model for the moon entity.
public struct Moon {
  public var diameter: Double
  public var id: String
  public var kind: String
  public var name: String
  public var planetId: String
}

/// MoonLoadMatch is the typed request payload for Moon.load.
public struct MoonLoadMatch {
  public var id: String
  public var planetId: String
}

/// MoonListMatch is the typed request payload for Moon.list.
public struct MoonListMatch {
  public var planetId: String
}

/// MoonCreateData is the typed request payload for Moon.create.
public struct MoonCreateData {
  public var planetId: String
  public var diameter: Double
  public var id: String
  public var kind: String
  public var name: String
}

/// MoonUpdateData is the typed request payload for Moon.update.
public struct MoonUpdateData {
  public var id: String
  public var planetId: String
  public var diameter: Double?
  public var kind: String?
  public var name: String?
}

/// MoonRemoveMatch is the typed request payload for Moon.remove.
public struct MoonRemoveMatch {
  public var id: String
  public var planetId: String
}

/// Planet is the typed data model for the planet entity.
public struct Planet {
  public var diameter: Double
  public var forbid: Bool?
  public var id: String
  public var kind: String
  public var name: String
  public var ok: Bool?
  public var start: Bool?
  public var state: String?
  public var stop: Bool?
  public var why: String?
}

/// PlanetLoadMatch is the typed request payload for Planet.load.
public struct PlanetLoadMatch {
  public var id: String
}

/// PlanetListMatch is the typed request payload for Planet.list.
public struct PlanetListMatch {
  public var diameter: Double?
  public var forbid: Bool?
  public var id: String?
  public var kind: String?
  public var name: String?
  public var ok: Bool?
  public var start: Bool?
  public var state: String?
  public var stop: Bool?
  public var why: String?
}

/// PlanetCreateData is the typed request payload for Planet.create.
public struct PlanetCreateData {
  public var diameter: Double
  public var forbid: Bool?
  public var id: String
  public var kind: String
  public var name: String
  public var ok: Bool?
  public var start: Bool?
  public var state: String?
  public var stop: Bool?
  public var why: String?
}

/// PlanetUpdateData is the typed request payload for Planet.update.
public struct PlanetUpdateData {
  public var id: String
  public var diameter: Double?
  public var forbid: Bool?
  public var kind: String?
  public var name: String?
  public var ok: Bool?
  public var start: Bool?
  public var state: String?
  public var stop: Bool?
  public var why: String?
}

/// PlanetRemoveMatch is the typed request payload for Planet.remove.
public struct PlanetRemoveMatch {
  public var id: String
}

