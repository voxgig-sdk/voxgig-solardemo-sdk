package voxgig.solardemosdk.core;

// Typed reference models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels (source of truth: @voxgig/apidef VALID_CANON). Do
// not edit by hand.
//
// These records are documentation/DX reference shapes ONLY. The SDK ops take
// and return the loose object model (Map<String, Object> / Object) at runtime,
// so these types are not wired into the op signatures — use them to describe a
// payload before converting it to a map. Every component is a boxed (nullable)
// type, so an optional (req:false) key needs no distinct rendering.

import java.util.List;
import java.util.Map;

public final class SolardemoTypes {

  private SolardemoTypes() {}

  public record Moon(Double diameter, String id, String kind, String name, String planet_id) {}

  public record MoonLoadMatch(String id, String planet_id) {}

  public record MoonListMatch(String planet_id) {}

  public record MoonCreateData(String planet_id, Double diameter, String id, String kind, String name) {}

  public record MoonUpdateData(String id, String planet_id, Double diameter, String kind, String name) {}

  public record MoonRemoveMatch(String id, String planet_id) {}

  public record Planet(Double diameter, Boolean forbid, String id, String kind, String name, Boolean ok, Boolean start, String state, Boolean stop, String why) {}

  public record PlanetLoadMatch(String id) {}

  public record PlanetListMatch(Double diameter, Boolean forbid, String id, String kind, String name, Boolean ok, Boolean start, String state, Boolean stop, String why) {}

  public record PlanetCreateData(Double diameter, Boolean forbid, String id, String kind, String name, Boolean ok, Boolean start, String state, Boolean stop, String why) {}

  public record PlanetUpdateData(String id, Double diameter, Boolean forbid, String kind, String name, Boolean ok, Boolean start, String state, Boolean stop, String why) {}

  public record PlanetRemoveMatch(String id) {}

}
