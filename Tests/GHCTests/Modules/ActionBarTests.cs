﻿
namespace Tests.GHCTests
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GHC.Modules.AbilityActionBar;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;
    using System.Collections.Generic;

    [TestClass]
    public class ActionBarTests
    {
        [TestMethod]
        public void ActionBarWithSingleAction()
        {
            new MockGlobal();

            var frameProviderMock = new Mock<IFrameProvider>();
            Global.FrameProvider = frameProviderMock.Object;

            var framesMock = new Mock<IFrames>();

            var uiParent = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, "UIParent");
            framesMock.Setup(frames => frames.UIParent).Returns(uiParent);
            Global.Frames = framesMock.Object;

            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Button, null, Global.Frames.UIParent))
                .Returns(new Mock<IButton>().Object);


            var actionButtonMocks = new List<Mock<IActionButtonProxy>>();

            var actionBar = new ActionBar((parent) =>
            {
                var actionButtonMock = new Mock<IActionButtonProxy>();
                actionButtonMocks.Add(actionButtonMock);
                return actionButtonMock.Object;
            });

            var id1 = "id1";
            var icon1 = "icon1";
            Action<string> click1 = (id) => { };
            Action<string, IGameTooltip> tooltip1 = (id, TT) => { };
            actionBar.AddButton(id1, icon1, click1, tooltip1);

            Assert.AreEqual(1, actionButtonMocks.Count);
            var mock1 = actionButtonMocks[0];

            mock1.VerifySet(b => b.Id = id1);
            mock1.Verify(b => b.SetIcon(icon1), Times.Once());
            mock1.Verify(b => b.SetOnClick(click1), Times.Once());
            mock1.Verify(b => b.SetTooltipFunc(tooltip1), Times.Once());
        }
    }
}
