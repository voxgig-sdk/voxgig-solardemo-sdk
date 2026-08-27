-- Typed models for the Solardemo SDK (LuaLS annotations).
--
-- GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
-- params (op.<name>.points[].args.params[]). Field/param types come from the
-- canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
-- @voxgig/apidef VALID_CANON). Annotations only — no runtime effect. Do not
-- edit by hand.

---@class Moon
---@field diameter number
---@field id string
---@field kind string
---@field name string
---@field planet_id string

---@class MoonLoadMatch
---@field id string
---@field planet_id string

---@class MoonListMatch
---@field planet_id string

---@class MoonCreateData
---@field planet_id string
---@field diameter number
---@field id string
---@field kind string
---@field name string

---@class MoonUpdateData
---@field id string
---@field planet_id string
---@field diameter? number
---@field kind? string
---@field name? string

---@class MoonRemoveMatch
---@field id string
---@field planet_id string

---@class Planet
---@field diameter number
---@field forbid? boolean
---@field id string
---@field kind string
---@field name string
---@field ok? boolean
---@field start? boolean
---@field state? string
---@field stop? boolean
---@field why? string

---@class PlanetLoadMatch
---@field id string

---@class PlanetListMatch
---@field diameter? number
---@field forbid? boolean
---@field id? string
---@field kind? string
---@field name? string
---@field ok? boolean
---@field start? boolean
---@field state? string
---@field stop? boolean
---@field why? string

---@class PlanetCreateData
---@field diameter number
---@field forbid? boolean
---@field id string
---@field kind string
---@field name string
---@field ok? boolean
---@field start? boolean
---@field state? string
---@field stop? boolean
---@field why? string

---@class PlanetUpdateData
---@field id string
---@field diameter? number
---@field forbid? boolean
---@field kind? string
---@field name? string
---@field ok? boolean
---@field start? boolean
---@field state? string
---@field stop? boolean
---@field why? string

---@class PlanetRemoveMatch
---@field id string

local M = {}

return M
