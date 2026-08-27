// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types are mapped
// from the canonical type sentinels. Do not edit by hand.
//
// These are DOCUMENTARY: the SDK runtime is dynamic (ops take/return
// `voxgig_value*`), so nothing consumes these structs yet — they mirror the
// entity/op shapes for reference and IDE support. This header is standalone
// and is not #included by any generated .c.

#ifndef SOLARDEMO_ENTITY_TYPES_H
#define SOLARDEMO_ENTITY_TYPES_H

#include "sdk.h"

// Moon is the typed data model for the moon entity.
typedef struct {
  double diameter;
  char*id;
  char*kind;
  char*name;
  char*planet_id;
} Moon;

// MoonLoadMatch is the typed request payload for Moon.load.
typedef struct {
  char*id;
  char*planet_id;
} MoonLoadMatch;

// MoonListMatch is the typed request payload for Moon.list.
typedef struct {
  char*planet_id;
} MoonListMatch;

// MoonCreateData is the typed request payload for Moon.create.
typedef struct {
  char*planet_id;
  double diameter;
  char*id;
  char*kind;
  char*name;
} MoonCreateData;

// MoonUpdateData is the typed request payload for Moon.update.
typedef struct {
  char*id;
  char*planet_id;
  double diameter;  // optional
  char*kind;  // optional
  char*name;  // optional
} MoonUpdateData;

// MoonRemoveMatch is the typed request payload for Moon.remove.
typedef struct {
  char*id;
  char*planet_id;
} MoonRemoveMatch;

// Planet is the typed data model for the planet entity.
typedef struct {
  double diameter;
  bool forbid;  // optional
  char*id;
  char*kind;
  char*name;
  bool ok;  // optional
  bool start;  // optional
  char*state;  // optional
  bool stop;  // optional
  char*why;  // optional
} Planet;

// PlanetLoadMatch is the typed request payload for Planet.load.
typedef struct {
  char*id;
} PlanetLoadMatch;

// PlanetListMatch is the typed request payload for Planet.list.
typedef struct {
  double diameter;  // optional
  bool forbid;  // optional
  char*id;  // optional
  char*kind;  // optional
  char*name;  // optional
  bool ok;  // optional
  bool start;  // optional
  char*state;  // optional
  bool stop;  // optional
  char*why;  // optional
} PlanetListMatch;

// PlanetCreateData is the typed request payload for Planet.create.
typedef struct {
  double diameter;
  bool forbid;  // optional
  char*id;
  char*kind;
  char*name;
  bool ok;  // optional
  bool start;  // optional
  char*state;  // optional
  bool stop;  // optional
  char*why;  // optional
} PlanetCreateData;

// PlanetUpdateData is the typed request payload for Planet.update.
typedef struct {
  char*id;
  double diameter;  // optional
  bool forbid;  // optional
  char*kind;  // optional
  char*name;  // optional
  bool ok;  // optional
  bool start;  // optional
  char*state;  // optional
  bool stop;  // optional
  char*why;  // optional
} PlanetUpdateData;

// PlanetRemoveMatch is the typed request payload for Planet.remove.
typedef struct {
  char*id;
} PlanetRemoveMatch;

#endif // SOLARDEMO_ENTITY_TYPES_H
