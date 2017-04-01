

namespace GHD.IntegrationTests
{
    using GHD;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using Tests;
    using BlizzardApi.WidgetInterfaces;
    using System.Linq;

    using BlizzardApi.WidgetEnums;

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
                .WithFrameWrapper("GHM_ScrollFrameTemplate", GHM_ScrollFrameTemplateWrapper.Init)
                .Build();

            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);

            ghTestable.MouseOverMainButton();
            var initialFontStrings = session.Util.GetVisibleLayeredRegions().OfType<IFontString>().ToArray();
            ghTestable.ClickSubButton("Interface\\Icons\\INV_Misc_Book_08");

            var fontStrings = GetFontStrings(session, initialFontStrings);
            Assert.AreEqual(1, fontStrings.Length, "Expected 1 initial font string");
            Assert.AreEqual("", fontStrings.Single().GetText());

            var editBox = GlobalFrames.CurrentFocus;
            Assert.IsNotNull(editBox);
            var input = new KeyboardInputSimulator();

            input.TypeString("A");
            fontStrings = GetFontStrings(session, initialFontStrings);
            Assert.AreEqual(1, fontStrings.Length, "Expected 1 font string");
            Assert.AreEqual("A", fontStrings.Single().GetText());

            input.TypeString(" test");
            fontStrings = GetFontStrings(session, initialFontStrings);
            Assert.AreEqual(1, fontStrings.Length, "Expected 1 font string");
            Assert.AreEqual("A test", fontStrings.Single().GetText());

            input.MoveLeft(4);
            input.TypeString("short ");

            fontStrings = GetFontStrings(session, initialFontStrings);
            Assert.AreEqual(1, fontStrings.Length, "Expected 1 font string");
            Assert.AreEqual("A short test", fontStrings.Single().GetText());
        }

        private static IFontString[] GetFontStrings(ISession session, IFontString[] initialFontStrings)
        {
            return session.Util.GetVisibleLayeredRegions().OfType<IFontString>().Where(fs => !initialFontStrings.Contains(fs) && fs.GetName() != null && fs.GetName().StartsWith("FormattedTextFrame")).ToArray();
        }
    }
}
