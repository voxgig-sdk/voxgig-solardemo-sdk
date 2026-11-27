package utility

import (
	"github.com/voxgig-sdk/voxgig-solardemo-sdk/go/core"
)

// This SDK is configured with authentication off, so there is no credential
// to place. The function stays in the pipeline because makeSpec calls it
// unconditionally.
func prepareAuthUtil(ctx *core.Context) (*core.Spec, error) {
	spec := ctx.Spec
	if spec == nil {
		return nil, ctx.MakeError("auth_no_spec",
			"Expected context spec property to be defined.")
	}

	return spec, nil
}
