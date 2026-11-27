-- VoxgigSolardemo SDK utility: prepare_auth

-- This SDK is configured with authentication off, so there is no credential
-- to place. The function stays in the pipeline because make_spec calls it
-- unconditionally.
local function prepare_auth_util(ctx)
  local spec = ctx.spec
  if spec == nil then
    return nil, ctx:make_error("auth_no_spec",
      "Expected context spec property to be defined.")
  end

  return spec, nil
end

return prepare_auth_util
