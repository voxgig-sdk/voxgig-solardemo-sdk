package core

type VoxgigSolardemoError struct {
	IsVoxgigSolardemoError bool
	Sdk              string
	Code             string
	Msg              string
	Ctx              *Context
	Result           any
	Spec             any
}

func NewVoxgigSolardemoError(code string, msg string, ctx *Context) *VoxgigSolardemoError {
	return &VoxgigSolardemoError{
		IsVoxgigSolardemoError: true,
		Sdk:              "VoxgigSolardemo",
		Code:             code,
		Msg:              msg,
		Ctx:              ctx,
	}
}

func (e *VoxgigSolardemoError) Error() string {
	return e.Msg
}
