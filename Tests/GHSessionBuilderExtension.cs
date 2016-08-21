namespace Tests
{
    using BlizzardApi.WidgetInterfaces;
    using GH;
    using GHF;
    using System;

    using CsLuaFramework.Wrapping;

    using GH.Utils.Modules;

    using GHF.Model.MSP;
    using Moq;
    using Tests.GHFTests.Integration;
    using Tests.Wrappers;
    using WoWSimulator;

    public static class GHSessionBuilderExtension
    {
        public static SessionBuilder WithGH(this SessionBuilder sessionBuilder)
        {
            var moduleFactory = new ModuleFactory();

            return sessionBuilder.WithXmlFile(@"Objects\Button\ButtonFrame.xml")
                .WithXmlFile(@"Objects\Editbox\EditBoxFrame.xml")
                .WithXmlFile(@"Objects\TextLabelWithTooltip.xml")
                .WithXmlFile(@"Objects\EditField\EditFieldFrame.xml")
                .WithXmlFile(@"Objects\Text\TextObject.xml")
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

                    Action<IUIObject, int> PanelTemplates_SetNumTabs = GHSessionBuilderExtension.PanelTemplates_SetNumTabs;
                    session.SetGlobal("PanelTemplates_SetNumTabs", PanelTemplates_SetNumTabs);
                    session.SetGlobal("PanelTemplates_SetTab", PanelTemplates_SetNumTabs);
                })
                .WithSetActiveSessionAction(session =>
                {
                    ModuleFactory.ModuleFactorySingleton = moduleFactory;
                });
        }

        private static void PanelTemplates_SetNumTabs(IUIObject _, int i)
        {

        }

        public static SessionBuilder WithGHF(this SessionBuilder sessionBuilder)
        {
            var msp = new Mock<ILibMSPWrapper>();
            msp.Setup(m => m.GetEmptyFieldsObj()).Returns(new MspFieldsMock());
            return sessionBuilder.WithGHF(msp);
        }

        public static SessionBuilder WithGHF(this SessionBuilder sessionBuilder, Mock<ILibMSPWrapper> msp)
        {
            var wrapper = new Mock<IWrapper>();
            wrapper.Setup(w => w.Wrap<ILibMSPWrapper>("libMSPWrapper")).Returns(msp.Object);

            return sessionBuilder
                .WithXmlFile(@"View\CharacterMenuProfile\CharacterList\CharacterListButton.xml")
                .WithFrameWrapper("GHF_CharacterListButtonTemplate", CharacterListButtonWrapper.Init)
                .WithAddOn(new GHFAddOn(wrapper.Object));
        }
    }
}
