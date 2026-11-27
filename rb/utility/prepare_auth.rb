# VoxgigSolardemo SDK utility: prepare_auth
require_relative 'struct/voxgig_struct'
module VoxgigSolardemoUtilities
  # This SDK is configured with authentication off, so there is no
  # credential to place. The utility stays in the pipeline because make_spec
  # calls it unconditionally, and register.rb binds it unconditionally.
  PrepareAuth = ->(ctx) {
    spec = ctx.spec
    return nil, ctx.make_error("auth_no_spec", "Expected context spec property to be defined.") unless spec

    return spec, nil
  }
end
