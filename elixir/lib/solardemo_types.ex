# Typed models for the Solardemo SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Member types come from the
# canonical type sentinels. The SDK carries data as string-keyed struct value
# nodes, so each alias is an open string-keyed map; the @typedoc member lists
# document the concrete shapes. Do not edit by hand.

defmodule Solardemo.Types do
  @moduledoc """
  Documented shapes for the Solardemo SDK entities and operation payloads.

  Every alias resolves to an open string-keyed map because the SDK carries
  data as string-keyed struct value nodes; consult each type's member list for
  the concrete field/param types.
  """

  @typedoc """
  Moon entity data model.

  Members:
    * `"diameter"` — float() (required)
    * `"id"` — String.t() (required)
    * `"kind"` — String.t() (required)
    * `"name"` — String.t() (required)
    * `"planet_id"` — String.t() (required)
  """
  @type moon :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Moon load.

  Members:
    * `"id"` — String.t() (required)
    * `"planet_id"` — String.t() (required)
  """
  @type moon_load_match :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Moon list.

  Members:
    * `"planet_id"` — String.t() (required)
  """
  @type moon_list_match :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Moon create.

  Members:
    * `"planet_id"` — String.t() (required)
    * `"diameter"` — float() (required)
    * `"id"` — String.t() (required)
    * `"kind"` — String.t() (required)
    * `"name"` — String.t() (required)
  """
  @type moon_create_data :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Moon update.

  Members:
    * `"id"` — String.t() (required)
    * `"planet_id"` — String.t() (required)
    * `"diameter"` — float() (optional)
    * `"kind"` — String.t() (optional)
    * `"name"` — String.t() (optional)
  """
  @type moon_update_data :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Moon remove.

  Members:
    * `"id"` — String.t() (required)
    * `"planet_id"` — String.t() (required)
  """
  @type moon_remove_match :: %{optional(String.t()) => any()}

  @typedoc """
  Planet entity data model.

  Members:
    * `"diameter"` — float() (required)
    * `"forbid"` — boolean() (optional)
    * `"id"` — String.t() (required)
    * `"kind"` — String.t() (required)
    * `"name"` — String.t() (required)
    * `"ok"` — boolean() (optional)
    * `"start"` — boolean() (optional)
    * `"state"` — String.t() (optional)
    * `"stop"` — boolean() (optional)
    * `"why"` — String.t() (optional)
  """
  @type planet :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Planet load.

  Members:
    * `"id"` — String.t() (required)
  """
  @type planet_load_match :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Planet list.

  Members:
    * `"diameter"` — float() (optional)
    * `"forbid"` — boolean() (optional)
    * `"id"` — String.t() (optional)
    * `"kind"` — String.t() (optional)
    * `"name"` — String.t() (optional)
    * `"ok"` — boolean() (optional)
    * `"start"` — boolean() (optional)
    * `"state"` — String.t() (optional)
    * `"stop"` — boolean() (optional)
    * `"why"` — String.t() (optional)
  """
  @type planet_list_match :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Planet create.

  Members:
    * `"diameter"` — float() (required)
    * `"forbid"` — boolean() (optional)
    * `"id"` — String.t() (required)
    * `"kind"` — String.t() (required)
    * `"name"` — String.t() (required)
    * `"ok"` — boolean() (optional)
    * `"start"` — boolean() (optional)
    * `"state"` — String.t() (optional)
    * `"stop"` — boolean() (optional)
    * `"why"` — String.t() (optional)
  """
  @type planet_create_data :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Planet update.

  Members:
    * `"id"` — String.t() (required)
    * `"diameter"` — float() (optional)
    * `"forbid"` — boolean() (optional)
    * `"kind"` — String.t() (optional)
    * `"name"` — String.t() (optional)
    * `"ok"` — boolean() (optional)
    * `"start"` — boolean() (optional)
    * `"state"` — String.t() (optional)
    * `"stop"` — boolean() (optional)
    * `"why"` — String.t() (optional)
  """
  @type planet_update_data :: %{optional(String.t()) => any()}

  @typedoc """
  Request payload for Planet remove.

  Members:
    * `"id"` — String.t() (required)
  """
  @type planet_remove_match :: %{optional(String.t()) => any()}

end
