"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VoxgigSolardemoError = void 0;
class VoxgigSolardemoError extends Error {
    isVoxgigSolardemoError = true;
    sdk = 'VoxgigSolardemo';
    code;
    ctx;
    status = -1;
    // `err.notFound` rather than a magic number at every call site.
    get notFound() { return 404 === this.status; }
    constructor(code, msg, ctx) {
        super(msg);
        this.code = code;
        this.ctx = ctx;
    }
}
exports.VoxgigSolardemoError = VoxgigSolardemoError;
//# sourceMappingURL=VoxgigSolardemoError.js.map