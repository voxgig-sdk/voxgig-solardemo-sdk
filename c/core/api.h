// VoxgigSolardemo SDK public API (generated).

#ifndef VOXGIGSOLARDEMO_API_H
#define VOXGIGSOLARDEMO_API_H

#include "sdk.h"

// Moon entity.
Entity* moon_entity_new(VoxgigSolardemoSDK* client, voxgig_value* entopts);
Entity* voxgigsolardemo_moon(VoxgigSolardemoSDK* client, voxgig_value* entopts);
voxgig_value* moon_stream(Entity* e, const char* action, voxgig_value* args, voxgig_value* callopts, PNError** err);
// Planet entity.
Entity* planet_entity_new(VoxgigSolardemoSDK* client, voxgig_value* entopts);
Entity* voxgigsolardemo_planet(VoxgigSolardemoSDK* client, voxgig_value* entopts);
voxgig_value* planet_stream(Entity* e, const char* action, voxgig_value* args, voxgig_value* callopts, PNError** err);

#endif // VOXGIGSOLARDEMO_API_H
