// Solardemo SDK exists test.

using Xunit;

using SolardemoSdk;

namespace SolardemoSdk.Test;

public class ExistsTest
{
    [Fact]
    public void TestMode()
    {
        var testsdk = SolardemoSDK.TestSDK(null, null);
        Assert.NotNull(testsdk);
    }
}
