package solardemo

import (
	"voxgig-sdk/solardemo/sdk"
)

// MoonEntity represents the Moon entity.
type MoonEntity struct {
	name    string
	client  *SolardemoSDK
	entopts map[string]any
	data    map[string]any
	match   map[string]any
	entctx  map[string]any
}

// NewMoonEntity creates a new Moon entity.
func NewMoonEntity(client *SolardemoSDK, entopts map[string]any) *MoonEntity {
	if entopts == nil {
		entopts = map[string]any{}
	}

	e := &MoonEntity{
		name:    "moon",
		client:  client,
		entopts: entopts,
		data:    map[string]any{},
		match:   map[string]any{},
	}

	e.entctx = sdk.MakeContext(map[string]any{
		"entity":  e,
		"entopts": entopts,
	}, client.rootctx)

	sdk.FeatureHook(e.entctx, "PostConstructEntity")

	return e
}

// EntOpts returns the entity options.
func (e *MoonEntity) EntOpts() map[string]any {
	out, _ := sdk.Clone(e.entopts).(map[string]any)
	return out
}

// Client returns the SDK client.
func (e *MoonEntity) Client() *SolardemoSDK {
	return e.client
}

// Make creates a new entity instance.
func (e *MoonEntity) Make() *MoonEntity {
	return NewMoonEntity(e.client, e.EntOpts())
}

// Data gets or sets entity data.
func (e *MoonEntity) Data(data ...map[string]any) map[string]any {
	if len(data) > 0 && data[0] != nil {
		e.data, _ = sdk.Clone(data[0]).(map[string]any)
		sdk.FeatureHook(e.entctx, "SetData")
	}

	sdk.FeatureHook(e.entctx, "GetData")
	out, _ := sdk.Clone(e.data).(map[string]any)
	return out
}

// Match gets or sets entity match criteria.
func (e *MoonEntity) Match(match ...map[string]any) map[string]any {
	if len(match) > 0 && match[0] != nil {
		e.match, _ = sdk.Clone(match[0]).(map[string]any)
		sdk.FeatureHook(e.entctx, "SetMatch")
	}

	sdk.FeatureHook(e.entctx, "GetMatch")
	out, _ := sdk.Clone(e.match).(map[string]any)
	return out
}

// Name returns the entity name.
func (e *MoonEntity) Name() string {
	return e.name
}


