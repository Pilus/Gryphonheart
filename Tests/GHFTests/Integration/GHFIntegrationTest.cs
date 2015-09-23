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
    using GHF.Model;
    using GHF.Model.MSP;
    using Lua;
    using Moq;
    using CsLuaTestUtils;

    [TestClass]
    public class GHFIntegrationTest
    {
        [TestMethod]
        public void SimpleProfileLifecycle()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Druid")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
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
            Assert.AreEqual("", menuTestable.GetObjectValue("Background:"));

            menuTestable.SetObjectValue("First Name:", "Testperson");
            menuTestable.SetObjectValue("Middle Name(s):", "von der");
            menuTestable.SetObjectValue("Last Name:", "Testa");
            menuTestable.SetObjectValue("Appearance:", "Looks");
            menuTestable.SetObjectValue("Background:", "Background story.");

            menuTestable.CloseMenu();

            var savedVars = session.GetSavedVariables();

            var session2 = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Druid")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
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
            Assert.AreEqual("Looks", menuTestable2.GetObjectValue("Appearance:"));
            Assert.AreEqual("Background story.", menuTestable2.GetObjectValue("Background:"));
        }

        [TestMethod]
        public void MultiCharProfileLifecycle()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Mage")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
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
                .WithPlayerName("Pilus")
                .WithPlayerClass("Warrior")
                .WithPlayerGuid("g2")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
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
            Assert.AreEqual("Pilus", menuTestable2.GetObjectValue("First Name:"));
            Assert.AreEqual("", menuTestable2.GetObjectValue("Middle Name(s):"));
            Assert.AreEqual("", menuTestable2.GetObjectValue("Last Name:"));

            session2.Actor.Click("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
            session2.Actor.VerifyVisible("Testperson von der Testa");
            session2.Actor.VerifyVisible("Interface\\Icons\\INV_Staff_13"); // Mage
            session2.Actor.VerifyVisible("Pilus");
            session2.Actor.VerifyVisible("Interface\\Icons\\INV_Sword_27"); // Warrior
        }


        [TestMethod]
        public void ProfileWithAdditionalFieldsTest()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithPlayerClass("Priest")
                .WithPlayerGuid("g1")
                .WithPlayerRace("Human")
                .WithPlayerSex(2)
                .WithGH()
                .WithGHF()
                .Build();

            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);
            var menuTestable = new GHMenuTestable(session);

            ghTestable.MouseOverMainButton();
            ghTestable.ClickSubButton("Interface\\Icons\\Spell_Misc_EmotionHappy");

            menuTestable.SelectMenu("GHF_CharacterMenu");

            session.Actor.Click("Add Additional Fields");
            session.Actor.Click("Title");

            menuTestable.VerifyLabelVisible("Title:");
            menuTestable.SetObjectValue("Title:", "Cleric");

            session.Actor.Click("Add Additional Fields");
            session.Actor.Click("Age");

            menuTestable.VerifyLabelVisible("Age:");
            menuTestable.SetObjectValue("Age:", "52");

            menuTestable.CloseMenu();

            var savedVars = session.GetSavedVariables();

            var savedProfiles = (NativeLuaTable)savedVars[ModelProvider.SavedAccountProfiles];
            var additionalFields = TestUtil.GetTableValue<NativeLuaTable>(savedProfiles, "Tester", "AdditionalFields");
            Assert.AreEqual("Cleric", additionalFields["title"]);
            Assert.AreEqual("52", additionalFields["age"]);
        }
    }
}