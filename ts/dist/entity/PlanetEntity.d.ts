import { VoxgigSolardemoEntityBase } from '../VoxgigSolardemoEntityBase';
import type { VoxgigSolardemoSDK } from '../VoxgigSolardemoSDK';
import type { Control } from '../types';
import type { Planet, PlanetLoadMatch, PlanetListMatch, PlanetCreateData, PlanetUpdateData, PlanetRemoveMatch } from '../VoxgigSolardemoTypes';
declare class PlanetEntity extends VoxgigSolardemoEntityBase<Planet> {
    constructor(client: VoxgigSolardemoSDK, entopts: any);
    make(this: PlanetEntity): PlanetEntity;
    load(this: any, reqmatch?: PlanetLoadMatch, ctrl?: Control): Promise<Planet>;
    list(this: any, reqmatch?: PlanetListMatch, ctrl?: Control): Promise<Planet[]>;
    create(this: any, reqdata?: PlanetCreateData, ctrl?: Control): Promise<Planet>;
    update(this: any, reqdata?: PlanetUpdateData, ctrl?: Control): Promise<Planet>;
    remove(this: any, reqmatch?: PlanetRemoveMatch, ctrl?: Control): Promise<Planet>;
}
export { PlanetEntity };
