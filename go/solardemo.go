package solardemo

import (
	"voxgig-sdk/solardemo/sdk"
)

// SolardemoSDK is the main SDK client.
type SolardemoSDK struct {
	mode     string
	opts     map[string]any
	features []any
	rootctx  map[string]any
}

// New creates a new SolardemoSDK client.
func New(opts map[string]any) *SolardemoSDK {
	if opts == nil {
		opts = map[string]any{}
	}

	s := &SolardemoSDK{
		mode:     "live",
		features: []any{},
	}

	s.rootctx = sdk.MakeContext(map[string]any{
		"client":  s,
		"options": opts,
		"config":  config,
	})

	s.opts = sdk.MakeOptions(s.rootctx)

	testActive, _ := sdk.GetPath([]string{"feature", "test", "active"}, s.opts).(bool)
	if testActive {
		s.mode = "test"
	}

	s.rootctx["options"] = s.opts

	// Feature: test

	for _, f := range s.features {
		sdk.FeatureInit(s.rootctx, f)
	}

	sdk.FeatureHook(s.rootctx, "PostConstruct")

	return s
}

// Options returns a clone of the SDK options.
func (s *SolardemoSDK) Options() map[string]any {
	out, _ := sdk.Clone(s.opts).(map[string]any)
	if out == nil {
		return map[string]any{}
	}
	return out
}

// Mode returns the SDK mode (live or test).
func (s *SolardemoSDK) Mode() string {
	return s.mode
}

// Features returns the SDK features.
func (s *SolardemoSDK) Features() []any {
	return s.features
}

// SetFeatures sets the SDK features.
func (s *SolardemoSDK) SetFeatures(f []any) {
	s.features = f
}

// Prepare builds a fetch definition from SDK options and user-provided arguments.
func (s *SolardemoSDK) Prepare(fetchargs map[string]any) (map[string]any, error) {
	if fetchargs == nil {
		fetchargs = map[string]any{}
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname": "prepare",
		"ctrl":   sdk.GetProp(fetchargs, "ctrl", map[string]any{}),
	}, s.rootctx)

	spec := map[string]any{
		"base":    sdk.GetProp(s.opts, "base", ""),
		"prefix":  sdk.GetProp(s.opts, "prefix", ""),
		"suffix":  sdk.GetProp(s.opts, "suffix", ""),
		"path":    sdk.GetProp(fetchargs, "path", ""),
		"method":  sdk.GetProp(fetchargs, "method", "GET"),
		"params":  sdk.GetProp(fetchargs, "params", map[string]any{}),
		"query":   sdk.GetProp(fetchargs, "query", map[string]any{}),
		"headers": sdk.PrepareHeaders(ctx),
		"body":    sdk.GetProp(fetchargs, "body"),
		"step":    "start",
		"alias":   map[string]any{},
	}

	ctx["spec"] = spec

	if userHeaders := sdk.GetProp(fetchargs, "headers"); userHeaders != nil {
		if uh, ok := userHeaders.(map[string]any); ok {
			specHeaders, _ := spec["headers"].(map[string]any)
			for k, v := range uh {
				specHeaders[k] = v
			}
		}
	}

	_, err := sdk.PrepareAuth(ctx)
	if err != nil {
		return nil, err
	}

	return sdk.MakeFetchDef(ctx)
}

// Direct makes a direct HTTP request using the SDK configuration.
func (s *SolardemoSDK) Direct(fetchargs map[string]any) (map[string]any, error) {
	fetchdef, err := s.Prepare(fetchargs)
	if err != nil {
		return nil, err
	}

	ctx := sdk.MakeContext(map[string]any{
		"opname": "direct",
		"ctrl":   sdk.GetProp(fetchargs, "ctrl", map[string]any{}),
	}, s.rootctx)

	url, _ := fetchdef["url"].(string)
	fetched, fetchErr := sdk.Fetcher(ctx, url, fetchdef)

	if fetchErr != nil {
		return map[string]any{"ok": false, "err": fetchErr}, nil
	}

	if fetched == nil {
		return map[string]any{"ok": false, "err": "response: undefined"}, nil
	}

	fetchedMap, _ := fetched.(map[string]any)
	if fetchedMap == nil {
		return map[string]any{"ok": false, "err": "response: invalid type"}, nil
	}

	status, _ := sdk.GetProp(fetchedMap, "status").(float64)

	return map[string]any{
		"ok":      status >= 200 && status < 300,
		"status":  status,
		"headers": sdk.GetProp(fetchedMap, "headers"),
		"data":    sdk.GetProp(fetchedMap, "body"),
	}, nil
}


// Moon creates a new Moon entity.
func (s *SolardemoSDK) Moon(entopts ...map[string]any) *MoonEntity {
	var eo map[string]any
	if len(entopts) > 0 {
		eo = entopts[0]
	}
	return NewMoonEntity(s, eo)
}


// Planet creates a new Planet entity.
func (s *SolardemoSDK) Planet(entopts ...map[string]any) *PlanetEntity {
	var eo map[string]any
	if len(entopts) > 0 {
		eo = entopts[0]
	}
	return NewPlanetEntity(s, eo)
}



// Test creates a test SDK instance.
func Test(testoptsarg, sdkoptsarg map[string]any) *SolardemoSDK {
	sdkopts, _ := sdk.GetDef(sdk.Clone(sdkoptsarg), map[string]any{}).(map[string]any)
	testopts, _ := sdk.GetDef(sdk.Clone(testoptsarg), map[string]any{}).(map[string]any)
	sdk.SetProp(testopts, "active", true)
	sdk.SetPath(sdkopts, []string{"feature", "test"}, testopts)

	s := New(sdkopts)
	s.mode = "test"

	return s
}

// Tester creates a test SDK instance with options.
func (s *SolardemoSDK) Tester(testopts, sdkopts map[string]any) (*SolardemoSDK, error) {
	return Test(testopts, sdkopts), nil
}
