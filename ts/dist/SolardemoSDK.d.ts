import { MoonEntity } from './entity/MoonEntity';
import { PlanetEntity } from './entity/PlanetEntity';
export type * from './SolardemoTypes';
import { inspect } from 'node:util';
import type { Context, Feature } from './types';
import { config } from './Config';
import { SolardemoEntityBase } from './SolardemoEntityBase';
import { Utility } from './utility/Utility';
import { BaseFeature } from './feature/base/BaseFeature';
import * as sekreto from './feature/secrets/sekreto';
declare const stdutil: Utility;
declare class SolardemoSDK {
    _mode: string;
    _options: any;
    _utility: Utility;
    _features: Feature[];
    _rootctx: Context;
    _secrets?: any;
    constructor(options?: any);
    options(): any;
    utility(): any;
    secrets(): any;
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
    static test(testoptsarg?: any, sdkoptsarg?: any): SolardemoSDK;
    tester(testopts?: any, sdkopts?: any): SolardemoSDK;
    toJSON(): {
        name: string;
    };
    toString(): string;
    [inspect.custom](): string;
}
declare const SDK: typeof SolardemoSDK;
export { stdutil, config, sekreto, BaseFeature, SolardemoEntityBase, SolardemoSDK, SDK, };
