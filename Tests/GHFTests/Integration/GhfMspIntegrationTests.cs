namespace Tests.GHFTests.Integration
{
    using System.Collections.Generic;
    using GH;
    using GHF.Model.MSP;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using WoWSimulator;

    [TestClass]
    public class GhfMspIntegrationTests
    {
        [TestMethod]
        public void VerifyMspPublishing()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Warrior")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
                .WithGH()
                .WithGHF()
                .Build();

            var mspMock = new Mock<ILibMSPWrapper>();
            var fieldsMock = new MspFieldsMock();
            mspMock.Setup(m => m.GetEmptyFieldsObj()).Returns(fieldsMock);
            session.SetGlobal("libMSPWrapper", mspMock.Object);

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
    }
}