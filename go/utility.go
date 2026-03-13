package voxgigsolardemosdk

type Utility struct {
	Clean             func(ctx *Context, val any) any
	Done              func(ctx *Context) (any, error)
	MakeError         func(ctx *Context, err error) (any, error)
	FeatureAdd        func(ctx *Context, f Feature)
	FeatureHook       func(ctx *Context, name string)
	FeatureInit       func(ctx *Context, f Feature)
	Fetcher           FetcherFunc
	MakeFetchDef      func(ctx *Context) (map[string]any, error)
	MakeContext       func(ctxmap map[string]any, basectx *Context) *Context
	MakeOptions       func(ctx *Context) map[string]any
	MakeRequest       func(ctx *Context) (*Response, error)
	MakeResponse      func(ctx *Context) (*Response, error)
	MakeResult        func(ctx *Context) (*Result, error)
	MakeTarget        func(ctx *Context) (map[string]any, error)
	MakeSpec          func(ctx *Context) (*Spec, error)
	MakeUrl           func(ctx *Context) (string, error)
	Param             func(ctx *Context, paramdef any) any
	PrepareAuth       func(ctx *Context) (*Spec, error)
	PrepareBody       func(ctx *Context) any
	PrepareHeaders    func(ctx *Context) map[string]any
	PrepareMethod     func(ctx *Context) string
	PrepareParams     func(ctx *Context) map[string]any
	PreparePath       func(ctx *Context) string
	PrepareQuery      func(ctx *Context) map[string]any
	ResultBasic       func(ctx *Context) *Result
	ResultBody        func(ctx *Context) *Result
	ResultHeaders     func(ctx *Context) *Result
	TransformRequest  func(ctx *Context) any
	TransformResponse func(ctx *Context) any
	Custom            map[string]any
}

func NewUtility() *Utility {
	u := &Utility{
		Custom: map[string]any{},
	}
	u.Clean = cleanUtil
	u.Done = doneUtil
	u.MakeError = makeErrorUtil
	u.FeatureAdd = featureAddUtil
	u.FeatureHook = featureHookUtil
	u.FeatureInit = featureInitUtil
	u.Fetcher = fetcherUtil
	u.MakeFetchDef = makeFetchDefUtil
	u.MakeContext = makeContextUtil
	u.MakeOptions = makeOptionsUtil
	u.MakeRequest = makeRequestUtil
	u.MakeResponse = makeResponseUtil
	u.MakeResult = makeResultUtil
	u.MakeTarget = makeTargetUtil
	u.MakeSpec = makeSpecUtil
	u.MakeUrl = makeUrlUtil
	u.Param = paramUtil
	u.PrepareAuth = prepareAuthUtil
	u.PrepareBody = prepareBodyUtil
	u.PrepareHeaders = prepareHeadersUtil
	u.PrepareMethod = prepareMethodUtil
	u.PrepareParams = prepareParamsUtil
	u.PreparePath = preparePathUtil
	u.PrepareQuery = prepareQueryUtil
	u.ResultBasic = resultBasicUtil
	u.ResultBody = resultBodyUtil
	u.ResultHeaders = resultHeadersUtil
	u.TransformRequest = transformRequestUtil
	u.TransformResponse = transformResponseUtil
	return u
}

func CopyUtility(src *Utility) *Utility {
	u := &Utility{}
	*u = *src
	u.Custom = map[string]any{}
	for k, v := range src.Custom {
		u.Custom[k] = v
	}
	return u
}
