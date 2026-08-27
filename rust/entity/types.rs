// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types are mapped
// from the canonical type sentinels. Do not edit by hand.
//
// These are DOCUMENTARY: the SDK runtime is dynamic (ops take/return the
// `Value` enum), so nothing consumes these structs yet — they mirror the
// entity/op shapes for reference and IDE support.
#![allow(dead_code, non_snake_case, unused_imports)]

use crate::utility::voxgigstruct::Value;

/// Moon is the typed data model for the moon entity.
#[derive(Debug, Clone)]
pub struct Moon {
    pub diameter: f64,
    pub id: String,
    pub kind: String,
    pub name: String,
    pub planet_id: String,
}

/// MoonLoadMatch is the typed request payload for Moon.load.
#[derive(Debug, Clone)]
pub struct MoonLoadMatch {
    pub id: String,
    pub planet_id: String,
}

/// MoonListMatch is the typed request payload for Moon.list.
#[derive(Debug, Clone)]
pub struct MoonListMatch {
    pub planet_id: String,
}

/// MoonCreateData is the typed request payload for Moon.create.
#[derive(Debug, Clone)]
pub struct MoonCreateData {
    pub planet_id: String,
    pub diameter: f64,
    pub id: String,
    pub kind: String,
    pub name: String,
}

/// MoonUpdateData is the typed request payload for Moon.update.
#[derive(Debug, Clone)]
pub struct MoonUpdateData {
    pub id: String,
    pub planet_id: String,
    pub diameter: Option<f64>,
    pub kind: Option<String>,
    pub name: Option<String>,
}

/// MoonRemoveMatch is the typed request payload for Moon.remove.
#[derive(Debug, Clone)]
pub struct MoonRemoveMatch {
    pub id: String,
    pub planet_id: String,
}

/// Planet is the typed data model for the planet entity.
#[derive(Debug, Clone)]
pub struct Planet {
    pub diameter: f64,
    pub forbid: Option<bool>,
    pub id: String,
    pub kind: String,
    pub name: String,
    pub ok: Option<bool>,
    pub start: Option<bool>,
    pub state: Option<String>,
    pub stop: Option<bool>,
    pub why: Option<String>,
}

/// PlanetLoadMatch is the typed request payload for Planet.load.
#[derive(Debug, Clone)]
pub struct PlanetLoadMatch {
    pub id: String,
}

/// PlanetListMatch is the typed request payload for Planet.list.
#[derive(Debug, Clone)]
pub struct PlanetListMatch {
    pub diameter: Option<f64>,
    pub forbid: Option<bool>,
    pub id: Option<String>,
    pub kind: Option<String>,
    pub name: Option<String>,
    pub ok: Option<bool>,
    pub start: Option<bool>,
    pub state: Option<String>,
    pub stop: Option<bool>,
    pub why: Option<String>,
}

/// PlanetCreateData is the typed request payload for Planet.create.
#[derive(Debug, Clone)]
pub struct PlanetCreateData {
    pub diameter: f64,
    pub forbid: Option<bool>,
    pub id: String,
    pub kind: String,
    pub name: String,
    pub ok: Option<bool>,
    pub start: Option<bool>,
    pub state: Option<String>,
    pub stop: Option<bool>,
    pub why: Option<String>,
}

/// PlanetUpdateData is the typed request payload for Planet.update.
#[derive(Debug, Clone)]
pub struct PlanetUpdateData {
    pub id: String,
    pub diameter: Option<f64>,
    pub forbid: Option<bool>,
    pub kind: Option<String>,
    pub name: Option<String>,
    pub ok: Option<bool>,
    pub start: Option<bool>,
    pub state: Option<String>,
    pub stop: Option<bool>,
    pub why: Option<String>,
}

/// PlanetRemoveMatch is the typed request payload for Planet.remove.
#[derive(Debug, Clone)]
pub struct PlanetRemoveMatch {
    pub id: String,
}

