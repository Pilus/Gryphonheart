namespace GrinderIntegrationTests
{
    using Grinder;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;

    [TestClass]
    public class IntegrationTests
    {
        [TestMethod]
        public void NewUser()
        {
            var session = new SessionBuilder()
                .WithAddOn(new GrinderAddOn())
                .WithXmlFile(@"View\Xml\GrinderFrame.xml")
                .WithFrameWrapper("GrinderFrame", GrinderFrameWrapper.Init)
                .Build();

            session.RunStartup();
        }
    }
}
