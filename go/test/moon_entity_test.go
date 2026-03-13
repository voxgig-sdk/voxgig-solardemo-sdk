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
		moonEnt := client.Moon(nil)
		moonRef01Data := core.ToMapAny(vs.GetProp(
			vs.GetPath([]any{"new", "moon"}, setup.data), "moon_ref01"))
		moonRef01Data["planet_id"] = setup.idmap["planet01"]

		createResult, err := moonEnt.Create(moonRef01Data, nil)
		if err != nil {
			t.Fatalf("create failed: %v", err)
		}
		createData := core.ToMapAny(createResult)
		if createData == nil {
			t.Fatal("expected create result to be a map")
		}
		if createData["id"] == nil {
			t.Fatal("expected created entity to have an id")
		}

		// LIST
		moonRef01Match := map[string]any{
			"planet_id": setup.idmap["planet01"],
		}
		listResult, err := moonEnt.List(moonRef01Match, nil)
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
		markValue := fmt.Sprintf("Mark01-moon_ref01_%d", setup.now)
		moonRef01DataUp := map[string]any{
			"id":        createData["id"],
			"planet_id": setup.idmap["planet_id"],
			"kind":      markValue,
		}

		updateResult, err := moonEnt.Update(moonRef01DataUp, nil)
		if err != nil {
			t.Fatalf("update failed: %v", err)
		}
		updateData := core.ToMapAny(updateResult)
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
		moonRef01MatchDt := map[string]any{
			"id": createData["id"],
		}
		loadResult, err := moonEnt.Load(moonRef01MatchDt, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		loadData := core.ToMapAny(loadResult)
		if loadData == nil {
			t.Fatal("expected load result to be a map")
		}
		if loadData["id"] != createData["id"] {
			t.Fatal("expected load result id to match")
		}

		// REMOVE
		moonRef01MatchRm := map[string]any{
			"id": createData["id"],
		}
		_, err = moonEnt.Remove(moonRef01MatchRm, nil)
		if err != nil {
			t.Fatalf("remove failed: %v", err)
		}

		// LIST (verify removed)
		moonRef01MatchRt := map[string]any{
			"planet_id": setup.idmap["planet01"],
		}
		listResult2, err := moonEnt.List(moonRef01MatchRt, nil)
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

// entityListToData extracts data maps from a list of Entity objects.
func entityListToData(list []any) []any {
	var out []any
	for _, item := range list {
		if ent, ok := item.(sdk.Entity); ok {
			d := ent.Data()
			if dm, ok := d.(map[string]any); ok {
				out = append(out, dm)
			}
		} else if m, ok := item.(map[string]any); ok {
			out = append(out, m)
		}
	}
	if out == nil {
		out = []any{}
	}
	return out
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
