package voxgigsolardemosdk

func makeErrorUtil(ctx *Context, err error) (any, error) {
	if ctx == nil {
		ctx = &Context{
			Ctrl: &Control{},
			Op:   NewOperation(map[string]any{}),
		}
	}

	op := ctx.Op
	if op == nil {
		op = NewOperation(map[string]any{})
	}
	opname := op.Name
	if opname == "" || opname == "_" {
		opname = "unknown operation"
	}

	result := ctx.Result
	if result == nil {
		result = NewResult(map[string]any{})
	}
	result.Ok = false

	if err == nil {
		err = result.Err
	}
	if err == nil {
		err = ctx.MakeError("unknown", "unknown error")
	}

	errmsg := err.Error()
	msg := "SolardemoSDK: " + opname + ": " + errmsg
	msg = cleanUtil(ctx, msg).(string)

	result.Err = nil

	spec := ctx.Spec

	if ctx.Ctrl.Explain != nil {
		ctx.Ctrl.Explain["err"] = map[string]any{
			"message": msg,
		}
	}

	sdkErr := &SolardemoError{
		IsSolardemoError: true,
		Sdk:              "Solardemo",
		Code:             "",
		Msg:              msg,
		Ctx:              ctx,
		Result:           cleanUtil(ctx, result),
		Spec:             cleanUtil(ctx, spec),
	}
	if se, ok := err.(*SolardemoError); ok {
		sdkErr.Code = se.Code
	}

	ctx.Ctrl.Err = sdkErr

	if ctx.Ctrl.Throw != nil && *ctx.Ctrl.Throw == false {
		return result.Resdata, nil
	}

	return nil, sdkErr
}
