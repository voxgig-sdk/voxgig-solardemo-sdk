import { SolardemoEntityBase } from '../SolardemoEntityBase';
import type { SolardemoSDK } from '../SolardemoSDK';
import type { Control } from '../types';
import type { Moon, MoonLoadMatch, MoonListMatch, MoonCreateData, MoonUpdateData, MoonRemoveMatch } from '../SolardemoTypes';
declare class MoonEntity extends SolardemoEntityBase<Moon> {
    constructor(client: SolardemoSDK, entopts: any);
    make(this: MoonEntity): MoonEntity;
    load(this: any, reqmatch?: MoonLoadMatch, ctrl?: Control): Promise<MoonEntity>;
    list(this: any, reqmatch?: MoonListMatch, ctrl?: Control): Promise<MoonEntity[]>;
    create(this: any, reqdata?: MoonCreateData, ctrl?: Control): Promise<MoonEntity>;
    update(this: any, reqdata?: MoonUpdateData, ctrl?: Control): Promise<MoonEntity>;
    remove(this: any, reqmatch?: MoonRemoveMatch, ctrl?: Control): Promise<MoonEntity>;
}
export { MoonEntity };
