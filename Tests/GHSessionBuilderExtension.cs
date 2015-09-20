namespace Tests
{
    using BlizzardApi.WidgetInterfaces;
    using GH;
    using GHF;
    using System;
    using GHF.Model.MSP;
    using Moq;
    using Tests.GHFTests.Integration;
    using Tests.Wrappers;
    using WoWSimulator;

    public static class GHSessionBuilderExtension
    {
        public static SessionBuilder WithGH(this SessionBuilder sessionBuilder)
        {
            return sessionBuilder.WithXmlFile(@"Menu\Objects\Button\ButtonFrame.xml")
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
                .WithIgnoredXmlTemplate("UIDropDownMenuTemplate")
                .WithAddOn(new GHAddOn())
                .WithPostBuildAction(session =>
                {
                    var optionsContainer = session.FrameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.Frame, "InterfaceOptionsFramePanelContainer") as IFrame;
                    optionsContainer.SetWidth(400);
                    optionsContainer.SetHeight(500);

                    Action<INativeUIObject, int> PanelTemplates_SetNumTabs = GHSessionBuilderExtension.PanelTemplates_SetNumTabs;
                    session.SetGlobal("PanelTemplates_SetNumTabs", PanelTemplates_SetNumTabs);
                    session.SetGlobal("PanelTemplates_SetTab", PanelTemplates_SetNumTabs);
                });
        }

        private static void PanelTemplates_SetNumTabs(INativeUIObject _, int i)
        {

        }

        public static SessionBuilder WithGHF(this SessionBuilder sessionBuilder)
        {
            return sessionBuilder
                .WithXmlFile(@"View\CharacterMenuProfile\CharacterList\CharacterListButton.xml")
                .WithFrameWrapper("GHF_CharacterListButtonTemplate", CharacterListButtonWrapper.Init)
                .WithAddOn(new GHFAddOn())
                .WithPostBuildAction(s =>
                {
                    var msp = new Mock<ILibMSPWrapper>();
                    msp.Setup(m => m.GetEmptyFieldsObj()).Returns(new MspFieldsMock());
                    s.SetGlobal("libMSPWrapper", msp.Object);
                });
        }
    }
}
