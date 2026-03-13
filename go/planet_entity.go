package voxgigsolardemosdk

import (
	vs "github.com/voxgig/struct"
)

type PlanetEntity struct {
	name    string
	client  *SolardemoSDK
	utility *Utility
	entopts map[string]any
	data    map[string]any
	match   map[string]any
	entctx  *Context
}

func NewPlanetEntity(client *SolardemoSDK, entopts map[string]any) *PlanetEntity {
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

	p := &PlanetEntity{
		name:    "planet",
		client:  client,
		utility: CopyUtility(client.utility),
		entopts: entopts,
		data:    map[string]any{},
		match:   map[string]any{},
	}

	p.entctx = p.utility.MakeContext(map[string]any{
		"entity":  p,
		"entopts": entopts,
	}, client.rootctx)

	p.utility.FeatureHook(p.entctx, "PostConstructEntity")

	return p
}

func (p *PlanetEntity) GetName() string { return p.name }

func (p *PlanetEntity) Make() Entity {
	opts := map[string]any{}
	for k, v := range p.entopts {
		opts[k] = v
	}
	return NewPlanetEntity(p.client, opts)
}

func (p *PlanetEntity) Data(args ...any) any {
	if len(args) > 0 && args[0] != nil {
		p.data = toMapAny(vs.Clone(args[0]))
		if p.data == nil {
			p.data = map[string]any{}
		}
		p.utility.FeatureHook(p.entctx, "SetData")
	}

	p.utility.FeatureHook(p.entctx, "GetData")
	out := vs.Clone(p.data)
	return out
}

func (p *PlanetEntity) Match(args ...any) any {
	if len(args) > 0 && args[0] != nil {
		p.match = toMapAny(vs.Clone(args[0]))
		if p.match == nil {
			p.match = map[string]any{}
		}
		p.utility.FeatureHook(p.entctx, "SetMatch")
	}

	p.utility.FeatureHook(p.entctx, "GetMatch")
	out := vs.Clone(p.match)
	return out
}

func (p *PlanetEntity) Load(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := p.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "load",
		"ctrl":     ctrl,
		"match":    p.match,
		"data":     p.data,
		"reqmatch": reqmatch,
	}, p.entctx)

	return p.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				p.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				p.data = toMapAny(vs.Clone(ctx.Result.Resdata))
				if p.data == nil {
					p.data = map[string]any{}
				}
			}
		}
	})
}

func (p *PlanetEntity) List(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := p.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "list",
		"ctrl":     ctrl,
		"match":    p.match,
		"data":     p.data,
		"reqmatch": reqmatch,
	}, p.entctx)

	return p.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				p.match = ctx.Result.Resmatch
			}
		}
	})
}

func (p *PlanetEntity) Create(reqdata map[string]any, ctrl map[string]any) (any, error) {
	utility := p.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":  "create",
		"ctrl":    ctrl,
		"match":   p.match,
		"data":    p.data,
		"reqdata": reqdata,
	}, p.entctx)

	return p.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resdata != nil {
				p.data = toMapAny(vs.Clone(ctx.Result.Resdata))
				if p.data == nil {
					p.data = map[string]any{}
				}
			}
		}
	})
}

func (p *PlanetEntity) Update(reqdata map[string]any, ctrl map[string]any) (any, error) {
	utility := p.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":  "update",
		"ctrl":    ctrl,
		"match":   p.match,
		"data":    p.data,
		"reqdata": reqdata,
	}, p.entctx)

	return p.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				p.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				p.data = toMapAny(vs.Clone(ctx.Result.Resdata))
				if p.data == nil {
					p.data = map[string]any{}
				}
			}
		}
	})
}

func (p *PlanetEntity) Remove(reqmatch map[string]any, ctrl map[string]any) (any, error) {
	utility := p.utility
	ctx := utility.MakeContext(map[string]any{
		"opname":   "remove",
		"ctrl":     ctrl,
		"match":    p.match,
		"data":     p.data,
		"reqmatch": reqmatch,
	}, p.entctx)

	return p.runOp(ctx, func() {
		if ctx.Result != nil {
			if ctx.Result.Resmatch != nil {
				p.match = ctx.Result.Resmatch
			}
			if ctx.Result.Resdata != nil {
				p.data = toMapAny(vs.Clone(ctx.Result.Resdata))
				if p.data == nil {
					p.data = map[string]any{}
				}
			}
		}
	})
}

func (p *PlanetEntity) runOp(ctx *Context, postDone func()) (any, error) {
	utility := p.utility

	utility.FeatureHook(ctx, "PreSelection")

	target, err := utility.MakeTarget(ctx)
	ctx.Out["target"] = target
	if err != nil {
		return makeErrorUtil(ctx, err)
	}

	utility.FeatureHook(ctx, "PreSpec")

	spec, err := utility.MakeSpec(ctx)
	ctx.Out["spec"] = spec
	if err != nil {
		return makeErrorUtil(ctx, err)
	}

	utility.FeatureHook(ctx, "PreRequest")

	resp, err := utility.MakeRequest(ctx)
	ctx.Out["request"] = resp
	if err != nil {
		return makeErrorUtil(ctx, err)
	}

	utility.FeatureHook(ctx, "PreResponse")

	resp2, err := utility.MakeResponse(ctx)
	ctx.Out["response"] = resp2
	if err != nil {
		return makeErrorUtil(ctx, err)
	}

	utility.FeatureHook(ctx, "PreResult")

	result, err := utility.MakeResult(ctx)
	ctx.Out["result"] = result
	if err != nil {
		return makeErrorUtil(ctx, err)
	}

	utility.FeatureHook(ctx, "PreDone")

	postDone()

	return utility.Done(ctx)
}
