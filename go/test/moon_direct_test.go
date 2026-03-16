package sdktest

import (
	"encoding/json"
	"os"
	"strings"
	"testing"

	sdk "voxgigsolardemosdk"
	"voxgigsolardemosdk/core"
)

func TestMoonDirect(t *testing.T) {
	t.Run("direct-list-moon", func(t *testing.T) {
		setup := moonDirectSetup([]any{
			map[string]any{"id": "direct01"},
			map[string]any{"id": "direct02"},
		})
		client := setup.client

		params := map[string]any{}
		if setup.live {
			params["planet_id"] = setup.idmap["planet01"]
		} else {
			params["planet_id"] = "direct01"
		}

		result, err := client.Direct(map[string]any{
			"path":   "api/planet/{planet_id}/moon",
			"method": "GET",
			"params": params,
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

		if !setup.live {
			if dataList, ok := result["data"].([]any); ok {
				if len(dataList) != 2 {
					t.Fatalf("expected 2 items, got %d", len(dataList))
				}
			} else {
				t.Fatalf("expected data to be an array, got %T", result["data"])
			}

			if len(*setup.calls) != 1 {
				t.Fatalf("expected 1 call, got %d", len(*setup.calls))
			}
			call := (*setup.calls)[0]
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
		}
	})

	t.Run("direct-load-moon", func(t *testing.T) {
		setup := moonDirectSetup(map[string]any{"id": "direct01"})
		client := setup.client

		params := map[string]any{}
		if setup.live {
			listParams := map[string]any{}
			listParams["planet_id"] = setup.idmap["planet01"]
			listResult, listErr := client.Direct(map[string]any{
				"path":   "api/planet/{planet_id}/moon",
				"method": "GET",
				"params": listParams,
			})
			if listErr != nil {
				t.Fatalf("list for load setup failed: %v", listErr)
			}
			if listResult["ok"] != true {
				t.Fatalf("list for load setup not ok: %v", listResult)
			}

			// Get first entity ID from list
			listData, _ := listResult["data"].([]any)
			if len(listData) == 0 {
				t.Skip("no entities to load in live mode")
			}
			firstEnt := core.ToMapAny(listData[0])
			params["id"] = firstEnt["id"]
			params["planet_id"] = setup.idmap["planet01"]
		} else {
			params["id"] = "direct01"
			params["planet_id"] = "direct02"
		}

		result, err := client.Direct(map[string]any{
			"path":   "api/planet/{planet_id}/moon/{id}",
			"method": "GET",
			"params": params,
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

		if !setup.live {
			if dataMap, ok := result["data"].(map[string]any); ok {
				if dataMap["id"] != "direct01" {
					t.Fatalf("expected data.id to be direct01, got %v", dataMap["id"])
				}
			}

			if len(*setup.calls) != 1 {
				t.Fatalf("expected 1 call, got %d", len(*setup.calls))
			}
			call := (*setup.calls)[0]
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
		}
	})

}

type moonDirectSetupResult struct {
	client *sdk.SolardemoSDK
	calls  *[]map[string]any
	live   bool
	idmap  map[string]any
}

func moonDirectSetup(mockres any) *moonDirectSetupResult {
	loadEnvLocal()

	calls := &[]map[string]any{}

	env := envOverride(map[string]any{
		"SOLARDEMO_TEST_MOON_ENTID": map[string]any{},
		"SOLARDEMO_TEST_LIVE":    "FALSE",
		"SOLARDEMO_APIKEY":       "NONE",
	})

	live := env["SOLARDEMO_TEST_LIVE"] == "TRUE"

	if live {
		mergedOpts := map[string]any{
			"apikey": env["SOLARDEMO_APIKEY"],
		}
		client := sdk.NewSolardemoSDK(mergedOpts)

		idmap := map[string]any{}
		if entidRaw, ok := env["SOLARDEMO_TEST_MOON_ENTID"]; ok {
			if entidStr, ok := entidRaw.(string); ok && strings.HasPrefix(entidStr, "{") {
				json.Unmarshal([]byte(entidStr), &idmap)
			} else if entidMap, ok := entidRaw.(map[string]any); ok {
				idmap = entidMap
			}
		}

		return &moonDirectSetupResult{client: client, calls: calls, live: true, idmap: idmap}
	}

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

	return &moonDirectSetupResult{client: client, calls: calls, live: false, idmap: map[string]any{}}
}

var _ = os.Getenv
var _ = json.Unmarshal
