// VoxgigSolardemo SDK - per-call control block.

namespace VoxgigSolardemoSdk;

public class Control
{
    public bool? Throw;
    public Exception? Err;
    public Dictionary<string, object?>? Explain;
    public string Actor = "";
    public Dictionary<string, object?>? Paging;
}
