// Moon entity client (generated — mirrors the go/rust Entity fragment).

const std = @import("std");
const vs = @import("voxgig-struct");
const h = @import("../core/helpers.zig");
const errmod = @import("../core/error.zig");
const types = @import("../core/types.zig");
const ctxmod = @import("../core/context.zig");
const utility_mod = @import("../core/utility.zig");
const sdk = @import("../core/sdk.zig");

const Value = h.Value;
const Context = ctxmod.Context;
const CtxSpec = ctxmod.CtxSpec;
const Utility = utility_mod.Utility;
const OpResult = types.OpResult;
const StreamResult = types.StreamResult;
const OutVal = types.OutVal;
const Entity = types.Entity;

// Every operation resolves to the ENTITY, not the raw data — `list` to a
// slice of them, one per record; the record is reached through `data()`.
//
// `Value` cannot carry an entity (it is a closed data union) and the shared
// `OpResult` cannot name a per-entity type, so each entity declares its own
// result unions and the CONTRACT lives in those signatures.
pub const EntResult = union(enum) {
    ok: *MoonEntity,
    err: *errmod.VoxgigSolardemoError,
};

pub const EntListResult = union(enum) {
    ok: []*MoonEntity,
    err: *errmod.VoxgigSolardemoError,
};

pub const MoonEntity = struct {
    name: []const u8 = "moon",
    client: *sdk.VoxgigSolardemoSDK,
    utility: *Utility,
    entopts: Value,
    data: Value,
    mtch: Value,
    entctx: ?*Context = null,
    // Set when a remove marks this instance deleted.
    deleted: bool = false,

    pub fn new(client: *sdk.VoxgigSolardemoSDK, entopts_in: Value) *MoonEntity {
        const entopts: Value = switch (entopts_in) {
            .object => entopts_in,
            else => h.omap(),
        };
        const act = h.get_bool(entopts, "active");
        if (act == null) {
            h.setp(entopts, "active", h.vbool(true));
        } else if (act.? != false) {
            h.setp(entopts, "active", h.vbool(true));
        }

        const e = h.A().create(MoonEntity) catch unreachable;
        e.* = .{
            .name = "moon",
            .client = client,
            .utility = client.get_utility(),
            .entopts = entopts,
            .data = h.omap(),
            .mtch = h.omap(),
            .entctx = null,
        };

        const entctx = e.utility.make_context(CtxSpec{
            .entity = e.asEntity(),
            .entopts = entopts,
        }, client.get_root_ctx());

        e.utility.feature_hook(entctx, "PostConstructEntity");
        e.entctx = entctx;
        return e;
    }

    fn ent_ctx(self: *MoonEntity) *Context {
        return self.entctx orelse unreachable;
    }

    fn opError(self: *MoonEntity, ctx: *Context) OpResult {
        const v = self.utility.make_error(ctx) catch return .{ .err = ctx.pending_err.? };
        return .{ .ok = v };
    }

    fn doneResult(self: *MoonEntity, ctx: *Context) OpResult {
        const v = self.utility.done(ctx) catch return .{ .err = ctx.pending_err.? };
        return .{ .ok = v };
    }

    // Runs the pipeline and hands back THIS entity: run_op has just absorbed
    // the result into it.
    fn run_op_ent(self: *MoonEntity, ctx: *Context, post_done: *const fn (*MoonEntity, *Context) void) EntResult {
        return switch (self.run_op(ctx, post_done)) {
            .err => |e| EntResult{ .err = e },
            .ok => EntResult{ .ok = self },
        };
    }

    // A remove resolves to the entity, marked deleted. The instance KEEPS the
    // data it held — a caller can still read what was deleted — but it is no
    // longer a live record.
    pub fn mark_deleted(self: *MoonEntity) void {
        self.deleted = true;
    }

    pub fn is_deleted(self: *MoonEntity) bool {
        return self.deleted;
    }

    fn run_op(self: *MoonEntity, ctx: *Context, post_done: *const fn (*MoonEntity, *Context) void) OpResult {
        const utility = self.utility;

        self.utility.feature_hook(ctx, "PrePoint");
        const point = utility.make_point(ctx) catch return self.opError(ctx);
        ctx.out_set("point", OutVal{ .val = point });

        self.utility.feature_hook(ctx, "PreSpec");
        const spec = utility.make_spec(ctx) catch return self.opError(ctx);
        ctx.out_set("spec", OutVal{ .spec = spec });

        self.utility.feature_hook(ctx, "PreRequest");
        const resp = utility.make_request(ctx) catch return self.opError(ctx);
        ctx.out_set("request", OutVal{ .response = resp });

        self.utility.feature_hook(ctx, "PreResponse");
        const resp2 = utility.make_response(ctx) catch return self.opError(ctx);
        ctx.out_set("response", OutVal{ .response = resp2 });

        self.utility.feature_hook(ctx, "PreResult");
        const result = utility.make_result(ctx) catch return self.opError(ctx);
        ctx.out_set("result", OutVal{ .result = result });

        self.utility.feature_hook(ctx, "PreDone");
        post_done(self, ctx);

        return self.doneResult(ctx);
    }

    // What make_error or done hands back, as a stream: the error, or under
    // `throw: false` the data there is.
    fn streamItems(res: OpResult) StreamResult {
        const data = switch (res) {
            .err => |e| return .{ .err = e },
            .ok => |v| v,
        };
        if (data == .array) {
            return .{ .ok = data.array.data.items };
        } else if (!h.is_noval(data)) {
            var out: std.ArrayList(Value) = .empty;
            out.append(h.A(), data) catch {};
            return .{ .ok = out.toOwnedSlice(h.A()) catch &.{} };
        }
        return .{ .ok = &.{} };
    }

    /// Streaming operation. Runs `action` through the full pipeline and
    /// returns the result items, so the `streaming` feature's incremental
    /// output, when that feature is active, is reachable from a generated
    /// entity (a normal op call materialises the whole result). This runtime
    /// is synchronous and zig has no built-in lazy iterators, so the items
    /// are a materialised slice the caller walks; a failed operation is
    /// `.err`, as an operation's is. `callopts` parameterises the call:
    /// inbound yields the streaming feature's items when active, else the
    /// materialised items; `ctrl` threads pipeline control.
    pub fn stream(self: *MoonEntity, action: []const u8, args: Value, callopts: Value) StreamResult {
        const utility = self.utility;

        const stream_opts: Value = switch (callopts) {
            .object => callopts,
            else => h.omap(),
        };

        // A copy: the caller's ctrl gains no key, and explain stays its own record.
        const ctrl = h.omap();
        const given = h.to_map(h.getp(stream_opts, "ctrl"));
        if (given == .object) {
            var it = given.object.iterator();
            while (it.next()) |kv| h.setp(ctrl, kv.key_ptr.*, kv.value_ptr.*);
        }
        h.setp(ctrl, "stream", stream_opts);

        const reqmatch: Value = switch (args) {
            .object => args,
            else => h.omap(),
        };

        const ctx = utility.make_context(CtxSpec{
            .opname = action,
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqmatch = reqmatch,
        }, self.ent_ctx());

        // Run the same pipeline as run_op, firing the feature hooks (an
        // active streaming feature attaches result.stream on PreResult). A
        // failed step leaves through make_error, as an operation's does.
        utility.feature_hook(ctx, "PrePoint");
        const point = utility.make_point(ctx) catch return streamItems(self.opError(ctx));
        ctx.out_set("point", OutVal{ .val = point });

        utility.feature_hook(ctx, "PreSpec");
        const spec = utility.make_spec(ctx) catch return streamItems(self.opError(ctx));
        ctx.out_set("spec", OutVal{ .spec = spec });

        utility.feature_hook(ctx, "PreRequest");
        const resp = utility.make_request(ctx) catch return streamItems(self.opError(ctx));
        ctx.out_set("request", OutVal{ .response = resp });

        utility.feature_hook(ctx, "PreResponse");
        const resp2 = utility.make_response(ctx) catch return streamItems(self.opError(ctx));
        ctx.out_set("response", OutVal{ .response = resp2 });

        utility.feature_hook(ctx, "PreResult");
        const result = utility.make_result(ctx) catch return streamItems(self.opError(ctx));
        ctx.out_set("result", OutVal{ .result = result });

        utility.feature_hook(ctx, "PreDone");

        // Inbound: prefer the streaming feature's incremental producer; else
        // fall back to the materialised items so stream always yields.
        if (ctx.result) |res| {
            if (res.stream) |sf| {
                // done() does not run on this path, so its record is cleaned here.
                utility.clean_explain(ctx);
                return .{ .ok = sf.call(sf.ctx) };
            }
        }

        return streamItems(self.doneResult(ctx));
    }

    // ---- Entity interface ----

    fn e_of(p: *anyopaque) *MoonEntity {
        return @ptrCast(@alignCast(p));
    }
    fn v_get_name(p: *anyopaque) []const u8 {
        return e_of(p).name;
    }
    fn v_make(p: *anyopaque) Entity {
        const self = e_of(p);
        const opts = h.omap();
        if (self.entopts == .object) {
            var it = self.entopts.object.iterator();
            while (it.next()) |kv| h.setp(opts, kv.key_ptr.*, kv.value_ptr.*);
        }
        return MoonEntity.new(self.client, opts).asEntity();
    }
    fn v_data(p: *anyopaque, args: ?Value) Value {
        return e_of(p).data_impl(args);
    }
    fn v_matchv(p: *anyopaque, args: ?Value) Value {
        return e_of(p).matchv_impl(args);
    }

    const entity_vtable = Entity.VTable{
        .get_name = v_get_name,
        .make = v_make,
        .data = v_data,
        .matchv = v_matchv,
    };

    pub fn asEntity(self: *MoonEntity) Entity {
        return .{ .ptr = @ptrCast(self), .vtable = &entity_vtable };
    }

    fn data_impl(self: *MoonEntity, args: ?Value) Value {
        if (args) |arg| {
            if (!h.is_noval(arg)) {
                self.data = if (arg == .null) h.omap() else h.clone(arg);
                self.utility.feature_hook(self.ent_ctx(), "SetData");
            }
        }
        self.utility.feature_hook(self.ent_ctx(), "GetData");
        return h.clone(self.data);
    }

    fn matchv_impl(self: *MoonEntity, args: ?Value) Value {
        if (args) |arg| {
            if (!h.is_noval(arg)) {
                const cloned = h.to_map(h.clone(arg));
                self.mtch = switch (cloned) {
                    .object => cloned,
                    else => h.omap(),
                };
                self.utility.feature_hook(self.ent_ctx(), "SetMatch");
            }
        }
        self.utility.feature_hook(self.ent_ctx(), "GetMatch");
        return h.clone(self.mtch);
    }

    // ---- CRUD operations ----


    pub fn load(self: *MoonEntity, reqmatch: Value, ctrl: Value) EntResult {
        const ctx = self.utility.make_context(CtxSpec{
            .opname = "load",
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqmatch = reqmatch,
        }, self.ent_ctx());
        return self.run_op_ent(ctx, load_post_done);
    }
    
    fn load_post_done(self: *MoonEntity, ctx: *Context) void {
        if (ctx.result) |result| {
            const resmatch = result.resmatch;
            const resdata = result.resdata;
            if (resmatch == .object) self.mtch = resmatch;
            if (!h.is_noval(resdata)) {
                const cm = h.to_map(h.clone(resdata));
                self.data = if (cm == .object) cm else h.omap();
            }
        }
    }
    


    pub fn list(self: *MoonEntity, reqmatch: Value, ctrl: Value) EntListResult {
        const ctx = self.utility.make_context(CtxSpec{
            .opname = "list",
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqmatch = reqmatch,
        }, self.ent_ctx());
        const out = switch (self.run_op(ctx, list_post_done)) {
            .err => |e| return EntListResult{ .err = e },
            .ok => |v| v,
        };
    
        // `list` resolves to one ENTITY per record. make_result cannot build them
        // here — it works in Value, which has no slot for an entity — so the op
        // does, mirroring what the dynamic targets get from make_result.
        var items: std.ArrayList(*MoonEntity) = .empty;
        if (out == .array) {
            for (out.array.data.items) |entry| {
                const ent = MoonEntity.new(self.client, h.clone(self.entopts));
                _ = ent.data_impl(entry);
                items.append(h.A(), ent) catch {};
            }
        }
    
        return EntListResult{ .ok = items.toOwnedSlice(h.A()) catch &[_]*MoonEntity{} };
    }
    
    fn list_post_done(self: *MoonEntity, ctx: *Context) void {
        if (ctx.result) |result| {
            const resmatch = result.resmatch;
            if (resmatch == .object) self.mtch = resmatch;
        }
    }
    


    pub fn create(self: *MoonEntity, reqdata: Value, ctrl: Value) EntResult {
        const ctx = self.utility.make_context(CtxSpec{
            .opname = "create",
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqdata = reqdata,
        }, self.ent_ctx());
        return self.run_op_ent(ctx, create_post_done);
    }
    
    fn create_post_done(self: *MoonEntity, ctx: *Context) void {
        if (ctx.result) |result| {
            const resdata = result.resdata;
            if (!h.is_noval(resdata)) {
                const cm = h.to_map(h.clone(resdata));
                self.data = if (cm == .object) cm else h.omap();
            }
        }
    }
    


    pub fn update(self: *MoonEntity, reqdata: Value, ctrl: Value) EntResult {
        const ctx = self.utility.make_context(CtxSpec{
            .opname = "update",
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqdata = reqdata,
        }, self.ent_ctx());
        return self.run_op_ent(ctx, update_post_done);
    }
    
    fn update_post_done(self: *MoonEntity, ctx: *Context) void {
        if (ctx.result) |result| {
            const resmatch = result.resmatch;
            const resdata = result.resdata;
            if (resmatch == .object) self.mtch = resmatch;
            if (!h.is_noval(resdata)) {
                const cm = h.to_map(h.clone(resdata));
                self.data = if (cm == .object) cm else h.omap();
            }
        }
    }
    

    pub fn patch(self: *MoonEntity, _reqdata: Value, _ctrl: Value) EntResult {
        _ = _reqdata;
        _ = _ctrl;
        return .{ .err = h.unsupported_op("patch", self.name) };
    }


    pub fn remove(self: *MoonEntity, reqmatch: Value, ctrl: Value) EntResult {
        const ctx = self.utility.make_context(CtxSpec{
            .opname = "remove",
            .ctrl = ctrl,
            .mtch = self.mtch,
            .data = self.data,
            .reqmatch = reqmatch,
        }, self.ent_ctx());
        const res = self.run_op_ent(ctx, remove_post_done);
        // A removed entity keeps its data but is no longer a live record.
        if (res == .ok) self.mark_deleted();
        return res;
    }
    
    fn remove_post_done(self: *MoonEntity, ctx: *Context) void {
        if (ctx.result) |result| {
            const resmatch = result.resmatch;
            const resdata = result.resdata;
            if (resmatch == .object) self.mtch = resmatch;
            if (!h.is_noval(resdata)) {
                const cm = h.to_map(h.clone(resdata));
                self.data = if (cm == .object) cm else h.omap();
            }
        }
    }
    
};
