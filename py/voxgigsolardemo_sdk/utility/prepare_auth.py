# VoxgigSolardemo SDK utility: prepare_auth

from __future__ import annotations


# This SDK is configured with authentication off, so there is no credential
# to place. The function stays in the pipeline because make_spec calls it
# unconditionally.
def prepare_auth_util(ctx):
    spec = ctx.spec
    if spec is None:
        return None, ctx.make_error("auth_no_spec",
            "Expected context spec property to be defined.")

    return spec, None
