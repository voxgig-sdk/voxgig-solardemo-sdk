// SolardemoError - the SDK error type. Carries the pipeline error code,
// the originating context and cleaned result/spec snapshots.

namespace SolardemoSdk;

public class SolardemoError : Exception
{
    public bool IsSolardemoError = true;
    public string Sdk = "Solardemo";
    public string Code;
    public Context? Ctx;
    public object? ResultVal;
    public object? SpecVal;

    public SolardemoError(string code, string msg, Context? ctx)
        : base(msg)
    {
        Code = code;
        Ctx = ctx;
    }
}
