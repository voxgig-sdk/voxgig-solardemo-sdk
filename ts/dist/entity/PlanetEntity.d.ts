import { SolardemoEntityBase } from '../SolardemoEntityBase';
import type { SolardemoSDK } from '../SolardemoSDK';
import type { Control } from '../types';
import type { Planet, PlanetLoadMatch, PlanetListMatch, PlanetCreateData, PlanetUpdateData, PlanetRemoveMatch } from '../SolardemoTypes';
declare class PlanetEntity extends SolardemoEntityBase<Planet> {
    constructor(client: SolardemoSDK, entopts: any);
    make(this: PlanetEntity): PlanetEntity;
    load(this: any, reqmatch?: PlanetLoadMatch, ctrl?: Control): Promise<PlanetEntity>;
    list(this: any, reqmatch?: PlanetListMatch, ctrl?: Control): Promise<PlanetEntity[]>;
    create(this: any, reqdata?: PlanetCreateData, ctrl?: Control): Promise<PlanetEntity>;
    update(this: any, reqdata?: PlanetUpdateData, ctrl?: Control): Promise<PlanetEntity>;
    remove(this: any, reqmatch?: PlanetRemoveMatch, ctrl?: Control): Promise<PlanetEntity>;
}
export { PlanetEntity };
