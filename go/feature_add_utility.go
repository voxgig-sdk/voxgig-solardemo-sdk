package voxgigsolardemosdk

func featureAddUtil(ctx *Context, f Feature) {
	client := ctx.Client
	features := client.Features

	client.Features = append(features, f)
}
