package voxgigsolardemosdk

func prepareBodyUtil(ctx *Context) any {
	op := ctx.Op

	if op.Input == "data" {
		body := ctx.Utility.TransformRequest(ctx)
		return body
	}

	return nil
}
