

namespace GHD.IntegrationTests
{
    using GHD;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using Tests;
    using BlizzardApi.WidgetInterfaces;
    using System.Linq;
    using WoWSimulator.UISimulation;

    [TestClass]
    public class SimpleDocumentTest
    {
        [TestMethod]
        public void RenderPageWithSeveralLines()
        {
            var frameProviderMock = new MockFrameProvider();

            var session = new SessionBuilder()
                .WithGH()
                .WithAddOn(new GHDAddOn())
                .WithIgnoredXmlTemplate("GHM_ScrollFrameTemplate")
                .WithFrameWrapper("GH_EditBoxWithFilters_Template", EditBoxWithFiltersWrapper.Init)
                .Build();

            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);

            ghTestable.MouseOverMainButton();
            var initialFontStrings = session.Util.GetVisibleFrames().OfType<IFontString>().ToArray();
            ghTestable.ClickSubButton("Interface\\Icons\\INV_Misc_Book_08");

            var fontStrings1 = GetFontStrings(session, initialFontStrings);

            Assert.AreEqual(1, fontStrings1.Length, "Expected 1 initial font string");
        }

        private static IFontString[] GetFontStrings(ISession session, IFontString[] initialFontStrings)
        {
            return session.Util.GetVisibleFrames().OfType<IFontString>().Where(fs => !initialFontStrings.Contains(fs)).ToArray();
        }
    }
}
