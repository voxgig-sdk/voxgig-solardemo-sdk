package core

type SolardemoError struct {
	IsSolardemoError bool
	Sdk              string
	Code             string
	Msg              string
	Ctx              *Context
	Result           any
	Spec             any
}

func NewSolardemoError(code string, msg string, ctx *Context) *SolardemoError {
	return &SolardemoError{
		IsSolardemoError: true,
		Sdk:              "Solardemo",
		Code:             code,
		Msg:              msg,
		Ctx:              ctx,
	}
}

func (e *SolardemoError) Error() string {
	return e.Msg
}
