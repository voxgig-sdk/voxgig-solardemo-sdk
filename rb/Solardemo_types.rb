# frozen_string_literal: true

# Typed models for the Solardemo SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Member types come from the
# canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
# @voxgig/apidef VALID_CANON). Ruby types are unenforced; these YARD
# annotations document the shapes. Do not edit by hand.

# Moon entity data model.
#
# @!attribute [rw] diameter
#   @return [Float]
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] kind
#   @return [String]
#
# @!attribute [rw] name
#   @return [String]
#
# @!attribute [rw] planet_id
#   @return [String]
Moon = Struct.new(
  :diameter,
  :id,
  :kind,
  :name,
  :planet_id,
  keyword_init: true
)

# Request payload for Moon#load.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] planet_id
#   @return [String]
MoonLoadMatch = Struct.new(
  :id,
  :planet_id,
  keyword_init: true
)

# Request payload for Moon#list.
#
# @!attribute [rw] planet_id
#   @return [String]
MoonListMatch = Struct.new(
  :planet_id,
  keyword_init: true
)

# Request payload for Moon#create.
#
# @!attribute [rw] planet_id
#   @return [String]
#
# @!attribute [rw] diameter
#   @return [Float]
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] kind
#   @return [String]
#
# @!attribute [rw] name
#   @return [String]
MoonCreateData = Struct.new(
  :planet_id,
  :diameter,
  :id,
  :kind,
  :name,
  keyword_init: true
)

# Request payload for Moon#update.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] planet_id
#   @return [String]
#
# @!attribute [rw] diameter
#   @return [Float, nil]
#
# @!attribute [rw] kind
#   @return [String, nil]
#
# @!attribute [rw] name
#   @return [String, nil]
MoonUpdateData = Struct.new(
  :id,
  :planet_id,
  :diameter,
  :kind,
  :name,
  keyword_init: true
)

# Request payload for Moon#remove.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] planet_id
#   @return [String]
MoonRemoveMatch = Struct.new(
  :id,
  :planet_id,
  keyword_init: true
)

# Planet entity data model.
#
# @!attribute [rw] diameter
#   @return [Float]
#
# @!attribute [rw] forbidReason
#   @return [String, nil]
#
# @!attribute [rw] forbidState
#   @return [String, nil]
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] kind
#   @return [String]
#
# @!attribute [rw] name
#   @return [String]
#
# @!attribute [rw] terraformState
#   @return [String, nil]
Planet = Struct.new(
  :diameter,
  :forbidReason,
  :forbidState,
  :id,
  :kind,
  :name,
  :terraformState,
  keyword_init: true
)

# Request payload for Planet#load.
#
# @!attribute [rw] id
#   @return [String]
PlanetLoadMatch = Struct.new(
  :id,
  keyword_init: true
)

# Request payload for Planet#list.
#
# @!attribute [rw] diameter
#   @return [Float, nil]
#
# @!attribute [rw] forbidReason
#   @return [String, nil]
#
# @!attribute [rw] forbidState
#   @return [String, nil]
#
# @!attribute [rw] id
#   @return [String, nil]
#
# @!attribute [rw] kind
#   @return [String, nil]
#
# @!attribute [rw] name
#   @return [String, nil]
#
# @!attribute [rw] terraformState
#   @return [String, nil]
PlanetListMatch = Struct.new(
  :diameter,
  :forbidReason,
  :forbidState,
  :id,
  :kind,
  :name,
  :terraformState,
  keyword_init: true
)

# Request payload for Planet#create.
#
# @!attribute [rw] diameter
#   @return [Float]
#
# @!attribute [rw] forbidReason
#   @return [String, nil]
#
# @!attribute [rw] forbidState
#   @return [String, nil]
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] kind
#   @return [String]
#
# @!attribute [rw] name
#   @return [String]
#
# @!attribute [rw] terraformState
#   @return [String, nil]
PlanetCreateData = Struct.new(
  :diameter,
  :forbidReason,
  :forbidState,
  :id,
  :kind,
  :name,
  :terraformState,
  keyword_init: true
)

# Request payload for Planet#update.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] diameter
#   @return [Float, nil]
#
# @!attribute [rw] forbidReason
#   @return [String, nil]
#
# @!attribute [rw] forbidState
#   @return [String, nil]
#
# @!attribute [rw] kind
#   @return [String, nil]
#
# @!attribute [rw] name
#   @return [String, nil]
#
# @!attribute [rw] terraformState
#   @return [String, nil]
PlanetUpdateData = Struct.new(
  :id,
  :diameter,
  :forbidReason,
  :forbidState,
  :kind,
  :name,
  :terraformState,
  keyword_init: true
)

# Request payload for Planet#remove.
#
# @!attribute [rw] id
#   @return [String]
PlanetRemoveMatch = Struct.new(
  :id,
  keyword_init: true
)

