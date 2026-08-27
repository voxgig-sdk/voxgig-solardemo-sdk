# Solardemo SDK Moon entity
#
# Per-entity module. Generic construction/data/match operations delegate to
# EntityBase; each active op (load/list/create/update/remove) builds a ctx
# and drives it through Solardemo.Pipeline.run_op.

defmodule Solardemo.Entity.Moon do
  alias Voxgig.Struct, as: S
  alias Solardemo.Helpers, as: H
  alias Solardemo.{EntityBase, Context, Pipeline}

  def new(client, entopts \\ nil) do
    EntityBase.construct(__MODULE__, client, "moon", entopts)
  end

  def get_name(ent), do: EntityBase.get_name(ent)
  def make(ent), do: EntityBase.make(ent)
  def data_set(ent, args \\ nil), do: EntityBase.data_set(ent, args)
  def data_get(ent), do: EntityBase.data_get(ent)
  def match_set(ent, args \\ nil), do: EntityBase.match_set(ent, args)
  def match_get(ent), do: EntityBase.match_get(ent)

  # Streaming operation (see EntityBase.stream): runs `action` through the
  # pipeline and returns a lazy Stream over result items.
  def stream(ent, action, args \\ nil, callopts \\ nil),
    do: EntityBase.stream(ent, action, args, callopts)

  
  # Returns the moon entity map (Solardemo.Types.moon/0) on
  # success; pipeline errors surface as the error value built by
  # Utility.make_error (shape is utility-configurable), hence term().
  @spec load(map(), Solardemo.Types.moon_load_match() | nil, map() | nil) :: term()
  def load(ent, reqmatch \\ nil, ctrl \\ nil) do
    reqmatch = if reqmatch == nil, do: S.jm([]), else: reqmatch

    ctx =
      Context.new(
        S.jm([
          "opname", "load",
          "ctrl", ctrl,
          "match", S.getprop(ent, "_match"),
          "data", S.getprop(ent, "_data"),
          "reqmatch", reqmatch
        ]),
        S.getprop(ent, "_entctx")
      )

    post_done = fn ->
      result = S.getprop(ctx, "result")

      if result != nil do
        rm = S.getprop(result, "resmatch")
        if rm != nil, do: S.setprop(ent, "_match", rm)
        rd = S.getprop(result, "resdata")
        if rd != nil, do: S.setprop(ent, "_data", H.or_(H.to_map(S.clone(rd)), S.jm([])))
      end
    end

    out = Pipeline.run_op(ctx, post_done)
    EntityBase.op_return(ent, ctx, out)
  end



  
  # Returns a list of moon entity maps (Solardemo.Types.moon/0)
  # on success; pipeline errors surface as the error value built by
  # Utility.make_error (shape is utility-configurable), hence term().
  @spec list(map(), Solardemo.Types.moon_list_match() | nil, map() | nil) :: term()
  def list(ent, reqmatch \\ nil, ctrl \\ nil) do
    reqmatch = if reqmatch == nil, do: S.jm([]), else: reqmatch

    ctx =
      Context.new(
        S.jm([
          "opname", "list",
          "ctrl", ctrl,
          "match", S.getprop(ent, "_match"),
          "data", S.getprop(ent, "_data"),
          "reqmatch", reqmatch
        ]),
        S.getprop(ent, "_entctx")
      )

    post_done = fn ->
      result = S.getprop(ctx, "result")

      if result != nil do
        rm = S.getprop(result, "resmatch")
        if rm != nil, do: S.setprop(ent, "_match", rm)
      end
    end

    # `list` resolves to one ENTITY per record — make_result builds them.
    Pipeline.run_op(ctx, post_done)
  end



  
  # Returns the created moon entity map (Solardemo.Types.moon/0)
  # on success; pipeline errors surface as the error value built by
  # Utility.make_error (shape is utility-configurable), hence term().
  @spec create(map(), Solardemo.Types.moon_create_data() | nil, map() | nil) :: term()
  def create(ent, reqdata, ctrl \\ nil) do
    ctx =
      Context.new(
        S.jm([
          "opname", "create",
          "ctrl", ctrl,
          "match", S.getprop(ent, "_match"),
          "data", S.getprop(ent, "_data"),
          "reqdata", reqdata
        ]),
        S.getprop(ent, "_entctx")
      )

    post_done = fn ->
      result = S.getprop(ctx, "result")

      if result != nil do
        rd = S.getprop(result, "resdata")
        if rd != nil, do: S.setprop(ent, "_data", H.or_(H.to_map(S.clone(rd)), S.jm([])))
      end
    end

    out = Pipeline.run_op(ctx, post_done)
    EntityBase.op_return(ent, ctx, out)
  end



  
  # Returns the updated moon entity map (Solardemo.Types.moon/0)
  # on success; pipeline errors surface as the error value built by
  # Utility.make_error (shape is utility-configurable), hence term().
  @spec update(map(), Solardemo.Types.moon_update_data() | nil, map() | nil) :: term()
  def update(ent, reqdata, ctrl \\ nil) do
    ctx =
      Context.new(
        S.jm([
          "opname", "update",
          "ctrl", ctrl,
          "match", S.getprop(ent, "_match"),
          "data", S.getprop(ent, "_data"),
          "reqdata", reqdata
        ]),
        S.getprop(ent, "_entctx")
      )

    post_done = fn ->
      result = S.getprop(ctx, "result")

      if result != nil do
        rm = S.getprop(result, "resmatch")
        if rm != nil, do: S.setprop(ent, "_match", rm)
        rd = S.getprop(result, "resdata")
        if rd != nil, do: S.setprop(ent, "_data", H.or_(H.to_map(S.clone(rd)), S.jm([])))
      end
    end

    out = Pipeline.run_op(ctx, post_done)
    EntityBase.op_return(ent, ctx, out)
  end



  
  # Returns the removed moon entity map (Solardemo.Types.moon/0)
  # on success; pipeline errors surface as the error value built by
  # Utility.make_error (shape is utility-configurable), hence term().
  @spec remove(map(), Solardemo.Types.moon_remove_match() | nil, map() | nil) :: term()
  def remove(ent, reqmatch \\ nil, ctrl \\ nil) do
    reqmatch = if reqmatch == nil, do: S.jm([]), else: reqmatch

    ctx =
      Context.new(
        S.jm([
          "opname", "remove",
          "ctrl", ctrl,
          "match", S.getprop(ent, "_match"),
          "data", S.getprop(ent, "_data"),
          "reqmatch", reqmatch
        ]),
        S.getprop(ent, "_entctx")
      )

    post_done = fn ->
      result = S.getprop(ctx, "result")

      if result != nil do
        rm = S.getprop(result, "resmatch")
        if rm != nil, do: S.setprop(ent, "_match", rm)
        rd = S.getprop(result, "resdata")
        if rd != nil, do: S.setprop(ent, "_data", H.or_(H.to_map(S.clone(rd)), S.jm([])))
      end
    end

    out = Pipeline.run_op(ctx, post_done)
    ent = EntityBase.op_return(ent, ctx, out)
    # A removed entity keeps its data but is no longer a live record.
    if ent == out, do: out, else: EntityBase.mark_deleted(ent)
  end


end
