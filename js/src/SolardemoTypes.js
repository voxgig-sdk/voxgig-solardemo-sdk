// Typed models for the Solardemo SDK (JSDoc typedefs).
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Annotations only — no runtime effect. Do not
// edit by hand.

/**
 * @typedef {Object} Moon
 * @property {number} diameter
 * @property {string} id
 * @property {string} kind
 * @property {string} name
 * @property {string} planet_id
 */

/**
 * @typedef {Object} MoonLoadMatch
 * @property {string} id
 * @property {string} planet_id
 */

/**
 * @typedef {Object} MoonListMatch
 * @property {string} planet_id
 */

/**
 * @typedef {Object} MoonCreateData
 * @property {string} planet_id
 * @property {number} diameter
 * @property {string} id
 * @property {string} kind
 * @property {string} name
 */

/**
 * @typedef {Object} MoonUpdateData
 * @property {string} id
 * @property {string} planet_id
 * @property {number} [diameter]
 * @property {string} [kind]
 * @property {string} [name]
 */

/**
 * @typedef {Object} MoonRemoveMatch
 * @property {string} id
 * @property {string} planet_id
 */

/**
 * @typedef {Object} Planet
 * @property {number} diameter
 * @property {boolean} [forbid]
 * @property {string} id
 * @property {string} kind
 * @property {string} name
 * @property {boolean} [ok]
 * @property {boolean} [start]
 * @property {string} [state]
 * @property {boolean} [stop]
 * @property {string} [why]
 */

/**
 * @typedef {Object} PlanetLoadMatch
 * @property {string} id
 */

/**
 * @typedef {Object} PlanetListMatch
 * @property {number} [diameter]
 * @property {boolean} [forbid]
 * @property {string} [id]
 * @property {string} [kind]
 * @property {string} [name]
 * @property {boolean} [ok]
 * @property {boolean} [start]
 * @property {string} [state]
 * @property {boolean} [stop]
 * @property {string} [why]
 */

/**
 * @typedef {Object} PlanetCreateData
 * @property {number} diameter
 * @property {boolean} [forbid]
 * @property {string} id
 * @property {string} kind
 * @property {string} name
 * @property {boolean} [ok]
 * @property {boolean} [start]
 * @property {string} [state]
 * @property {boolean} [stop]
 * @property {string} [why]
 */

/**
 * @typedef {Object} PlanetUpdateData
 * @property {string} id
 * @property {number} [diameter]
 * @property {boolean} [forbid]
 * @property {string} [kind]
 * @property {string} [name]
 * @property {boolean} [ok]
 * @property {boolean} [start]
 * @property {string} [state]
 * @property {boolean} [stop]
 * @property {string} [why]
 */

/**
 * @typedef {Object} PlanetRemoveMatch
 * @property {string} id
 */

