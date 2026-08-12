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

func TestMoonEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.Moon(nil)
		if ent == nil {
			t.Fatal("expected non-nil MoonEntity")
		}
	})

	// Feature #4: the entity Stream(action, ...) method runs the op pipeline and
	// returns a channel over result items. With the streaming feature active it
	// yields the feature's incremental output; otherwise it falls back to the
	// materialised list so Stream always yields.
	t.Run("stream", func(t *testing.T) {
		seed := map[string]any{
			"entity": map[string]any{
				"moon": map[string]any{
					"s1": map[string]any{"id": "s1"},
					"s2": map[string]any{"id": "s2"},
					"s3": map[string]any{"id": "s3"},
				},
			},
		}

		// Fallback: streaming inactive -> yields the materialised list items.
		base := sdk.TestSDK(seed, nil)
		var seen []any
		for item := range base.Moon(nil).Stream("list", nil, nil) {
			seen = append(seen, item)
		}
		if len(seen) != 3 {
			t.Fatalf("expected 3 streamed items, got %d", len(seen))
		}

		// Inbound: streaming active -> yields each item from the feature iterator.
		hasStreaming := false
		if fm, ok := core.MakeConfig()["feature"].(map[string]any); ok {
			_, hasStreaming = fm["streaming"]
		}
		if hasStreaming {
			streamSdk := sdk.TestSDK(seed, map[string]any{
				"feature": map[string]any{"streaming": map[string]any{"active": true}},
			})
			var got []any
			for item := range streamSdk.Moon(nil).Stream("list", nil, nil) {
				if sub, ok := item.([]any); ok {
					got = append(got, sub...)
				} else {
					got = append(got, item)
				}
			}
			if len(got) != 3 {
				t.Fatalf("expected 3 items via streaming feature, got %d", len(got))
			}
		}
	})

	t.Run("basic", func(t *testing.T) {
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
		// The basic flow consumes synthetic IDs from the fixture. In live mode
		// without an *_ENTID env override, those IDs hit the live API and 4xx.
		if setup.syntheticOnly {
			t.Skip("live entity test uses synthetic IDs from fixture — set VOXGIGSOLARDEMO_TEST_MOON_ENTID JSON to run live")
			return
		}
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
	idmap := vs.Transform(
		[]any{"moon01", "moon02", "moon03", "planet01", "planet02", "planet03"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	// Detect ENTID env override before envOverride consumes it. When live
	// mode is on without a real override, the basic test runs against synthetic
	// IDs from the fixture and 4xx's. Surface this so the test can skip.
	entidEnvRaw := os.Getenv("VOXGIGSOLARDEMO_TEST_MOON_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"VOXGIGSOLARDEMO_TEST_MOON_ENTID": idmap,
		"VOXGIGSOLARDEMO_TEST_LIVE":      "FALSE",
		"VOXGIGSOLARDEMO_TEST_EXPLAIN":   "FALSE",
	})

	idmapResolved := core.ToMapAny(env["VOXGIGSOLARDEMO_TEST_MOON_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}
	// Add planet_id alias for update test.
	if idmapResolved["planet_id"] == nil {
		idmapResolved["planet_id"] = idmapResolved["planet01"]
	}

	if env["VOXGIGSOLARDEMO_TEST_LIVE"] == "TRUE" {
		mergedOpts := vs.Merge([]any{
			map[string]any{
			},
			extra,
		})
		client = sdk.NewVoxgigSolardemoSDK(core.ToMapAny(mergedOpts))
	}

	live := env["VOXGIGSOLARDEMO_TEST_LIVE"] == "TRUE"
	return &entityTestSetup{
		client:        client,
		data:          entityData,
		idmap:         idmapResolved,
		env:           env,
		explain:       env["VOXGIGSOLARDEMO_TEST_EXPLAIN"] == "TRUE",
		live:          live,
		syntheticOnly: live && !idmapOverridden,
		now:           time.Now().UnixMilli(),
	}
}
