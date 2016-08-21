namespace Tests.GHFTests.Integration
{
    using System.Collections.Generic;
    using GHF.Model.MSP;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using WoWSimulator;
    using Tests.Util;
    using System;

    using GH.Texture;

    using Lua;

    [TestClass]
    public class GhfMspIntegrationTests
    {
        [TestMethod]
        public void VerifyMspPublishing()
        {
            var mspMock = new Mock<ILibMSPWrapper>();

            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Warrior")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
                .WithGH()
                .WithGHF(mspMock)
                .Build();

            
            var fieldsMock = new MspFieldsMock();
            mspMock.Setup(m => m.GetEmptyFieldsObj()).Returns(fieldsMock);

            session.RunStartup();

            mspMock.Verify(m => m.SetMy(It.IsAny<IMSPFields>()), Times.Once);
            mspMock.Verify(m => m.SetMy(It.Is<IMSPFields>(f => f == fieldsMock)), Times.Once);
            mspMock.Verify(m => m.Update(), Times.Once);

            var expectedValues = new Dictionary<string, string>()
            {
                { "VP", "1" },
                { "VA", "GH/3.0.1" },
                { "NA", "Tester" },
                { "GC", "WARRIOR" },
                { "GR", "Human" },
                { "GS", "2" },
                { "GU", "g1" },
                { "DE", null },
            };

            Assert.AreEqual(expectedValues.Count, fieldsMock.Count);

            foreach (var expected in expectedValues)
            {
                Assert.IsTrue(fieldsMock.ContainsKey(expected.Key));
                Assert.AreEqual(expected.Value, fieldsMock[expected.Key]);
            }


            var ghTestable = new GHAddOnTestable(session);
            var menuTestable = new GHMenuTestable(session);

            ghTestable.MouseOverMainButton();
            ghTestable.ClickSubButton("Interface\\Icons\\Spell_Misc_EmotionHappy");

            menuTestable.SelectMenu("GHF_CharacterMenu");

            menuTestable.SetObjectValue("First Name:", "Testperson");
            menuTestable.SetObjectValue("Middle Name(s):", "von der");
            menuTestable.SetObjectValue("Last Name:", "Testa");
            menuTestable.SetObjectValue("Appearance:", "Looks");
            menuTestable.SetObjectValue("Background:", "Background story.");

            menuTestable.CloseMenu();

            expectedValues["NA"] = "Testperson von der Testa";
            expectedValues["DE"] = "Looks";

            Assert.AreEqual(expectedValues.Count, fieldsMock.Count);

            foreach (var expected in expectedValues)
            {
                Assert.IsTrue(fieldsMock.ContainsKey(expected.Key));
                Assert.AreEqual(expected.Value, fieldsMock[expected.Key]);
            }
        }

        [TestMethod]
        public void VerifyMspTargetingDisplay()
        {
            var mspMock = new Mock<ILibMSPWrapper>();

            var targetMock = new TargetingMock();
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Warrior")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
                .WithGH()
                .WithGHF(mspMock)
                .WithApiMock(targetMock)
                .Build();

            var otherMspUser = "Othermsp";

            
            var fieldsMock = new MspFieldsMock();
            MspFieldsMock otherMspFields = null;
            Action<string> updateAction = null;
            mspMock.Setup(m => m.GetEmptyFieldsObj()).Returns(fieldsMock);
            mspMock.Setup(m => m.GetOther(otherMspUser)).Returns(() => otherMspFields);
            mspMock.Setup(m => m.HasOther(otherMspUser)).Returns(() => otherMspFields != null);
            mspMock.Setup(m => m.AddReceivedAction(It.IsAny<Action<string>>()))
                .Callback<Action<string>>((a) => { updateAction = a; });
            mspMock.Setup(m => m.Request(otherMspUser, It.IsAny<NativeLuaTable>()));

            session.RunStartup();

            mspMock.Verify(m => m.AddReceivedAction(It.IsAny<Action<string>>()), Times.Once(), "Received callback for msp should have been set up");

            Assert.IsFalse(session.Actor.IsVisible(TextureResources.GhRoundTarget));

            // Target the player
            targetMock.TargetPlayer(otherMspUser, session);

            Assert.IsFalse(session.Actor.IsVisible(TextureResources.GhRoundTarget));
            mspMock.Verify(m => m.Request(otherMspUser, It.IsAny<NativeLuaTable>()), Times.Once());
            mspMock.Verify(m => m.HasOther(otherMspUser), Times.Exactly(1));

            // Mock receiving the data
            otherMspFields = new MspFieldsMock()
            {
                { "NA", "Other Person" },
            };
            updateAction(otherMspUser);

            mspMock.Verify(m => m.HasOther(otherMspUser), Times.Exactly(2));
            session.Actor.VerifyVisible(TextureResources.GhRoundTarget);

            // Clear the target
            targetMock.ClearTarget(session);

            Assert.IsFalse(session.Actor.IsVisible(TextureResources.GhRoundTarget));

            // Retarget the player
            targetMock.TargetPlayer(otherMspUser, session);

            mspMock.Verify(m => m.HasOther(otherMspUser), Times.Exactly(3));
            mspMock.Verify(m => m.Request(otherMspUser, It.IsAny<NativeLuaTable>()), Times.Exactly(2));
            session.Actor.VerifyVisible(TextureResources.GhRoundTarget);

            // TODO: Click the icon and verify the details menu
        }
    }
}