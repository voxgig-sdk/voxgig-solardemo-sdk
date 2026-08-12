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

func TestPlanetEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.Planet(nil)
		if ent == nil {
			t.Fatal("expected non-nil PlanetEntity")
		}
	})

	// Feature #4: the entity Stream(action, ...) method runs the op pipeline and
	// returns a channel over result items. With the streaming feature active it
	// yields the feature's incremental output; otherwise it falls back to the
	// materialised list so Stream always yields.
	t.Run("stream", func(t *testing.T) {
		seed := map[string]any{
			"entity": map[string]any{
				"planet": map[string]any{
					"s1": map[string]any{"id": "s1"},
					"s2": map[string]any{"id": "s2"},
					"s3": map[string]any{"id": "s3"},
				},
			},
		}

		// Fallback: streaming inactive -> yields the materialised list items.
		base := sdk.TestSDK(seed, nil)
		var seen []any
		for item := range base.Planet(nil).Stream("list", nil, nil) {
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
			for item := range streamSdk.Planet(nil).Stream("list", nil, nil) {
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
		setup := planetBasicSetup(nil)
		// Per-op sdk-test-control.json skip — basic test exercises a flow
		// with multiple ops; skipping any op skips the whole flow.
		_mode := "unit"
		if setup.live {
			_mode = "live"
		}
		for _, _op := range []string{"create", "list", "update", "load", "remove"} {
			if _shouldSkip, _reason := isControlSkipped("entityOp", "planet." + _op, _mode); _shouldSkip {
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
			t.Skip("live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live")
			return
		}
		client := setup.client

		// CREATE
		planetRef01Ent := client.Planet(nil)
		planetRef01Data := core.ToMapAny(vs.GetProp(
			vs.GetPath([]any{"new", "planet"}, setup.data), "planet_ref01"))

		planetRef01DataResult, err := planetRef01Ent.Create(planetRef01Data, nil)
		if err != nil {
			t.Fatalf("create failed: %v", err)
		}
		planetRef01Data = core.ToMapAny(entityData(planetRef01DataResult))
		if planetRef01Data == nil {
			t.Fatal("expected create result to be a map")
		}
		if planetRef01Data["id"] == nil {
			t.Fatal("expected created entity to have an id")
		}

		// LIST
		planetRef01Match := map[string]any{}

		planetRef01ListResult, err := planetRef01Ent.List(planetRef01Match, nil)
		if err != nil {
			t.Fatalf("list failed: %v", err)
		}
		planetRef01List, planetRef01ListOk := planetRef01ListResult.([]any)
		if !planetRef01ListOk {
			t.Fatalf("expected list result to be an array, got %T", planetRef01ListResult)
		}

		foundItem := vs.Select(entityListToData(planetRef01List), map[string]any{"id": planetRef01Data["id"]})
		if vs.IsEmpty(foundItem) {
			t.Fatal("expected to find created entity in list")
		}

		// UPDATE
		planetRef01DataUp0Up := map[string]any{
			"id": planetRef01Data["id"],
		}

		planetRef01MarkdefUp0Name := "kind"
		planetRef01MarkdefUp0Value := fmt.Sprintf("Mark01-planet_ref01_%d", setup.now)
		planetRef01DataUp0Up[planetRef01MarkdefUp0Name] = planetRef01MarkdefUp0Value

		planetRef01ResdataUp0Result, err := planetRef01Ent.Update(planetRef01DataUp0Up, nil)
		if err != nil {
			t.Fatalf("update failed: %v", err)
		}
		planetRef01ResdataUp0 := core.ToMapAny(entityData(planetRef01ResdataUp0Result))
		if planetRef01ResdataUp0 == nil {
			t.Fatal("expected update result to be a map")
		}
		if planetRef01ResdataUp0["id"] != planetRef01DataUp0Up["id"] {
			t.Fatal("expected update result id to match")
		}
		if planetRef01ResdataUp0[planetRef01MarkdefUp0Name] != planetRef01MarkdefUp0Value {
			t.Fatalf("expected %s to be updated, got %v", planetRef01MarkdefUp0Name, planetRef01ResdataUp0[planetRef01MarkdefUp0Name])
		}

		// LOAD
		planetRef01MatchDt0 := map[string]any{
			"id": planetRef01Data["id"],
		}
		planetRef01DataDt0Loaded, err := planetRef01Ent.Load(planetRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		planetRef01DataDt0LoadResult := core.ToMapAny(entityData(planetRef01DataDt0Loaded))
		if planetRef01DataDt0LoadResult == nil {
			t.Fatal("expected load result to be a map")
		}
		if planetRef01DataDt0LoadResult["id"] != planetRef01Data["id"] {
			t.Fatal("expected load result id to match")
		}

		// REMOVE
		planetRef01MatchRm0 := map[string]any{
			"id": planetRef01Data["id"],
		}
		_, err = planetRef01Ent.Remove(planetRef01MatchRm0, nil)
		if err != nil {
			t.Fatalf("remove failed: %v", err)
		}

		// LIST
		planetRef01MatchRt0 := map[string]any{}

		planetRef01ListRt0Result, err := planetRef01Ent.List(planetRef01MatchRt0, nil)
		if err != nil {
			t.Fatalf("list failed: %v", err)
		}
		planetRef01ListRt0, planetRef01ListRt0Ok := planetRef01ListRt0Result.([]any)
		if !planetRef01ListRt0Ok {
			t.Fatalf("expected list result to be an array, got %T", planetRef01ListRt0Result)
		}

		notFoundItem := vs.Select(entityListToData(planetRef01ListRt0), map[string]any{"id": planetRef01Data["id"]})
		if !vs.IsEmpty(notFoundItem) {
			t.Fatal("expected removed entity to not be in list")
		}

	})
}

func planetBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", "..", ".sdk", "test", "entity", "planet", "PlanetTestData.json")

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

	client := sdk.TestSDK(options, extra)

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

	// Detect ENTID env override before envOverride consumes it. When live
	// mode is on without a real override, the basic test runs against synthetic
	// IDs from the fixture and 4xx's. Surface this so the test can skip.
	entidEnvRaw := os.Getenv("SOLARDEMO_TEST_PLANET_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"SOLARDEMO_TEST_PLANET_ENTID": idmap,
		"SOLARDEMO_TEST_LIVE":      "FALSE",
		"SOLARDEMO_TEST_EXPLAIN":   "FALSE",
	})

	idmapResolved := core.ToMapAny(env["SOLARDEMO_TEST_PLANET_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}

	if env["SOLARDEMO_TEST_LIVE"] == "TRUE" {
		mergedOpts := vs.Merge([]any{
			map[string]any{
			},
			extra,
		})
		client = sdk.NewSolardemoSDK(core.ToMapAny(mergedOpts))
	}

	live := env["SOLARDEMO_TEST_LIVE"] == "TRUE"
	return &entityTestSetup{
		client:        client,
		data:          entityData,
		idmap:         idmapResolved,
		env:           env,
		explain:       env["SOLARDEMO_TEST_EXPLAIN"] == "TRUE",
		live:          live,
		syntheticOnly: live && !idmapOverridden,
		now:           time.Now().UnixMilli(),
	}
}
