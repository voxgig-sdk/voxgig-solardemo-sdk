package solardemo_test

import (
	"testing"
	"github.com/stretchr/testify/assert"

	sdk "voxgig-sdk/solardemo"
)

func directSetup() (*sdk.SolardemoSDK, *[]map[string]any) {
	calls := &[]map[string]any{}

	mockFetch := func(url string, fetchdef map[string]any) (any, error) {
		*calls = append(*calls, map[string]any{"url": url, "fetchdef": fetchdef})
		return map[string]any{
			"status": float64(200),
			"headers": map[string]any{},
			"body": map[string]any{"id": "direct01"},
		}, nil
	}

	client := sdk.New(map[string]any{
		"base": "http://localhost:8080",
		"system": map[string]any{"fetch": mockFetch},
	})

	return client, calls
}

func TestDirectPlanetLoad(t *testing.T) {
	client, calls := directSetup()

	result, err := client.Direct(map[string]any{
		"path":   "api/planet/{id}",
		"method": "GET",
		"params": map[string]any{"id": "direct01"},
	})

	assert.NoError(t, err)
	assert.NotNil(t, result)

	ok, _ := result["ok"].(bool)
	assert.True(t, ok)

	status, _ := result["status"].(float64)
	assert.Equal(t, float64(200), status)

	data, _ := result["data"].(map[string]any)
	assert.NotNil(t, data)
	assert.Equal(t, "direct01", data["id"])

	assert.Equal(t, 1, len(*calls))
}

func TestDirectPlanetList(t *testing.T) {
	client, calls := directSetup()

	result, err := client.Direct(map[string]any{
		"path":   "api/planet",
		"method": "GET",
		"params": map[string]any{},
	})

	assert.NoError(t, err)
	assert.NotNil(t, result)

	ok, _ := result["ok"].(bool)
	assert.True(t, ok)

	assert.Equal(t, 1, len(*calls))
}

