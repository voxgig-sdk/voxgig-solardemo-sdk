package sdktest

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"

	sdk "github.com/voxgig-sdk/voxgig-solardemo-sdk/go"
	"github.com/voxgig-sdk/voxgig-solardemo-sdk/go/core"

	vs "github.com/voxgig-sdk/voxgig-solardemo-sdk/go/utility/struct"
)

// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const moonEntityLiveStrict = true


func TestMoonEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.Moon(nil)
		if ent == nil {
			t.Fatal("expected non-nil MoonEntity")
		}
	})

	t.Run("validate", func(t *testing.T) {
		if !fhHasFeature("validate") {
			t.Skip("feature not present in this SDK: validate")
		}
		client := sdk.TestSDK(nil, map[string]any{
			"feature": map[string]any{"validate": map[string]any{"active": true}},
		})
		_, err := client.Moon(nil).List(map[string]any{"planet_id": 1}, nil)
		if sdkerr, ok := err.(*core.VoxgigSolardemoError); !ok || "validate_failed" != sdkerr.Code {
			t.Fatalf("expected validate_failed, got %v", err)
		}
	})

	t.Run("basic", func(tt *testing.T) {
		var t testing.TB = tt
		setup := moonBasicSetup(nil)
		// Per-op sdk-test-control.json skip — basic test exercises a flow
		// with multiple ops; skipping any op skips the whole flow.
		_mode := "unit"
		if setup.live {
			_mode = "live"
		}
		for _, _op := range []string{"create", "list", "update", "load", "remove"} {
			if _shouldSkip, _reason := isControlSkipped("entityOp", "moon." + _op, _mode); _shouldSkip {
				if _reason == "" {
					_reason = "skipped via sdk-test-control.json"
				}
				t.Skip(_reason)
				return
			}
		}
		if setup.live {
			for _, _liveKey := range []string{"planet01"} {
				if setup.syntheticOnly || setup.idmap[_liveKey] == nil {
					liveMiss(t, moonEntityLiveStrict, "Live entity test blocked: needs %s via VOXGIG_SOLARDEMO_TEST_MOON_ENTID", _liveKey)
				}
			}
		}
		client := setup.client
		_ = client

		// CREATE
		moonRef01Ent := client.Moon(nil)
		moonRef01Data := core.ToMapAny(vs.GetProp(
			vs.GetPath(setup.data, []any{"new", "moon"}), "moon_ref01"))
		moonRef01Data["planet_id"] = setup.idmap["planet01"]

		moonRef01DataResult, err := moonRef01Ent.Create(moonRef01Data, nil)
		if err != nil {
			t.Fatalf("create failed: %v", err)
		}
		moonRef01Data = core.ToMapAny(entityData(moonRef01DataResult))
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
		moonRef01List, moonRef01ListOk := moonRef01ListResult.([]any)
		if !moonRef01ListOk {
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
		moonRef01ResdataUp0 := core.ToMapAny(entityData(moonRef01ResdataUp0Result))
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
		if v := setup.idmap["planet_id"]; v != nil {
			moonRef01MatchDt0["planet_id"] = v
		} else {
			moonRef01MatchDt0["planet_id"] = setup.idmap["planet01"]
		}
		moonRef01DataDt0Loaded, err := moonRef01Ent.Load(moonRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		moonRef01DataDt0LoadResult := core.ToMapAny(entityData(moonRef01DataDt0Loaded))
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
		if v := setup.idmap["planet_id"]; v != nil {
			moonRef01MatchRm0["planet_id"] = v
		} else {
			moonRef01MatchRm0["planet_id"] = setup.idmap["planet01"]
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
		moonRef01ListRt0, moonRef01ListRt0Ok := moonRef01ListRt0Result.([]any)
		if !moonRef01ListRt0Ok {
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
	idmap, _ := vs.Transform(
		[]any{"moon01", "moon02", "moon03", "planet01", "planet02", "planet03"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	// Whether *_ENTID supplied the idmap, read before envOverride consumes it:
	// without it, the ids a live flow binds are the fixture's synthetic ones.
	entidEnvRaw := os.Getenv("VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"VOXGIG_SOLARDEMO_TEST_MOON_ENTID": idmap,
		"VOXGIG_SOLARDEMO_TEST_LIVE":      "FALSE",
		"VOXGIG_SOLARDEMO_TEST_EXPLAIN":   "FALSE",
	})

	idmapResolved := core.ToMapAny(env["VOXGIG_SOLARDEMO_TEST_MOON_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}
	// Add planet_id alias for update test.
	if idmapResolved["planet_id"] == nil {
		idmapResolved["planet_id"] = idmapResolved["planet01"]
	}

	if env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE" {
		// An empty map, not a nil one: Merge returns nil when its last entry
		// is nil, and BasicSetup is normally called with no extras - so a
		// bare nil silently discarded the apikey and server values below.
		extraOpts := extra
		if extraOpts == nil {
			extraOpts = map[string]any{}
		}

		mergedOpts := vs.Merge([]any{
			// liveClientOptions() FIRST, so the generated fields below win:
			// sdk-test-control.json's test.client.options adds to the live
			// client, it does not redirect it.
			liveClientOptions(),
			map[string]any{
			},
			extraOpts,
		})
		client = sdk.NewVoxgigSolardemoSDK(core.ToMapAny(mergedOpts))
	}

	live := env["VOXGIG_SOLARDEMO_TEST_LIVE"] == "TRUE"
	return &entityTestSetup{
		client:        client,
		data:          entityData,
		idmap:         idmapResolved,
		env:           env,
		explain:       env["VOXGIG_SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
		live:          live,
		syntheticOnly: live && !idmapOverridden,
		now:           time.Now().UnixMilli(),
	}
}
