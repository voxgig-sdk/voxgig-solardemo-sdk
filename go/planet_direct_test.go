package voxgigsolardemosdk

import (
	"strings"
	"testing"
)

func TestPlanetDirect(t *testing.T) {
	t.Run("direct-load-planet", func(t *testing.T) {
		setup := planetDirectSetup(map[string]any{"id": "direct01"})
		client := setup.client
		calls := setup.calls

		result, err := client.Direct(map[string]any{
			"path":   "api/planet/{id}",
			"method": "GET",
			"params": map[string]any{"id": "direct01"},
		})
		if err != nil {
			t.Fatalf("direct failed: %v", err)
		}

		if result["ok"] != true {
			t.Fatalf("expected ok to be true, got %v", result["ok"])
		}
		if toInt(result["status"]) != 200 {
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
		}
	})

	t.Run("direct-list-planet", func(t *testing.T) {
		setup := planetDirectSetup([]any{
			map[string]any{"id": "direct01"},
			map[string]any{"id": "direct02"},
		})
		client := setup.client
		calls := setup.calls

		result, err := client.Direct(map[string]any{
			"path":   "api/planet",
			"method": "GET",
			"params": map[string]any{},
		})
		if err != nil {
			t.Fatalf("direct failed: %v", err)
		}

		if result["ok"] != true {
			t.Fatalf("expected ok to be true, got %v", result["ok"])
		}
		if toInt(result["status"]) != 200 {
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
	})
}

type planetDirectSetupResult struct {
	client *SolardemoSDK
	calls  *[]map[string]any
}

func planetDirectSetup(mockres any) *planetDirectSetupResult {
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

	client := NewSolardemoSDK(map[string]any{
		"base": "http://localhost:8080",
		"system": map[string]any{
			"fetch": (func(string, map[string]any) (map[string]any, error))(mockFetch),
		},
	})

	return &planetDirectSetupResult{client: client, calls: calls}
}
