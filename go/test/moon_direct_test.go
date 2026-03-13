package sdktest

import (
	"strings"
	"testing"

	sdk "voxgigsolardemosdk"
	"voxgigsolardemosdk/core"
)

func TestMoonDirect(t *testing.T) {
	t.Run("direct-load-moon", func(t *testing.T) {
		setup := moonDirectSetup(map[string]any{"id": "direct01"})
		client := setup.client
		calls := setup.calls

		result, err := client.Direct(map[string]any{
			"path":   "api/planet/{planet_id}/moon/{id}",
			"method": "GET",
			"params": map[string]any{"id": "direct01", "planet_id": "direct02"},
		})
		if err != nil {
			t.Fatalf("direct failed: %v", err)
		}

		if result["ok"] != true {
			t.Fatalf("expected ok to be true, got %v", result["ok"])
		}
		if core.ToInt(result["status"]) != 200 {
			t.Fatalf("expected status 200, got %v", result["status"])
		}
		if result["data"] == nil {
			t.Fatal("expected data to be non-nil")
		}
		if dataMap, ok := result["data"].(map[string]any); ok {
			if dataMap["id"] != "direct01" {
				t.Fatalf("expected data.id to be direct01, got %v", dataMap["id"])
			}
		}

		if len(*calls) != 1 {
			t.Fatalf("expected 1 call, got %d", len(*calls))
		}
		call := (*calls)[0]
		if initMap, ok := call["init"].(map[string]any); ok {
			if initMap["method"] != "GET" {
				t.Fatalf("expected method GET, got %v", initMap["method"])
			}
		}
		if url, ok := call["url"].(string); ok {
			if !strings.Contains(url, "direct01") {
				t.Fatalf("expected url to contain direct01, got %v", url)
			}
			if !strings.Contains(url, "direct02") {
				t.Fatalf("expected url to contain direct02, got %v", url)
			}
		}
	})

	t.Run("direct-list-moon", func(t *testing.T) {
		setup := moonDirectSetup([]any{
			map[string]any{"id": "direct01"},
			map[string]any{"id": "direct02"},
		})
		client := setup.client
		calls := setup.calls

		result, err := client.Direct(map[string]any{
			"path":   "api/planet/{planet_id}/moon",
			"method": "GET",
			"params": map[string]any{"planet_id": "direct01"},
		})
		if err != nil {
			t.Fatalf("direct failed: %v", err)
		}

		if result["ok"] != true {
			t.Fatalf("expected ok to be true, got %v", result["ok"])
		}
		if core.ToInt(result["status"]) != 200 {
			t.Fatalf("expected status 200, got %v", result["status"])
		}
		if dataList, ok := result["data"].([]any); ok {
			if len(dataList) != 2 {
				t.Fatalf("expected 2 items, got %d", len(dataList))
			}
		} else {
			t.Fatalf("expected data to be an array, got %T", result["data"])
		}

		if len(*calls) != 1 {
			t.Fatalf("expected 1 call, got %d", len(*calls))
		}
		call := (*calls)[0]
		if initMap, ok := call["init"].(map[string]any); ok {
			if initMap["method"] != "GET" {
				t.Fatalf("expected method GET, got %v", initMap["method"])
			}
		}
		if url, ok := call["url"].(string); ok {
			if !strings.Contains(url, "direct01") {
				t.Fatalf("expected url to contain direct01, got %v", url)
			}
		}
	})
}

type moonDirectSetupResult struct {
	client *sdk.SolardemoSDK
	calls  *[]map[string]any
}

func moonDirectSetup(mockres any) *moonDirectSetupResult {
	calls := &[]map[string]any{}

	mockFetch := func(url string, init map[string]any) (map[string]any, error) {
		*calls = append(*calls, map[string]any{"url": url, "init": init})
		return map[string]any{
			"status":     200,
			"statusText": "OK",
			"headers":    map[string]any{},
			"json": (func() any)(func() any {
				if mockres != nil {
					return mockres
				}
				return map[string]any{"id": "direct01"}
			}),
		}, nil
	}

	client := sdk.NewSolardemoSDK(map[string]any{
		"base": "http://localhost:8080",
		"system": map[string]any{
			"fetch": (func(string, map[string]any) (map[string]any, error))(mockFetch),
		},
	})

	return &moonDirectSetupResult{client: client, calls: calls}
}
