package voxgigsolardemosdk

import (
	vs "github.com/voxgig/struct"
)

func preparePathUtil(ctx *Context) string {
	target := ctx.Target

	var parts []any
	if p := vs.GetProp(target, "parts"); p != nil {
		if pl, ok := p.([]any); ok {
			parts = pl
		}
	}

	path := vs.Join(parts, "/", true)
	return path
}
