package solardemo_test

import (
	"testing"
	"github.com/stretchr/testify/assert"

	sdk "voxgig-sdk/solardemo"
)

func TestMoonEntity(t *testing.T) {
	testsdk := sdk.Test(nil, nil)
	assert.NotNil(t, testsdk)

	t.Run("instance", func(t *testing.T) {
		ent := testsdk.Moon(nil)
		assert.NotNil(t, ent)
	})

	t.Run("basic", func(t *testing.T) {

		// CREATE
		moon_ref01_ent := testsdk.Moon(nil)
		moon_ref01_data := setup.Data.New["moon"]["moon_ref01"]
		moon_ref01_data["planet_id"] = setup.IDMap["planet01"]

		moon_ref01_dataResult, err := moon_ref01_ent.Create(moon_ref01_data)
		assert.NoError(t, err)
		assert.NotNil(t, moon_ref01_dataResult)

		// LIST
		moon_ref01_match := map[string]any{}
		moon_ref01_match["planet_id"] = setup.IDMap["planet01"]

		moon_ref01_list, err := moon_ref01_ent.List(moon_ref01_match)
		assert.NoError(t, err)
		assert.NotNil(t, moon_ref01_list)

		// UPDATE
		moon_ref01_data_up0Update := map[string]any{}
		moon_ref01_data_up0Update["id"] = moon_ref01_data_up0Result.(map[string]any)["id"]
		moon_ref01_data_up0Update["planet_id"] = setup.IDMap["planet_id"]

		moon_ref01_resdata_up0, err := moon_ref01_ent.Update(moon_ref01_data_up0Update)
		assert.NoError(t, err)
		assert.NotNil(t, moon_ref01_resdata_up0)

		// LOAD
		moon_ref01_match_dt0 := map[string]any{}
		moon_ref01_match_dt0["id"] = moon_ref01_data_dt0Result.(map[string]any)["id"]
		moon_ref01_data_dt0Loaded, err := moon_ref01_ent.Load(moon_ref01_match_dt0)
		assert.NoError(t, err)
		assert.NotNil(t, moon_ref01_data_dt0Loaded)

		// REMOVE
		moon_ref01_match_rm0Rm := map[string]any{}
		moon_ref01_match_rm0Rm["id"] = moon_ref01_data_rm0Result.(map[string]any)["id"]
		_, err = moon_ref01_ent.Remove(moon_ref01_match_rm0Rm)
		assert.NoError(t, err)

		// LIST
		moon_ref01_match_rt0 := map[string]any{}
		moon_ref01_match_rt0["planet_id"] = setup.IDMap["planet01"]

		moon_ref01_list_rt0, err := moon_ref01_ent.List(moon_ref01_match_rt0)
		assert.NoError(t, err)
		assert.NotNil(t, moon_ref01_list_rt0)
	})
}
