"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.prepareAuth = prepareAuth;
function prepareAuth(ctx) {
    const spec = ctx.spec;
    if (null == spec) {
        return ctx.error('auth_no_spec', 'Expected context spec property to be defined.');
    }
    return spec;
}
//# sourceMappingURL=PrepareAuthUtility.js.map