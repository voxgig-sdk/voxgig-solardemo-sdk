package core

var UtilityRegistrar func(u *Utility)

var NewBaseFeatureFunc func() Feature

var NewTestFeatureFunc func() Feature

var NewMoonEntityFunc func(client *VoxgigSolardemoSDK, entopts map[string]any) VoxgigSolardemoEntity

var NewPlanetEntityFunc func(client *VoxgigSolardemoSDK, entopts map[string]any) VoxgigSolardemoEntity

