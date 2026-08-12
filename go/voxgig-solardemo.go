package voxgigvoxgigsolardemosdk

import (
	"github.com/voxgig-sdk/voxgig-solardemo-sdk/go/core"
	"github.com/voxgig-sdk/voxgig-solardemo-sdk/go/entity"
	"github.com/voxgig-sdk/voxgig-solardemo-sdk/go/feature"
	_ "github.com/voxgig-sdk/voxgig-solardemo-sdk/go/utility"
)

// Type aliases preserve external API.
type VoxgigSolardemoSDK = core.VoxgigSolardemoSDK
type Context = core.Context
type Utility = core.Utility
type Feature = core.Feature
type Entity = core.Entity
type VoxgigSolardemoEntity = core.VoxgigSolardemoEntity
type FetcherFunc = core.FetcherFunc
type Spec = core.Spec
type Result = core.Result
type Response = core.Response
type Operation = core.Operation
type Control = core.Control
type VoxgigSolardemoError = core.VoxgigSolardemoError

// BaseFeature from feature package.
type BaseFeature = feature.BaseFeature

func init() {
	core.NewBaseFeatureFunc = func() core.Feature {
		return feature.NewBaseFeature()
	}
	core.NewTestFeatureFunc = func() core.Feature {
		return feature.NewTestFeature()
	}
	core.NewMoonEntityFunc = func(client *core.VoxgigSolardemoSDK, entopts map[string]any) core.VoxgigSolardemoEntity {
		return entity.NewMoonEntity(client, entopts)
	}
	core.NewPlanetEntityFunc = func(client *core.VoxgigSolardemoSDK, entopts map[string]any) core.VoxgigSolardemoEntity {
		return entity.NewPlanetEntity(client, entopts)
	}
}

// Constructor re-exports.
var NewVoxgigSolardemoSDK = core.NewVoxgigSolardemoSDK
var TestSDK = core.TestSDK
var NewContext = core.NewContext
var NewSpec = core.NewSpec
var NewResult = core.NewResult
var NewResponse = core.NewResponse
var NewOperation = core.NewOperation
var MakeConfig = core.MakeConfig

// No-arg convenience constructors. Go has no default-argument syntax,
// so these aliases let callers write `sdk.New()` / `sdk.Test()`
// instead of `sdk.NewVoxgigSolardemoSDK(nil)` / `sdk.TestSDK(nil, nil)`
// for the common no-options case.
func New() *VoxgigSolardemoSDK  { return NewVoxgigSolardemoSDK(nil) }
func Test() *VoxgigSolardemoSDK { return TestSDK(nil, nil) }
var NewBaseFeature = feature.NewBaseFeature
var NewTestFeature = feature.NewTestFeature
