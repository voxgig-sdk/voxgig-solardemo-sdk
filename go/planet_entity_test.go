package voxgigsolardemosdk

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	vs "github.com/voxgig/struct"
)

func TestPlanetEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := TestSDK(nil, nil)
		ent := testsdk.Planet(nil)
		if ent == nil {
			t.Fatal("expected non-nil PlanetEntity")
		}
	})

	t.Run("basic", func(t *testing.T) {
		setup := planetBasicSetup(nil)
		client := setup.client

		// CREATE
		planetEnt := client.Planet(nil)
		planetRef01Data := toMapAny(vs.GetProp(
			vs.GetPath([]any{"new", "planet"}, setup.data), "planet_ref01"))

		createResult, err := planetEnt.Create(planetRef01Data, nil)
		if err != nil {
			t.Fatalf("create failed: %v", err)
		}
		createData := toMapAny(createResult)
		if createData == nil {
			t.Fatal("expected create result to be a map")
		}
		if createData["id"] == nil {
			t.Fatal("expected created entity to have an id")
		}

		// LIST
		planetRef01Match := map[string]any{}
		listResult, err := planetEnt.List(planetRef01Match, nil)
		if err != nil {
			t.Fatalf("list failed: %v", err)
		}
		listData, ok := listResult.([]any)
		if !ok {
			t.Fatalf("expected list result to be an array, got %T", listResult)
		}

		found := vs.Select(entityListToData(listData), map[string]any{"id": createData["id"]})
		if vs.IsEmpty(found) {
			t.Fatal("expected to find created entity in list")
		}

		// UPDATE
		markValue := fmt.Sprintf("Mark01-planet_ref01_%d", setup.now)
		planetRef01DataUp := map[string]any{
			"id":   createData["id"],
			"kind": markValue,
		}

		updateResult, err := planetEnt.Update(planetRef01DataUp, nil)
		if err != nil {
			t.Fatalf("update failed: %v", err)
		}
		updateData := toMapAny(updateResult)
		if updateData == nil {
			t.Fatal("expected update result to be a map")
		}
		if updateData["id"] != createData["id"] {
			t.Fatal("expected update result id to match")
		}
		if updateData["kind"] != markValue {
			t.Fatalf("expected kind to be updated, got %v", updateData["kind"])
		}

		// LOAD
		planetRef01MatchDt := map[string]any{
			"id": createData["id"],
		}
		loadResult, err := planetEnt.Load(planetRef01MatchDt, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		loadData := toMapAny(loadResult)
		if loadData == nil {
			t.Fatal("expected load result to be a map")
		}
		if loadData["id"] != createData["id"] {
			t.Fatal("expected load result id to match")
		}

		// REMOVE
		planetRef01MatchRm := map[string]any{
			"id": createData["id"],
		}
		_, err = planetEnt.Remove(planetRef01MatchRm, nil)
		if err != nil {
			t.Fatalf("remove failed: %v", err)
		}

		// LIST (verify removed)
		planetRef01MatchRt := map[string]any{}
		listResult2, err := planetEnt.List(planetRef01MatchRt, nil)
		if err != nil {
			t.Fatalf("list after remove failed: %v", err)
		}
		listData2, ok := listResult2.([]any)
		if !ok {
			t.Fatalf("expected list result to be an array, got %T", listResult2)
		}

		found2 := vs.Select(entityListToData(listData2), map[string]any{"id": createData["id"]})
		if !vs.IsEmpty(found2) {
			t.Fatal("expected removed entity to not be in list")
		}
	})
}

func planetBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", ".sdk", "test", "entity", "planet", "PlanetTestData.json")

	entityDataSource, err := os.ReadFile(entityDataFile)
	if err != nil {
		panic("failed to read planet test data: " + err.Error())
	}

	var entityData map[string]any
	if err := json.Unmarshal(entityDataSource, &entityData); err != nil {
		panic("failed to parse planet test data: " + err.Error())
	}

	options := map[string]any{}
	options["entity"] = entityData["existing"]

	client := TestSDK(options, extra)

	// Generate idmap via transform, matching TS pattern.
	idmap := vs.Transform(
		[]any{"planet01", "planet02", "planet03"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	env := envOverride(map[string]any{
		"SOLARDEMO_TEST_PLANET_ENTID": idmap,
		"SOLARDEMO_TEST_LIVE":        "FALSE",
		"SOLARDEMO_TEST_EXPLAIN":     "FALSE",
		"SOLARDEMO_APIKEY":           "NONE",
	})

	idmapResolved := toMapAny(env["SOLARDEMO_TEST_PLANET_ENTID"])
	if idmapResolved == nil {
		idmapResolved = toMapAny(idmap)
	}

	if env["SOLARDEMO_TEST_LIVE"] == "TRUE" {
		mergedOpts := vs.Merge([]any{
			map[string]any{
				"apikey": env["SOLARDEMO_APIKEY"],
			},
			extra,
		})
		client = NewSolardemoSDK(toMapAny(mergedOpts))
	}

	return &entityTestSetup{
		client:  client,
		data:    entityData,
		idmap:   idmapResolved,
		env:     env,
		explain: env["SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
		now:     time.Now().UnixMilli(),
	}
}
