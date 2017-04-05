

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
        private IFontString[] initialFontStrings;

        private ISession session;

        [TestMethod]
        public void RenderPageWithSeveralLines()
        {
            this.session = new SessionBuilder()
                .WithGH()
                .WithAddOn(new GHDAddOn())
                .WithIgnoredXmlTemplate("GHM_ScrollFrameTemplate")
                .WithFrameWrapper("GHM_ScrollFrameTemplate", GHM_ScrollFrameTemplateWrapper.Init)
                .Build();

            this.session.RunStartup();

            var ghTestable = new GHAddOnTestable(this.session);

            ghTestable.MouseOverMainButton();
            this.initialFontStrings = this.session.Util.GetVisibleLayeredRegions().OfType<IFontString>().ToArray();
            ghTestable.ClickSubButton("Interface\\Icons\\INV_Misc_Book_08");

            this.ExpectStrings("");

            var editBox = GlobalFrames.CurrentFocus;
            Assert.IsNotNull(editBox);

            var input = new KeyboardInputSimulator();

            input.TypeString("A");
            this.ExpectStrings("A");

            input.TypeString(" test");
            this.ExpectStrings("A test");

            input.PressLeftArrow(4);
            input.TypeString("short ");
            this.ExpectStrings("A short test");

            input.PressEnd();
            input.TypeString(". Adding a long sentance with the purpose of spilling over into the next line of text.");
            this.ExpectStrings("A short test. Adding a long sentance with the purpose of spilling", "over into the next line of text.");

            input.PressUpArrow();
            input.TypeString("1");
            this.ExpectStrings("A short test. Adding a long1 sentance with the purpose of", "spilling over into the next line of text.");
        }

        private void ExpectStrings(params string[] strings)
        {
            var fontStrings = GetFontStrings(this.session, this.initialFontStrings);
            Assert.AreEqual(strings.Length, fontStrings.Length, "Unexpected amount of font strings currently visible. Got:" + string.Join("", fontStrings.Select((fs,i) =>"\n" + i + ": "+ fs.GetText())));

            for (int i = 0; i < strings.Length; i++)
            {
                Assert.AreEqual(strings[i], fontStrings[i].GetText(), "String " + (i + 1));
            }
        }

        private static IFontString[] GetFontStrings(ISession session, IFontString[] initialFontStrings)
        {
            return session.Util.GetVisibleLayeredRegions().OfType<IFontString>().Where(fs => !initialFontStrings.Contains(fs) && fs.GetName() != null && fs.GetName().StartsWith("FormattedTextFrame")).ToArray();
        }
    }
}
