package voxgigsolardemosdk

import (
	vs "github.com/voxgig/struct"
)

func transformResponseUtil(ctx *Context) any {
	spec := ctx.Spec
	result := ctx.Result
	target := ctx.Target

	if spec != nil {
		spec.Step = "resform"
	}

	if result == nil || !result.Ok {
		return nil
	}

	transform := toMapAny(vs.GetProp(target, "transform"))
	if transform == nil {
		return nil
	}

	resform := vs.GetProp(transform, "res")
	if resform == nil {
		return nil
	}

	resdata := vs.Transform(map[string]any{
		"ok":         result.Ok,
		"status":     result.Status,
		"statusText": result.StatusText,
		"headers":    result.Headers,
		"body":       result.Body,
		"err":        result.Err,
		"resdata":    result.Resdata,
		"resmatch":   result.Resmatch,
	}, resform)

	result.Resdata = resdata
	return resdata
}
