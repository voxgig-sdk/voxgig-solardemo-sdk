// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.
package entity

import (
	"encoding/json"

	"github.com/voxgig-sdk/solardemo-sdk/go/core"
)

// Moon is the typed data model for the moon entity.
type Moon struct {
	Diameter float64 `json:"diameter"`
	Id string `json:"id"`
	Kind string `json:"kind"`
	Name string `json:"name"`
	PlanetId string `json:"planet_id"`
}

// MoonLoadMatch is the typed request payload for Moon.LoadTyped.
type MoonLoadMatch struct {
	Id string `json:"id"`
	PlanetId string `json:"planet_id"`
}

// MoonListMatch is the typed request payload for Moon.ListTyped.
type MoonListMatch struct {
	PlanetId string `json:"planet_id"`
}

// MoonCreateData is the typed request payload for Moon.CreateTyped.
type MoonCreateData struct {
	PlanetId string `json:"planet_id"`
	Diameter float64 `json:"diameter"`
	Id string `json:"id"`
	Kind string `json:"kind"`
	Name string `json:"name"`
}

// MoonUpdateData is the typed request payload for Moon.UpdateTyped.
type MoonUpdateData struct {
	Id string `json:"id"`
	PlanetId string `json:"planet_id"`
	Diameter *float64 `json:"diameter,omitempty"`
	Kind *string `json:"kind,omitempty"`
	Name *string `json:"name,omitempty"`
}

// MoonRemoveMatch is the typed request payload for Moon.RemoveTyped.
type MoonRemoveMatch struct {
	Id string `json:"id"`
	PlanetId string `json:"planet_id"`
}

// Planet is the typed data model for the planet entity.
type Planet struct {
	Diameter float64 `json:"diameter"`
	Forbid *bool `json:"forbid,omitempty"`
	Id string `json:"id"`
	Kind string `json:"kind"`
	Name string `json:"name"`
	Ok *bool `json:"ok,omitempty"`
	Start *bool `json:"start,omitempty"`
	State *string `json:"state,omitempty"`
	Stop *bool `json:"stop,omitempty"`
	Why *string `json:"why,omitempty"`
}

// PlanetLoadMatch is the typed request payload for Planet.LoadTyped.
type PlanetLoadMatch struct {
	Id string `json:"id"`
}

// PlanetListMatch is the typed request payload for Planet.ListTyped.
type PlanetListMatch struct {
	Diameter *float64 `json:"diameter,omitempty"`
	Forbid *bool `json:"forbid,omitempty"`
	Id *string `json:"id,omitempty"`
	Kind *string `json:"kind,omitempty"`
	Name *string `json:"name,omitempty"`
	Ok *bool `json:"ok,omitempty"`
	Start *bool `json:"start,omitempty"`
	State *string `json:"state,omitempty"`
	Stop *bool `json:"stop,omitempty"`
	Why *string `json:"why,omitempty"`
}

// PlanetCreateData is the typed request payload for Planet.CreateTyped.
type PlanetCreateData struct {
	Diameter float64 `json:"diameter"`
	Forbid *bool `json:"forbid,omitempty"`
	Id string `json:"id"`
	Kind string `json:"kind"`
	Name string `json:"name"`
	Ok *bool `json:"ok,omitempty"`
	Start *bool `json:"start,omitempty"`
	State *string `json:"state,omitempty"`
	Stop *bool `json:"stop,omitempty"`
	Why *string `json:"why,omitempty"`
}

// PlanetUpdateData is the typed request payload for Planet.UpdateTyped.
type PlanetUpdateData struct {
	Id string `json:"id"`
	Diameter *float64 `json:"diameter,omitempty"`
	Forbid *bool `json:"forbid,omitempty"`
	Kind *string `json:"kind,omitempty"`
	Name *string `json:"name,omitempty"`
	Ok *bool `json:"ok,omitempty"`
	Start *bool `json:"start,omitempty"`
	State *string `json:"state,omitempty"`
	Stop *bool `json:"stop,omitempty"`
	Why *string `json:"why,omitempty"`
}

// PlanetRemoveMatch is the typed request payload for Planet.RemoveTyped.
type PlanetRemoveMatch struct {
	Id string `json:"id"`
}

// asMap turns a typed request/data struct into the map[string]any the
// runtime op pipeline consumes, honouring the json tags above.
func asMap(v any) map[string]any {
	out := map[string]any{}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}

// entityData unwraps an entity to its data map.
//
// Operations resolve to the ENTITY, not the raw data (see AGENTS.md), and an
// entity's fields are UNEXPORTED — marshalling one directly yields `{}`, so
// every typed accessor would silently hand back a zero-valued struct. The
// typed boundary therefore takes the data hop first.
func entityData(v any) any {
	if ent, ok := v.(core.Entity); ok {
		return ent.Data()
	}
	return v
}

// typedFrom decodes a runtime value (an entity, or the map[string]any the op
// pipeline produced) into a typed model T via a JSON round-trip. On any error
// it returns the zero value of T; the op's own (value, error) tuple carries
// the real error.
func typedFrom[T any](v any) T {
	var out T
	v = entityData(v)
	if v == nil {
		return out
	}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}

// typedSliceFrom decodes a runtime list value into a typed slice []T via a
// JSON round-trip, for list ops. `list` resolves to a slice of ENTITY
// instances, so each element takes the data hop.
func typedSliceFrom[T any](v any) []T {
	var out []T
	if v == nil {
		return out
	}
	if list, ok := v.([]any); ok {
		unwrapped := make([]any, 0, len(list))
		for _, item := range list {
			unwrapped = append(unwrapped, entityData(item))
		}
		v = unwrapped
	}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}
