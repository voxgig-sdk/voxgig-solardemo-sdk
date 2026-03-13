package entity

import (
	"voxgigsolardemosdk/core"

	vs "github.com/voxgig/struct"
)

type MoonEntity struct {
	name    string
	client  *core.SolardemoSDK
	utility *core.Utility
	entopts map[string]any
	data    map[string]any
	match   map[string]any
	entctx  *core.Context
}

func NewMoonEntity(client *core.SolardemoSDK, entopts map[string]any) *MoonEntity {
	if entopts == nil {
		entopts = map[string]any{}
	}
	if _, ok := entopts["active"]; !ok {
		entopts["active"] = true
	} else if entopts["active"] == false {
		// keep false
	} else {
		entopts["active"] = true
	}

	m := &MoonEntity{
		name:    "moon",
		client:  client,
		utility: client.GetUtility(),
		entopts: entopts,
		data:    map[string]any{},
		match:   map[string]any{},
	}

	m.entctx = m.utility.MakeContext(map[string]any{
		"entity":  m,
		"entopts": entopts,
	}, client.GetRootCtx())

	m.utility.FeatureHook(m.entctx, "PostConstructEntity")

	return m
}

func (m *MoonEntity) GetName() string { return m.name }

func (m *MoonEntity) Make() core.Entity {
	opts := map[string]any{}
	for k, v := range m.entopts {
		opts[k] = v
	}
	return NewMoonEntity(m.client, opts)
}

func (m *MoonEntity) Data(args ...any) any {
	if len(args) > 0 && args[0] != nil {
		m.data = core.ToMapAny(vs.Clone(args[0]))
		if m.data == nil {
			m.data = map[string]any{}
		}
		m.utility.FeatureHook(m.entctx, "SetData")
	}

	m.utility.FeatureHook(m.entctx, "GetData")
	out := vs.Clone(m.data)
	return out
}

func (m *MoonEntity) Match(args ...any) any {
	if len(args) > 0 && args[0] != nil {
		m.match = core.ToMapAny(vs.Clone(args[0]))
		if m.match == nil {
			m.match = map[string]any{}
		}
		m.utility.FeatureHook(m.entctx, "SetMatch")
	}

	m.utility.FeatureHook(m.entctx, "GetMatch")
	out := vs.Clone(m.match)
	return out
}

func (m *MoonEntity) Load(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := m.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "load",
		"ctrl":     ctrl,
		"match":    m.match,
		"data":     m.data,
		"reqmatch": reqmatch,
	}, m.entctx)

	return m.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				m.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				m.data = core.ToMapAny(vs.Clone(ctx.Result.Resdata))
				if m.data == nil {
					m.data = map[string]any{}
				}
			}
		}
	})
}

func (m *MoonEntity) List(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := m.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "list",
		"ctrl":     ctrl,
		"match":    m.match,
		"data":     m.data,
		"reqmatch": reqmatch,
	}, m.entctx)

	return m.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				m.match = ctx.Result.Resmatch
			}
		}
	})
}

func (m *MoonEntity) Create(reqdata map[string]any, ctrl map[string]any) (any, error) {
	utility := m.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":  "create",
		"ctrl":    ctrl,
		"match":   m.match,
		"data":    m.data,
		"reqdata": reqdata,
	}, m.entctx)

	return m.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resdata != nil {
				m.data = core.ToMapAny(vs.Clone(ctx.Result.Resdata))
				if m.data == nil {
					m.data = map[string]any{}
				}
			}
		}
	})
}

func (m *MoonEntity) Update(reqdata map[string]any, ctrl map[string]any) (any, error) {
	utility := m.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":  "update",
		"ctrl":    ctrl,
		"match":   m.match,
		"data":    m.data,
		"reqdata": reqdata,
	}, m.entctx)

	return m.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				m.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				m.data = core.ToMapAny(vs.Clone(ctx.Result.Resdata))
				if m.data == nil {
					m.data = map[string]any{}
				}
			}
		}
	})
}

func (m *MoonEntity) Remove(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := m.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "remove",
		"ctrl":     ctrl,
		"match":    m.match,
		"data":     m.data,
		"reqmatch": reqmatch,
	}, m.entctx)

	return m.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				m.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				m.data = core.ToMapAny(vs.Clone(ctx.Result.Resdata))
				if m.data == nil {
					m.data = map[string]any{}
				}
			}
		}
	})
}

func (m *MoonEntity) runOp(ctx *core.Context, postDone func()) (any, error) {
	utility := m.utility

	utility.FeatureHook(ctx, "PreSelection")

	target, err := utility.MakeTarget(ctx)
	ctx.Out["target"] = target
	if err != nil {
		return utility.MakeError(ctx, err)
	}

	utility.FeatureHook(ctx, "PreSpec")

	spec, err := utility.MakeSpec(ctx)
	ctx.Out["spec"] = spec
	if err != nil {
		return utility.MakeError(ctx, err)
	}

	utility.FeatureHook(ctx, "PreRequest")

	resp, err := utility.MakeRequest(ctx)
	ctx.Out["request"] = resp
	if err != nil {
		return utility.MakeError(ctx, err)
	}

	utility.FeatureHook(ctx, "PreResponse")

	resp2, err := utility.MakeResponse(ctx)
	ctx.Out["response"] = resp2
	if err != nil {
		return utility.MakeError(ctx, err)
	}

	utility.FeatureHook(ctx, "PreResult")

	result, err := utility.MakeResult(ctx)
	ctx.Out["result"] = result
	if err != nil {
		return utility.MakeError(ctx, err)
	}

	utility.FeatureHook(ctx, "PreDone")

	postDone()

	return utility.Done(ctx)
}
