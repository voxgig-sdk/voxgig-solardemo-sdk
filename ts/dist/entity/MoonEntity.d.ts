import { VoxgigSolardemoEntityBase } from '../VoxgigSolardemoEntityBase';
import type { VoxgigSolardemoSDK } from '../VoxgigSolardemoSDK';
import type { Control } from '../types';
import type { Moon, MoonLoadMatch, MoonListMatch, MoonCreateData, MoonUpdateData, MoonRemoveMatch } from '../VoxgigSolardemoTypes';
declare class MoonEntity extends VoxgigSolardemoEntityBase<Moon> {
    constructor(client: VoxgigSolardemoSDK, entopts: any);
    make(this: MoonEntity): MoonEntity;
    load(this: any, reqmatch?: MoonLoadMatch, ctrl?: Control): Promise<Moon>;
    list(this: any, reqmatch?: MoonListMatch, ctrl?: Control): Promise<Moon[]>;
    create(this: any, reqdata?: MoonCreateData, ctrl?: Control): Promise<Moon>;
    update(this: any, reqdata?: MoonUpdateData, ctrl?: Control): Promise<Moon>;
    remove(this: any, reqmatch?: MoonRemoveMatch, ctrl?: Control): Promise<Moon>;
}
export { MoonEntity };
