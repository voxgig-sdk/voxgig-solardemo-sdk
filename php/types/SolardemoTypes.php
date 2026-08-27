<?php
declare(strict_types=1);

// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.
//
// These are documentation-grade value objects (PHP 8 typed properties),
// registered on the composer classmap autoload. The SDK boundary exchanges
// assoc-arrays; these classes name the shapes for tooling and typed callers.

/** Moon entity data model. */
class Moon
{
    public float $diameter;
    public string $id;
    public string $kind;
    public string $name;
    public string $planet_id;
}

/** Request payload for Moon#load. */
class MoonLoadMatch
{
    public string $id;
    public string $planet_id;
}

/** Request payload for Moon#list. */
class MoonListMatch
{
    public string $planet_id;
}

/** Request payload for Moon#create. */
class MoonCreateData
{
    public string $planet_id;
    public float $diameter;
    public string $id;
    public string $kind;
    public string $name;
}

/** Request payload for Moon#update. */
class MoonUpdateData
{
    public string $id;
    public string $planet_id;
    public ?float $diameter = null;
    public ?string $kind = null;
    public ?string $name = null;
}

/** Request payload for Moon#remove. */
class MoonRemoveMatch
{
    public string $id;
    public string $planet_id;
}

/** Planet entity data model. */
class Planet
{
    public float $diameter;
    public ?bool $forbid = null;
    public string $id;
    public string $kind;
    public string $name;
    public ?bool $ok = null;
    public ?bool $start = null;
    public ?string $state = null;
    public ?bool $stop = null;
    public ?string $why = null;
}

/** Request payload for Planet#load. */
class PlanetLoadMatch
{
    public string $id;
}

/** Request payload for Planet#list. */
class PlanetListMatch
{
    public ?float $diameter = null;
    public ?bool $forbid = null;
    public ?string $id = null;
    public ?string $kind = null;
    public ?string $name = null;
    public ?bool $ok = null;
    public ?bool $start = null;
    public ?string $state = null;
    public ?bool $stop = null;
    public ?string $why = null;
}

/** Request payload for Planet#create. */
class PlanetCreateData
{
    public float $diameter;
    public ?bool $forbid = null;
    public string $id;
    public string $kind;
    public string $name;
    public ?bool $ok = null;
    public ?bool $start = null;
    public ?string $state = null;
    public ?bool $stop = null;
    public ?string $why = null;
}

/** Request payload for Planet#update. */
class PlanetUpdateData
{
    public string $id;
    public ?float $diameter = null;
    public ?bool $forbid = null;
    public ?string $kind = null;
    public ?string $name = null;
    public ?bool $ok = null;
    public ?bool $start = null;
    public ?string $state = null;
    public ?bool $stop = null;
    public ?string $why = null;
}

/** Request payload for Planet#remove. */
class PlanetRemoveMatch
{
    public string $id;
}

