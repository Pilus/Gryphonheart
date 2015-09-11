namespace Tests.GHFTests.Integration
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GH;
    using GHF;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using Wrappers;
    using CsLuaAttributes;

    [TestClass]
    public class GHFIntegrationTest
    {
        [TestMethod]
        public void SimpleProfileLifecycle()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithGH()
                .WithGHF()
                .Build();

            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);
            var menuTestable = new GHMenuTestable(session);

            ghTestable.MouseOverMainButton();
            ghTestable.ClickSubButton("Interface\\Icons\\Spell_Misc_EmotionHappy");
            
            menuTestable.SelectMenu("GHF_CharacterMenu");
            Assert.AreEqual("Tester", menuTestable.GetObjectValue("First Name:"));
            Assert.AreEqual("", menuTestable.GetObjectValue("Middle Name(s):"));
            Assert.AreEqual("", menuTestable.GetObjectValue("Last Name:"));

            menuTestable.SetObjectValue("First Name:", "Testperson");
            menuTestable.SetObjectValue("Middle Name(s):", "von der");
            menuTestable.SetObjectValue("Last Name:", "Testa");

            menuTestable.CloseMenu();

            var savedVars = session.GetSavedVariables();

            var session2 = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithGH()
                .WithGHF()
                .WithSavedVariables(savedVars)
                .Build();

            session2.RunStartup();

            var ghTestable2 = new GHAddOnTestable(session2);
            var menuTestable2 = new GHMenuTestable(session2);

            ghTestable2.MouseOverMainButton();
            ghTestable2.ClickSubButton("Interface\\Icons\\Spell_Misc_EmotionHappy");

            menuTestable2.SelectMenu("GHF_CharacterMenu");
            Assert.AreEqual("Testperson", menuTestable2.GetObjectValue("First Name:"));
            Assert.AreEqual("von der", menuTestable2.GetObjectValue("Middle Name(s):"));
            Assert.AreEqual("Testa", menuTestable2.GetObjectValue("Last Name:"));
        }
    }
}