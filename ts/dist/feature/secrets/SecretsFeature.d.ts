import type { Context, FeatureOptions } from '../../types';
import { BaseFeature } from '../base/BaseFeature';
import { Sekreto } from '../../utility/sekreto';
declare class SecretsFeature extends BaseFeature {
    version: string;
    name: string;
    _client: any;
    _sekreto?: Sekreto;
    _secretname: string;
    _resolving?: Promise<void>;
    init(ctx: Context, fopts: FeatureOptions): void;
    PreSpec(_ctx: Context): Promise<void>;
    resolve(): Promise<void>;
    private _resolveonce;
}
export { SecretsFeature };
