
// This SDK is configured with authentication off, so there is no credential
// to place. The function stays in the pipeline because makeSpec calls it
// unconditionally.
function prepareAuth(ctx) {
  const spec = ctx.spec

  if (null == spec) {
    return ctx.error('auth_no_spec', 'Expected context spec property to be defined.')
  }

  return spec
}

module.exports = {
  prepareAuth
}
