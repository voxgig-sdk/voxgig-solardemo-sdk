// VoxgigSolardemo SDK utility: prepareAuth - this SDK is built with auth
// switched off, so there is no credential to place.

namespace VoxgigSolardemoSdk.Util;

public static partial class SdkUtility
{
    // Still in the pipeline: MakeSpec calls PrepareAuth unconditionally, and
    // a missing spec is still the same error it always was.
    internal static Spec PrepareAuthUtil(Context ctx)
    {
        return ctx.Spec ?? throw ctx.MakeError("auth_no_spec",
            "Expected context spec property to be defined.");
    }
}
