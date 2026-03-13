package core

var UtilityRegistrar func(u *Utility)

var NewBaseFeatureFunc func() Feature

var NewTestFeatureFunc func() Feature

var NewMoonEntityFunc func(client *SolardemoSDK, entopts map[string]any) SolardemoEntity

var NewPlanetEntityFunc func(client *SolardemoSDK, entopts map[string]any) SolardemoEntity
