"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VoxgigSolardemoError = void 0;
class VoxgigSolardemoError extends Error {
    isVoxgigSolardemoError = true;
    sdk = 'VoxgigSolardemo';
    code;
    ctx;
    constructor(code, msg, ctx) {
        super(msg);
        this.code = code;
        this.ctx = ctx;
    }
}
exports.VoxgigSolardemoError = VoxgigSolardemoError;
//# sourceMappingURL=VoxgigSolardemoError.js.map