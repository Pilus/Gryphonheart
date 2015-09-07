namespace Tests.GHFTests.Integration
{
    using System;
    using System.Runtime.InteropServices;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using GH;
    using GHCTests.Integration;
    using GHF;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using WoWSimulator;
    using Wrappers;

    [TestClass]
    public class GHFIntegrationTest
    {
        [TestMethod]
        public void UpdateProfile()
        {
            var session = new SessionBuilder()
                .WithPlayerName("Tester")
                .WithXmlFile(@"Menu\Objects\Button\ButtonFrame.xml")
                .WithXmlFile(@"Menu\Objects\Editbox\EditBoxFrame.xml")
                .WithXmlFile(@"Menu\Objects\TextLabelWithTooltip.xml")
                .WithXmlFile(@"Menu\Objects\EditField\EditFieldFrame.xml")
                .WithXmlFile(@"Menu\Objects\Text\TextObject.xml")
                .WithXmlFile(@"Xml\UIPanelScrollFrame.xml")
                .WithFrameWrapper("GH_EditBoxWithFilters_Template", EditBoxWithFiltersWrapper.Init)
                .WithFrameWrapper("GH_TextLabel_Template", TextLabelWithTooltipWrapper.Init)
                .WithFrameWrapper("GH_Button_Template", ButtonTemplateWrapper.Init)
                .WithFrameWrapper("GH_EditFieldFrame_Template", EditFieldFrameWrapper.Init)
                .WithFrameWrapper("GH_TextObject_Template", TextObjectFrameWrapper.Init)
                .WithIgnoredXmlTemplate("SystemFont_Med2")
                .WithIgnoredXmlTemplate("UIPanelCloseButton")
                .WithIgnoredXmlTemplate("CharacterFrameTabButtonTemplate")
                .WithIgnoredXmlTemplate("UIPanelButtonUpTexture")
                .WithIgnoredXmlTemplate("UIPanelButtonDownTexture")
                .WithIgnoredXmlTemplate("UIPanelButtonDisabledTexture")
                .WithIgnoredXmlTemplate("UIPanelButtonHighlightTexture")
                .WithIgnoredXmlTemplate("UIPanelScrollBarButton")
                .WithXmlFile(@"View\CharacterMenuProfile\CharacterList\CharacterListButton.xml")
                .WithFrameWrapper("GHF_CharacterListButtonTemplate", CharacterListButtonWrapper.Init)
                .WithAddOn(new GHAddOn())
                .WithAddOn(new GHFAddOn())
                .Build();

            var optionsContainer = session.FrameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.Frame, "InterfaceOptionsFramePanelContainer") as IFrame;
            optionsContainer.SetWidth(400);
            optionsContainer.SetHeight(500);

            Action<INativeUIObject, int> PanelTemplates_SetNumTabs = this.PanelTemplates_SetNumTabs;
            session.SetGlobal("PanelTemplates_SetNumTabs", PanelTemplates_SetNumTabs);
            session.SetGlobal("PanelTemplates_SetTab", PanelTemplates_SetNumTabs);
            
            session.RunStartup();

            var ghTestable = new GHAddOnTestable(session);

            ghTestable.MouseOverMainButton();
            ghTestable.ClickSubButton("Interface\\Icons\\Spell_Misc_EmotionHappy");

            
        }

        private void PanelTemplates_SetNumTabs(INativeUIObject _, int i)
        {
            
        }
    }
}