
namespace Tests.GHCTests.Integration
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using GHC;
    using GH;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;

    [TestClass]
    public class GHCIntegrationTest
    {
        [TestMethod]
        public void NewUser()
        {
            var session = new SessionBuilder()
                .WithAddOn(new GHAddOn())
                .WithAddOn(new GHCAddOn())
                .Build();

            var optionsContainer = Global.FrameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.Frame, "InterfaceOptionsFramePanelContainer") as IFrame;
            optionsContainer.SetWidth(400);
            optionsContainer.SetHeight(500);


            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);

            ghTestable.MouseOver();
        }
    }
}
