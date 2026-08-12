import { Context } from './Context';
declare class VoxgigSolardemoError extends Error {
    isVoxgigSolardemoError: boolean;
    sdk: string;
    code: string;
    ctx: Context;
    constructor(code: string, msg: string, ctx: Context);
}
export { VoxgigSolardemoError };
