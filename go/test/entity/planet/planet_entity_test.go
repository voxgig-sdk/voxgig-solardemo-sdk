package solardemo_test

import (
	"testing"
	"github.com/stretchr/testify/assert"

	sdk "voxgig-sdk/solardemo"
)

func TestPlanetEntity(t *testing.T) {
	testsdk := sdk.Test(nil, nil)
	assert.NotNil(t, testsdk)

	t.Run("instance", func(t *testing.T) {
		ent := testsdk.Planet(nil)
		assert.NotNil(t, ent)
	})

	t.Run("basic", func(t *testing.T) {

		// CREATE
		planet_ref01_ent := testsdk.Planet(nil)
		planet_ref01_data := setup.Data.New["planet"]["planet_ref01"]

		planet_ref01_dataResult, err := planet_ref01_ent.Create(planet_ref01_data)
		assert.NoError(t, err)
		assert.NotNil(t, planet_ref01_dataResult)

		// LIST
		planet_ref01_match := map[string]any{}

		planet_ref01_list, err := planet_ref01_ent.List(planet_ref01_match)
		assert.NoError(t, err)
		assert.NotNil(t, planet_ref01_list)

		// UPDATE
		planet_ref01_data_up0Update := map[string]any{}
		planet_ref01_data_up0Update["id"] = planet_ref01_data_up0Result.(map[string]any)["id"]

		planet_ref01_resdata_up0, err := planet_ref01_ent.Update(planet_ref01_data_up0Update)
		assert.NoError(t, err)
		assert.NotNil(t, planet_ref01_resdata_up0)

		// LOAD
		planet_ref01_match_dt0 := map[string]any{}
		planet_ref01_match_dt0["id"] = planet_ref01_data_dt0Result.(map[string]any)["id"]
		planet_ref01_data_dt0Loaded, err := planet_ref01_ent.Load(planet_ref01_match_dt0)
		assert.NoError(t, err)
		assert.NotNil(t, planet_ref01_data_dt0Loaded)

		// REMOVE
		planet_ref01_match_rm0Rm := map[string]any{}
		planet_ref01_match_rm0Rm["id"] = planet_ref01_data_rm0Result.(map[string]any)["id"]
		_, err = planet_ref01_ent.Remove(planet_ref01_match_rm0Rm)
		assert.NoError(t, err)

		// LIST
		planet_ref01_match_rt0 := map[string]any{}

		planet_ref01_list_rt0, err := planet_ref01_ent.List(planet_ref01_match_rt0)
		assert.NoError(t, err)
		assert.NotNil(t, planet_ref01_list_rt0)
	})
}
