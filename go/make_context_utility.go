package voxgigsolardemosdk

func makeContextUtil(ctxmap map[string]any, basectx *Context) *Context {
	return NewContext(ctxmap, basectx)
}
