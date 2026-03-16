package voxgigsolardemosdk

import (
	"voxgigsolardemosdk/core"
	"voxgigsolardemosdk/entity"
	"voxgigsolardemosdk/feature"
	_ "voxgigsolardemosdk/utility"
)

// Type aliases preserve external API.
type SolardemoSDK = core.SolardemoSDK
type Context = core.Context
type Utility = core.Utility
type Feature = core.Feature
type Entity = core.Entity
type SolardemoEntity = core.SolardemoEntity
type FetcherFunc = core.FetcherFunc
type Spec = core.Spec
type Result = core.Result
type Response = core.Response
type Operation = core.Operation
type Control = core.Control
type SolardemoError = core.SolardemoError

// BaseFeature from feature package.
type BaseFeature = feature.BaseFeature

func init() {
	core.NewBaseFeatureFunc = func() core.Feature {
		return feature.NewBaseFeature()
	}
	core.NewTestFeatureFunc = func() core.Feature {
		return feature.NewTestFeature()
	}
	core.NewMoonEntityFunc = func(client *core.SolardemoSDK, entopts map[string]any) core.SolardemoEntity {
		return entity.NewMoonEntity(client, entopts)
	}
	core.NewPlanetEntityFunc = func(client *core.SolardemoSDK, entopts map[string]any) core.SolardemoEntity {
		return entity.NewPlanetEntity(client, entopts)
	}
}

// Constructor re-exports.
var NewSolardemoSDK = core.NewSolardemoSDK
var TestSDK = core.TestSDK
var NewContext = core.NewContext
var NewSpec = core.NewSpec
var NewResult = core.NewResult
var NewResponse = core.NewResponse
var NewOperation = core.NewOperation
var MakeConfig = core.MakeConfig
var NewBaseFeature = feature.NewBaseFeature
var NewTestFeature = feature.NewTestFeature
