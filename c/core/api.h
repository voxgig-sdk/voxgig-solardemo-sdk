// Solardemo SDK public API (generated).

#ifndef SOLARDEMO_API_H
#define SOLARDEMO_API_H

#include "sdk.h"

// Moon entity.
Entity* moon_entity_new(SolardemoSDK* client, voxgig_value* entopts);
Entity* solardemo_moon(SolardemoSDK* client, voxgig_value* entopts);
voxgig_value* moon_stream(Entity* e, const char* action, voxgig_value* args, voxgig_value* callopts, PNError** err);
// Planet entity.
Entity* planet_entity_new(SolardemoSDK* client, voxgig_value* entopts);
Entity* solardemo_planet(SolardemoSDK* client, voxgig_value* entopts);
voxgig_value* planet_stream(Entity* e, const char* action, voxgig_value* args, voxgig_value* callopts, PNError** err);

#endif // SOLARDEMO_API_H
