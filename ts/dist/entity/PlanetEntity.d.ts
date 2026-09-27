import { VoxgigSolardemoEntityBase } from '../VoxgigSolardemoEntityBase';
import type { VoxgigSolardemoSDK } from '../VoxgigSolardemoSDK';
import type { Control } from '../types';
import type { Planet, PlanetLoadMatch, PlanetListMatch, PlanetCreateData, PlanetUpdateData, PlanetRemoveMatch } from '../VoxgigSolardemoTypes';
declare class PlanetEntity extends VoxgigSolardemoEntityBase<Planet> {
    constructor(client: VoxgigSolardemoSDK, entopts: any);
    make(this: PlanetEntity): PlanetEntity;
    load(this: any, reqmatch?: PlanetLoadMatch, ctrl?: Control): Promise<PlanetEntity>;
    list(this: any, reqmatch?: PlanetListMatch, ctrl?: Control): Promise<PlanetEntity[]>;
    create(this: any, reqdata?: PlanetCreateData, ctrl?: Control): Promise<PlanetEntity>;
    update(this: any, reqdata?: PlanetUpdateData, ctrl?: Control): Promise<PlanetEntity>;
    remove(this: any, reqmatch?: PlanetRemoveMatch, ctrl?: Control): Promise<PlanetEntity>;
}
export { PlanetEntity };
