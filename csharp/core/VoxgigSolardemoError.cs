// VoxgigSolardemoError - the SDK error type. Carries the pipeline error code,
// the originating context and cleaned result/spec snapshots.

namespace VoxgigSolardemoSdk;

public class VoxgigSolardemoError : Exception
{
    public bool IsVoxgigSolardemoError = true;
    public string Sdk = "VoxgigSolardemo";
    public string Code;
    public Context? Ctx;
    public object? ResultVal;
    public object? SpecVal;

    public VoxgigSolardemoError(string code, string msg, Context? ctx)
        : base(msg)
    {
        Code = code;
        Ctx = ctx;
    }
}
