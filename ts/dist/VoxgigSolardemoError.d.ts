import { Context } from './Context';
declare class VoxgigSolardemoError extends Error {
    isVoxgigSolardemoError: boolean;
    sdk: string;
    code: string;
    ctx: Context;
    status: number;
    get notFound(): boolean;
    constructor(code: string, msg: string, ctx: Context);
}
export { VoxgigSolardemoError };
