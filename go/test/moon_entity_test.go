package sdktest

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	sdk "voxgigsolardemosdk"
	"voxgigsolardemosdk/core"

	vs "github.com/voxgig/struct"
)

func TestMoonEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.Moon(nil)
		if ent == nil {
			t.Fatal("expected non-nil MoonEntity")
		}
	})

	t.Run("basic", func(t *testing.T) {
		setup := moonBasicSetup(nil)
		client := setup.client

		// CREATE
		moonRef01Ent := client.Moon(nil)
		moonRef01Data := core.ToMapAny(vs.GetProp(
			vs.GetPath([]any{"new", "moon"}, setup.data), "moon_ref01"))
		moonRef01Data["planet_id"] = setup.idmap["planet01"]

		moonRef01DataResult, err := moonRef01Ent.Create(moonRef01Data, nil)
		if err != nil {
			t.Fatalf("create failed: %v", err)
		}
		moonRef01Data = core.ToMapAny(moonRef01DataResult)
		if moonRef01Data == nil {
			t.Fatal("expected create result to be a map")
		}
		if moonRef01Data["id"] == nil {
			t.Fatal("expected created entity to have an id")
		}

		// LIST
		moonRef01Match := map[string]any{
			"planet_id": setup.idmap["planet01"],
		}

		moonRef01ListResult, err := moonRef01Ent.List(moonRef01Match, nil)
		if err != nil {
			t.Fatalf("list failed: %v", err)
		}
		moonRef01List, ok := moonRef01ListResult.([]any)
		if !ok {
			t.Fatalf("expected list result to be an array, got %T", moonRef01ListResult)
		}

		foundItem := vs.Select(entityListToData(moonRef01List), map[string]any{"id": moonRef01Data["id"]})
		if vs.IsEmpty(foundItem) {
			t.Fatal("expected to find created entity in list")
		}

		// UPDATE
		moonRef01DataUp0Up := map[string]any{
			"id": moonRef01Data["id"],
			"planet_id": setup.idmap["planet_id"],
		}

		moonRef01MarkdefUp0Name := "kind"
		moonRef01MarkdefUp0Value := fmt.Sprintf("Mark01-moon_ref01_%d", setup.now)
		moonRef01DataUp0Up[moonRef01MarkdefUp0Name] = moonRef01MarkdefUp0Value

		moonRef01ResdataUp0Result, err := moonRef01Ent.Update(moonRef01DataUp0Up, nil)
		if err != nil {
			t.Fatalf("update failed: %v", err)
		}
		moonRef01ResdataUp0 := core.ToMapAny(moonRef01ResdataUp0Result)
		if moonRef01ResdataUp0 == nil {
			t.Fatal("expected update result to be a map")
		}
		if moonRef01ResdataUp0["id"] != moonRef01DataUp0Up["id"] {
			t.Fatal("expected update result id to match")
		}
		if moonRef01ResdataUp0[moonRef01MarkdefUp0Name] != moonRef01MarkdefUp0Value {
			t.Fatalf("expected %s to be updated, got %v", moonRef01MarkdefUp0Name, moonRef01ResdataUp0[moonRef01MarkdefUp0Name])
		}

		// LOAD
		moonRef01MatchDt0 := map[string]any{
			"id": moonRef01Data["id"],
		}
		moonRef01DataDt0Loaded, err := moonRef01Ent.Load(moonRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		moonRef01DataDt0LoadResult := core.ToMapAny(moonRef01DataDt0Loaded)
		if moonRef01DataDt0LoadResult == nil {
			t.Fatal("expected load result to be a map")
		}
		if moonRef01DataDt0LoadResult["id"] != moonRef01Data["id"] {
			t.Fatal("expected load result id to match")
		}

		// REMOVE
		moonRef01MatchRm0 := map[string]any{
			"id": moonRef01Data["id"],
		}
		_, err = moonRef01Ent.Remove(moonRef01MatchRm0, nil)
		if err != nil {
			t.Fatalf("remove failed: %v", err)
		}

		// LIST
		moonRef01MatchRt0 := map[string]any{
			"planet_id": setup.idmap["planet01"],
		}

		moonRef01ListRt0Result, err := moonRef01Ent.List(moonRef01MatchRt0, nil)
		if err != nil {
			t.Fatalf("list failed: %v", err)
		}
		moonRef01ListRt0, ok := moonRef01ListRt0Result.([]any)
		if !ok {
			t.Fatalf("expected list result to be an array, got %T", moonRef01ListRt0Result)
		}

		notFoundItem := vs.Select(entityListToData(moonRef01ListRt0), map[string]any{"id": moonRef01Data["id"]})
		if !vs.IsEmpty(notFoundItem) {
			t.Fatal("expected removed entity to not be in list")
		}

	})
}

func moonBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", "..", ".sdk", "test", "entity", "moon", "MoonTestData.json")

	entityDataSource, err := os.ReadFile(entityDataFile)
	if err != nil {
		panic("failed to read moon test data: " + err.Error())
	}

	var entityData map[string]any
	if err := json.Unmarshal(entityDataSource, &entityData); err != nil {
		panic("failed to parse moon test data: " + err.Error())
	}

	options := map[string]any{}
	options["entity"] = entityData["existing"]

	client := sdk.TestSDK(options, extra)

	// Generate idmap via transform, matching TS pattern.
	idmap := vs.Transform(
		[]any{"moon01", "moon02", "moon03", "planet01", "planet02", "planet03"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	env := envOverride(map[string]any{
		"SOLARDEMO_TEST_MOON_ENTID": idmap,
		"SOLARDEMO_TEST_LIVE":      "FALSE",
		"SOLARDEMO_TEST_EXPLAIN":   "FALSE",
		"SOLARDEMO_APIKEY":         "NONE",
	})

	idmapResolved := core.ToMapAny(env["SOLARDEMO_TEST_MOON_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}
	// Add planet_id alias for update test.
	if idmapResolved["planet_id"] == nil {
		idmapResolved["planet_id"] = idmapResolved["planet01"]
	}

	if env["SOLARDEMO_TEST_LIVE"] == "TRUE" {
		mergedOpts := vs.Merge([]any{
			map[string]any{
				"apikey": env["SOLARDEMO_APIKEY"],
			},
			extra,
		})
		client = sdk.NewSolardemoSDK(core.ToMapAny(mergedOpts))
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
