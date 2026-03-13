package voxgigsolardemosdk

type Feature interface {
	GetVersion() string
	GetName() string
	GetActive() bool

	Init(ctx *Context, options map[string]any)

	PostConstruct(ctx *Context)
	PostConstructEntity(ctx *Context)
	SetData(ctx *Context)
	GetData(ctx *Context)
	GetMatch(ctx *Context)

	PreTarget(ctx *Context)
	PreSelection(ctx *Context)
	PreSpec(ctx *Context)
	PreRequest(ctx *Context)
	PreResponse(ctx *Context)
	PreResult(ctx *Context)
	PreDone(ctx *Context)
	PreUnexpected(ctx *Context)
	PostOperation(ctx *Context)
	SetMatch(ctx *Context)
}

type Entity interface {
	GetName() string
	Make() Entity
	Data(data ...any) any
	Match(match ...any) any
}

type FetcherFunc func(ctx *Context, fullurl string, fetchdef map[string]any) (any, error)
