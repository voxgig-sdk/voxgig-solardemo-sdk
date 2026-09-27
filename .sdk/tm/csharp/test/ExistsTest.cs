// VoxgigSolardemo SDK exists test.

using Xunit;

using VoxgigSolardemoSdk;

namespace VoxgigSolardemoSdk.Test;

public class ExistsTest
{
    [Fact]
    public void TestMode()
    {
        var testsdk = VoxgigSolardemoSDK.TestSDK(null, null);
        Assert.NotNull(testsdk);
    }
}
