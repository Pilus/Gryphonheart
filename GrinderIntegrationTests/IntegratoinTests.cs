namespace GrinderIntegrationTests
{
    using Grinder;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;

    [TestClass]
    public class IntegratoinTests
    {
        [TestMethod]
        public void NewUser()
        {
            var session = new SessionBuilder()
                .WithAddOn(new GrinderAddOn())
                .Build();

            session.RunStartup();
        }
    }
}
