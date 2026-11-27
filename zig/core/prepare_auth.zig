// prepare_auth — GENERATED from the model (src/cmp/zig/PrepareAuth_zig.ts),
// not copied from tm/zig, because WHERE THE CREDENTIAL GOES IS A FACT ABOUT
// THIS API. apidef resolves the security scheme's `in` and `name` into
// main.kit.info.security; a template can hold only one answer, and the one it
// held was an `authorization` header, so an apiKey-in-query API was sent a
// header it does not read and never sent the query parameter it does.
//
// This function used to live in core/utility.zig. It is re-exported from
// there (`pub const prepare_auth_util = @import("prepare_auth.zig")...`), so
// Utility.prepare_auth, make_spec_util and sdk.utilmod.prepare_auth_util all
// still reach the same symbol.
//
// THIS SDK SENDS NO CREDENTIAL: it is configured with authentication off.
// The function stays in the pipeline because make_spec calls
// it unconditionally.

const h = @import("helpers.zig");
const ctxmod = @import("context.zig");
const spec_mod = @import("spec.zig");

const Context = ctxmod.Context;
const Spec = spec_mod.Spec;
const E = h.E;

/// WHERE this SDK places its credential: "header", "query", "cookie", or
/// "none" when this SDK is configured with authentication off.
pub const PLACEMENT = "none";

/// True when the scheme is genuine HTTP Basic - two credentials, base64-joined
/// - rather than a single token. Header-only by definition, so false for every
/// other placement.
pub const BASIC = false;

pub fn prepare_auth_util(ctx: *Context) E!*Spec {
    const spec = ctx.spec orelse return ctx.fail("auth_no_spec", "Expected context spec property to be defined.");
    return spec;
}
