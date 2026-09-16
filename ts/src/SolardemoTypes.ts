// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.

export interface Moon {
  diameter: number
  id: string
  kind: string
  name: string
  planet_id: string
}

export interface MoonLoadMatch {
  id: string
  planet_id: string
}

export interface MoonListMatch {
  planet_id: string
}

export interface MoonCreateData {
  planet_id: string
  diameter: number
  id: string
  kind: string
  name: string
}

export interface MoonUpdateData {
  id: string
  planet_id: string
  diameter?: number
  kind?: string
  name?: string
}

export interface MoonRemoveMatch {
  id: string
  planet_id: string
}

export interface Planet {
  diameter: number
  forbidReason?: string
  forbidState?: string
  id: string
  kind: string
  name: string
  terraformState?: string
}

export interface PlanetLoadMatch {
  id: string
}

export interface PlanetListMatch {
  diameter?: number
  forbidReason?: string
  forbidState?: string
  id?: string
  kind?: string
  name?: string
  terraformState?: string
}

export interface PlanetCreateData {
  diameter: number
  forbidReason?: string
  forbidState?: string
  id: string
  kind: string
  name: string
  terraformState?: string

  // Selects a custom action instead of the plain create:
  //   'forbid' | 'terraform'
  // The remaining keys are that action's own payload.
  $action?: string
  [action: string]: any
}

export interface PlanetUpdateData {
  id: string
  diameter?: number
  forbidReason?: string
  forbidState?: string
  kind?: string
  name?: string
  terraformState?: string
}

export interface PlanetRemoveMatch {
  id: string
}

