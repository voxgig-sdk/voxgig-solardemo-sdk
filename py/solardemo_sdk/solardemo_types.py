# Typed models for the Solardemo SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Field/param types come from the
# canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
# @voxgig/apidef VALID_CANON). Do not edit by hand.
#
# These are TypedDicts, not dataclasses: the SDK ops return/accept plain dicts
# at runtime, and a TypedDict IS a dict shape, so the types match the runtime.
# Optional (req:false) keys are modelled as TypedDict key-optionality
# (total=False), split into a required base + total=False subclass when a type
# has both required and optional keys.

from __future__ import annotations

from typing import TypedDict, Any


class Moon(TypedDict):
    diameter: float
    id: str
    kind: str
    name: str
    planet_id: str


class MoonLoadMatch(TypedDict):
    id: str
    planet_id: str


class MoonListMatch(TypedDict):
    planet_id: str


class MoonCreateData(TypedDict):
    planet_id: str
    diameter: float
    id: str
    kind: str
    name: str


class MoonUpdateDataRequired(TypedDict):
    id: str
    planet_id: str


class MoonUpdateData(MoonUpdateDataRequired, total=False):
    diameter: float
    kind: str
    name: str


class MoonRemoveMatch(TypedDict):
    id: str
    planet_id: str


class PlanetRequired(TypedDict):
    diameter: float
    id: str
    kind: str
    name: str


class Planet(PlanetRequired, total=False):
    forbid: bool
    ok: bool
    start: bool
    state: str
    stop: bool
    why: str


class PlanetLoadMatch(TypedDict):
    id: str


class PlanetListMatch(TypedDict, total=False):
    diameter: float
    forbid: bool
    id: str
    kind: str
    name: str
    ok: bool
    start: bool
    state: str
    stop: bool
    why: str


class PlanetCreateDataRequired(TypedDict):
    diameter: float
    id: str
    kind: str
    name: str


class PlanetCreateData(PlanetCreateDataRequired, total=False):
    forbid: bool
    ok: bool
    start: bool
    state: str
    stop: bool
    why: str


class PlanetUpdateDataRequired(TypedDict):
    id: str


class PlanetUpdateData(PlanetUpdateDataRequired, total=False):
    diameter: float
    forbid: bool
    kind: str
    name: str
    ok: bool
    start: bool
    state: str
    stop: bool
    why: str


class PlanetRemoveMatch(TypedDict):
    id: str
