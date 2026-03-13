package voxgigsolardemosdk

type BaseFeature struct {
	Version string
	Name    string
	Active  bool
}

func NewBaseFeature() *BaseFeature {
	return &BaseFeature{
		Version: "0.0.1",
		Name:    "base",
		Active:  true,
	}
}

func (f *BaseFeature) GetVersion() string { return f.Version }
func (f *BaseFeature) GetName() string    { return f.Name }
func (f *BaseFeature) GetActive() bool    { return f.Active }

func (f *BaseFeature) Init(ctx *Context, options map[string]any)  {}
func (f *BaseFeature) PostConstruct(ctx *Context)                 {}
func (f *BaseFeature) PostConstructEntity(ctx *Context)           {}
func (f *BaseFeature) SetData(ctx *Context)                       {}
func (f *BaseFeature) GetData(ctx *Context)                       {}
func (f *BaseFeature) GetMatch(ctx *Context)                      {}
func (f *BaseFeature) SetMatch(ctx *Context)                      {}
func (f *BaseFeature) PreTarget(ctx *Context)                     {}
func (f *BaseFeature) PreSelection(ctx *Context)                  {}
func (f *BaseFeature) PreSpec(ctx *Context)                       {}
func (f *BaseFeature) PreRequest(ctx *Context)                    {}
func (f *BaseFeature) PreResponse(ctx *Context)                   {}
func (f *BaseFeature) PreResult(ctx *Context)                     {}
func (f *BaseFeature) PreDone(ctx *Context)                       {}
func (f *BaseFeature) PreUnexpected(ctx *Context)                 {}
func (f *BaseFeature) PostOperation(ctx *Context)                 {}
