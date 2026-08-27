// Solardemo SDK - core contracts.

namespace SolardemoSdk;

// The minimal entity contract the pipeline depends on (list-wrapping in
// MakeResult, feature hooks). Concrete entity classes derive from
// SolardemoEntityBase which implements this.
public interface IEntity
{
    string GetName();
    IEntity Make();
    object? Data(object? data = null);
    object? Match(object? match = null);

    // Every operation resolves to the entity; Remove additionally marks it.
    // The instance keeps the data it held - a caller can still read what was
    // deleted - but it is no longer a live record.
    void MarkDeleted();
    bool Deleted();
}

// Transport function: performs the HTTP (or mock) request. Returns a
// transport-shaped response map:
//   { status, statusText, headers, json: Func<object?>, body }
// Throws (typically SolardemoError) on transport-level failure - the C#
// twin of go's (any, error) return.
public delegate object? FetcherFunc(Context ctx, string fullurl, Dictionary<string, object?> fetchdef);
