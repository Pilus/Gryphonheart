
namespace Tests.GHCTests.Integration
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using GHC;
    using GH;
    using BlizzardApi.WidgetInterfaces;

    [TestClass]
    public class GHCIntegrationTest
    {
        [Ignore]
        [TestMethod]
        public void NewUser()
        {
            var session = new SessionBuilder()
                .WithAddOn(new GHAddOn())
                .WithAddOn(new GHCAddOn())
                .WithXmlFile(@"GHCTests\Integration\ActionButtonTemplate.xml")
                .WithXmlFile(@"GHCTests\Integration\Cooldown.xml")
                .WithIgnoredXmlTemplate("NumberFontNormalSmallGray")
                .WithIgnoredXmlTemplate("NumberFontNormal")
                .WithIgnoredXmlTemplate("GameFontHighlightSmallOutline")
                .Build();

            var optionsContainer = session.FrameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.Frame, "InterfaceOptionsFramePanelContainer") as IFrame;
            optionsContainer.SetWidth(400);
            optionsContainer.SetHeight(500);


            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);

            ghTestable.MouseOverMainButton();
            ghTestable.ClickSubButton("Interface/ICONS/Ability_Stealth");

            session.Actor.VerifyVisible("Interface/ICONS/INV_Misc_Bag_11", true);
        }
    }
}
