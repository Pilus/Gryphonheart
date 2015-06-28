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
                .WithIgnoredXmlTemplate("UIDropDownMenuTemplate")
                .WithXmlFile(@"View\Xml\GrinderFrame.xml")
                .WithFrameWrapper("GrinderFrame", GrinderFrameWrapper.Init)
                .WithXmlFile(@"View\Xml\GrinderTrackingRow.xml")
                .WithFrameWrapper("GrinderTrackingRowTemplate", GrinderTrackingRowWrapper.Init)
                .WithApiMock(new CurrencySystem())
                .Build();

            session.RunStartup();

            session.RunUpdate();

            session.FrameProvider.Click("Track");
            session.FrameProvider.Click("Currencies");
            session.FrameProvider.Click("CurrencyName80");
        }
    }
}
