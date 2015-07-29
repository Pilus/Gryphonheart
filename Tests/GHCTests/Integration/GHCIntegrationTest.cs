
namespace Tests.GHCTests.Integration
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using GHC;

    [TestClass]
    public class GHCIntegrationTest
    {
        [TestMethod]
        public void NewUser()
        {
            var session = new SessionBuilder()
                .WithAddOn(new GHCAddOn())
                .Build();

            session.RunStartup();
        }
    }
}
