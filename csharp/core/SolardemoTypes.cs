// Typed reference models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels (source of truth: @voxgig/apidef VALID_CANON). Do
// not edit by hand.
//
// These records are documentation/DX reference shapes ONLY. The SDK ops take
// and return the loose object model (Dictionary<string, object?> / object?) at
// runtime, so these types are not wired into the op signatures — use them to
// describe a payload before converting it to a dictionary. Optional (req:false)
// keys are modelled as nullable properties.

namespace SolardemoSdk.Types;

public record Moon
{
    public double diameter { get; init; }
    public string id { get; init; }
    public string kind { get; init; }
    public string name { get; init; }
    public string planet_id { get; init; }
}

public record MoonLoadMatch
{
    public string id { get; init; }
    public string planet_id { get; init; }
}

public record MoonListMatch
{
    public string planet_id { get; init; }
}

public record MoonCreateData
{
    public string planet_id { get; init; }
    public double diameter { get; init; }
    public string id { get; init; }
    public string kind { get; init; }
    public string name { get; init; }
}

public record MoonUpdateData
{
    public string id { get; init; }
    public string planet_id { get; init; }
    public double? diameter { get; init; }
    public string? kind { get; init; }
    public string? name { get; init; }
}

public record MoonRemoveMatch
{
    public string id { get; init; }
    public string planet_id { get; init; }
}

public record Planet
{
    public double diameter { get; init; }
    public bool? forbid { get; init; }
    public string id { get; init; }
    public string kind { get; init; }
    public string name { get; init; }
    public bool? ok { get; init; }
    public bool? start { get; init; }
    public string? state { get; init; }
    public bool? stop { get; init; }
    public string? why { get; init; }
}

public record PlanetLoadMatch
{
    public string id { get; init; }
}

public record PlanetListMatch
{
    public double? diameter { get; init; }
    public bool? forbid { get; init; }
    public string? id { get; init; }
    public string? kind { get; init; }
    public string? name { get; init; }
    public bool? ok { get; init; }
    public bool? start { get; init; }
    public string? state { get; init; }
    public bool? stop { get; init; }
    public string? why { get; init; }
}

public record PlanetCreateData
{
    public double diameter { get; init; }
    public bool? forbid { get; init; }
    public string id { get; init; }
    public string kind { get; init; }
    public string name { get; init; }
    public bool? ok { get; init; }
    public bool? start { get; init; }
    public string? state { get; init; }
    public bool? stop { get; init; }
    public string? why { get; init; }
}

public record PlanetUpdateData
{
    public string id { get; init; }
    public double? diameter { get; init; }
    public bool? forbid { get; init; }
    public string? kind { get; init; }
    public string? name { get; init; }
    public bool? ok { get; init; }
    public bool? start { get; init; }
    public string? state { get; init; }
    public bool? stop { get; init; }
    public string? why { get; init; }
}

public record PlanetRemoveMatch
{
    public string id { get; init; }
}

