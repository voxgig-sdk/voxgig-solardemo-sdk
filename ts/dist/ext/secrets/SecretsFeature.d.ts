import type { Context, FeatureOptions } from '../../types';
import { BaseFeature } from '../../feature/base/BaseFeature';
import { Sekreto } from './sekreto';
declare class SecretsFeature extends BaseFeature {
    version: string;
    name: string;
    active: boolean;
    _client: any;
    _options: any;
    _sekreto?: Sekreto;
    _secretname: string;
    _resolving?: Promise<void>;
    init(ctx: Context, options: FeatureOptions): void;
    PreSpec(_ctx: Context): Promise<void> | undefined;
    resolve(): Promise<void>;
    secrets(): Sekreto | undefined;
    private _resolveonce;
}
export { SecretsFeature };
