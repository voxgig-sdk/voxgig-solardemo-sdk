# VoxgigSolardemo SDK utility: prepare_auth
#
# WHERE THE CREDENTIAL GOES IS A FACT ABOUT THE API, so this module is
# GENERATED from the model rather than copied from tm/. Do not edit by hand.
#
# Extracted from VoxgigSolardemo.Utility, which still owns the registration
# (`{"prepare_auth", &PrepareAuth.prepare_auth_impl/1}`) and the
# `prepare_auth/1` dispatch wrapper every caller goes through. A feature that
# overrides the utility slot overrides this, exactly as before.

defmodule VoxgigSolardemo.PrepareAuth do
  alias Voxgig.Struct, as: S
  alias VoxgigSolardemo.Context

  # This SDK is configured with authentication off, so there is no
  # credential to place. The function stays in the pipeline because
  # make_spec calls it unconditionally and Utility registers it
  # unconditionally.
  def prepare_auth_impl(ctx) do
    spec = S.getprop(ctx, "spec")

    if spec == nil do
      {nil, Context.make_error(ctx, "auth_no_spec", "Expected context spec property to be defined.")}
    else
      {spec, nil}
    end
  end
end