// Load retrieves an entity by match criteria.
func (e *MoonEntity) Load(reqmatch map[string]any, ctrl ...map[string]any) (any, error) {
	var ctrlMap map[string]any
	if len(ctrl) > 0 {
		ctrlMap = ctrl[0]
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname":   "load",
		"ctrl":     ctrlMap,
		"match":    e.match,
		"data":     e.data,
		"reqmatch": reqmatch,
	}, e.entctx)


	sdk.FeatureHook(ctx, "PreSelection")

	target, err := sdk.MakeTarget(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["target"] = target


	sdk.FeatureHook(ctx, "PreSpec")

	spec, err := sdk.MakeSpec(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["spec"] = spec


	sdk.FeatureHook(ctx, "PreRequest")

	request, err := sdk.MakeRequest(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["request"] = request


	sdk.FeatureHook(ctx, "PreResponse")

	response, err := sdk.MakeResponse(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["response"] = response


	sdk.FeatureHook(ctx, "PreResult")

	result, err := sdk.MakeResult(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["result"] = result


	sdk.FeatureHook(ctx, "PreDone")

	resultMap, _ := sdk.GetProp(ctx, "result").(map[string]any)
	if resultMap != nil {
		if resmatch := sdk.GetProp(resultMap, "resmatch"); resmatch != nil {
			if rm, ok := resmatch.(map[string]any); ok {
				e.match = rm
			}
		}
		if resdata := sdk.GetProp(resultMap, "resdata"); resdata != nil {
			if rd, ok := resdata.(map[string]any); ok {
				e.data = rd
			}
		}
	}

	return sdk.Done(ctx)
}




// List retrieves a list of entities by match criteria.
func (e *MoonEntity) List(reqmatch map[string]any, ctrl ...map[string]any) (any, error) {
	var ctrlMap map[string]any
	if len(ctrl) > 0 {
		ctrlMap = ctrl[0]
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname":   "list",
		"ctrl":     ctrlMap,
		"match":    e.match,
		"data":     e.data,
		"reqmatch": reqmatch,
	}, e.entctx)


	sdk.FeatureHook(ctx, "PreSelection")

	target, err := sdk.MakeTarget(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["target"] = target


	sdk.FeatureHook(ctx, "PreSpec")

	spec, err := sdk.MakeSpec(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["spec"] = spec


	sdk.FeatureHook(ctx, "PreRequest")

	request, err := sdk.MakeRequest(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["request"] = request


	sdk.FeatureHook(ctx, "PreResponse")

	response, err := sdk.MakeResponse(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["response"] = response


	sdk.FeatureHook(ctx, "PreResult")

	result, err := sdk.MakeResult(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["result"] = result


	sdk.FeatureHook(ctx, "PreDone")

	resultMap, _ := sdk.GetProp(ctx, "result").(map[string]any)
	if resultMap != nil {
		if resmatch := sdk.GetProp(resultMap, "resmatch"); resmatch != nil {
			if rm, ok := resmatch.(map[string]any); ok {
				e.match = rm
			}
		}
	}

	return sdk.Done(ctx)
}




// Create creates a new entity.
func (e *MoonEntity) Create(reqdata map[string]any, ctrl ...map[string]any) (any, error) {
	var ctrlMap map[string]any
	if len(ctrl) > 0 {
		ctrlMap = ctrl[0]
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname":  "create",
		"ctrl":    ctrlMap,
		"match":   e.match,
		"data":    e.data,
		"reqdata": reqdata,
	}, e.entctx)


	sdk.FeatureHook(ctx, "PreSelection")

	target, err := sdk.MakeTarget(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["target"] = target


	sdk.FeatureHook(ctx, "PreSpec")

	spec, err := sdk.MakeSpec(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["spec"] = spec


	sdk.FeatureHook(ctx, "PreRequest")

	request, err := sdk.MakeRequest(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["request"] = request


	sdk.FeatureHook(ctx, "PreResponse")

	response, err := sdk.MakeResponse(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["response"] = response


	sdk.FeatureHook(ctx, "PreResult")

	result, err := sdk.MakeResult(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["result"] = result


	sdk.FeatureHook(ctx, "PreDone")

	resultMap, _ := sdk.GetProp(ctx, "result").(map[string]any)
	if resultMap != nil {
		if resdata := sdk.GetProp(resultMap, "resdata"); resdata != nil {
			if rd, ok := resdata.(map[string]any); ok {
				e.data = rd
			}
		}
	}

	return sdk.Done(ctx)
}




// Update updates an existing entity.
func (e *MoonEntity) Update(reqdata map[string]any, ctrl ...map[string]any) (any, error) {
	var ctrlMap map[string]any
	if len(ctrl) > 0 {
		ctrlMap = ctrl[0]
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname":  "update",
		"ctrl":    ctrlMap,
		"match":   e.match,
		"data":    e.data,
		"reqdata": reqdata,
	}, e.entctx)


	sdk.FeatureHook(ctx, "PreSelection")

	target, err := sdk.MakeTarget(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["target"] = target


	sdk.FeatureHook(ctx, "PreSpec")

	spec, err := sdk.MakeSpec(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["spec"] = spec


	sdk.FeatureHook(ctx, "PreRequest")

	request, err := sdk.MakeRequest(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["request"] = request


	sdk.FeatureHook(ctx, "PreResponse")

	response, err := sdk.MakeResponse(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["response"] = response


	sdk.FeatureHook(ctx, "PreResult")

	result, err := sdk.MakeResult(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["result"] = result


	sdk.FeatureHook(ctx, "PreDone")

	resultMap, _ := sdk.GetProp(ctx, "result").(map[string]any)
	if resultMap != nil {
		if resmatch := sdk.GetProp(resultMap, "resmatch"); resmatch != nil {
			if rm, ok := resmatch.(map[string]any); ok {
				e.match = rm
			}
		}
		if resdata := sdk.GetProp(resultMap, "resdata"); resdata != nil {
			if rd, ok := resdata.(map[string]any); ok {
				e.data = rd
			}
		}
	}

	return sdk.Done(ctx)
}




// Remove deletes an entity by match criteria.
func (e *MoonEntity) Remove(reqmatch map[string]any, ctrl ...map[string]any) (any, error) {
	var ctrlMap map[string]any
	if len(ctrl) > 0 {
		ctrlMap = ctrl[0]
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname":   "remove",
		"ctrl":     ctrlMap,
		"match":    e.match,
		"data":     e.data,
		"reqmatch": reqmatch,
	}, e.entctx)


	sdk.FeatureHook(ctx, "PreTarget")

	target, err := sdk.MakeTarget(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["target"] = target


	sdk.FeatureHook(ctx, "PreSpec")

	spec, err := sdk.MakeSpec(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["spec"] = spec


	sdk.FeatureHook(ctx, "PreRequest")

	request, err := sdk.MakeRequest(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["request"] = request


	sdk.FeatureHook(ctx, "PreResponse")

	response, err := sdk.MakeResponse(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["response"] = response


	sdk.FeatureHook(ctx, "PreResult")

	result, err := sdk.MakeResult(ctx)
	if err != nil {
		return sdk.MakeError(ctx, err)
	}
	ctx["out"].(map[string]any)["result"] = result


	sdk.FeatureHook(ctx, "PreDone")

	resultMap, _ := sdk.GetProp(ctx, "result").(map[string]any)
	if resultMap != nil {
		if resmatch := sdk.GetProp(resultMap, "resmatch"); resmatch != nil {
			if rm, ok := resmatch.(map[string]any); ok {
				e.match = rm
			}
		}
		if resdata := sdk.GetProp(resultMap, "resdata"); resdata != nil {
			if rd, ok := resdata.(map[string]any); ok {
				e.data = rd
			}
		}
	}

	return sdk.Done(ctx)
}


