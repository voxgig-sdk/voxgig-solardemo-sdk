import { MoonEntity } from './entity/MoonEntity';
import { PlanetEntity } from './entity/PlanetEntity';
export type * from './VoxgigSolardemoTypes';
import { inspect } from 'node:util';
import type { Context, Feature } from './types';
import { config } from './Config';
import { VoxgigSolardemoEntityBase } from './VoxgigSolardemoEntityBase';
import { Utility } from './utility/Utility';
import { BaseFeature } from './feature/base/BaseFeature';
declare const stdutil: Utility;
declare class VoxgigSolardemoSDK {
    _mode: string;
    _options: any;
    _utility: Utility;
    _features: Feature[];
    _rootctx: Context;
    constructor(options?: any);
    options(): any;
    utility(): any;
    prepare(fetchargs?: any): Promise<any>;
    direct(fetchargs?: any): Promise<Error | {
        ok: boolean;
        status: number;
        headers: any;
        data: any;
        err?: undefined;
    } | {
        ok: boolean;
        err: any;
        status?: undefined;
        headers?: undefined;
        data?: undefined;
    }>;
    _rawRequest(fetchargs?: any): Promise<Error | {
        ok: boolean;
        status: number;
        headers: any;
        data: any;
        err?: undefined;
    } | {
        ok: boolean;
        err: any;
        status?: undefined;
        headers?: undefined;
        data?: undefined;
    }>;
    graphql(query: string, variables?: any, ctrl?: any): Promise<any>;
    Moon(entopts?: Record<string, any>): MoonEntity;
    Planet(entopts?: Record<string, any>): PlanetEntity;
    static test(testoptsarg?: any, sdkoptsarg?: any): VoxgigSolardemoSDK;
    tester(testopts?: any, sdkopts?: any): VoxgigSolardemoSDK;
    toJSON(): {
        name: string;
    };
    toString(): string;
    [inspect.custom](): string;
}
declare const SDK: typeof VoxgigSolardemoSDK;
export { stdutil, config, BaseFeature, VoxgigSolardemoEntityBase, VoxgigSolardemoSDK, SDK, };
