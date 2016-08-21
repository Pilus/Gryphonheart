
namespace GH.IntegrationTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Tests;

    using WoWSimulator;

    [TestClass]
    public class QuickButtonUsageTests
    {
        [TestMethod]
        public void QuickButtonUsageOverMultipleSessions()
        {
            var session = new SessionBuilder()
                .WithGH()
                .Build();
        }
    }
}
