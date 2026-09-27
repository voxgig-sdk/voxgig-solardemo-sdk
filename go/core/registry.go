package core

var UtilityRegistrar func(u *Utility)

var NewBaseFeatureFunc func() Feature

var NewDebugFeatureFunc func() Feature

var NewIdempotencyFeatureFunc func() Feature

var NewMetricsFeatureFunc func() Feature

var NewPagingFeatureFunc func() Feature

var NewRatelimitFeatureFunc func() Feature

var NewRetryFeatureFunc func() Feature

var NewSecretsFeatureFunc func() Feature

var NewTestFeatureFunc func() Feature

var NewTimeoutFeatureFunc func() Feature

var NewMoonEntityFunc func(client *VoxgigSolardemoSDK, entopts map[string]any) VoxgigSolardemoEntity

var NewPlanetEntityFunc func(client *VoxgigSolardemoSDK, entopts map[string]any) VoxgigSolardemoEntity

