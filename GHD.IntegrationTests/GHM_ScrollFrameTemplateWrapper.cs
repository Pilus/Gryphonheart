namespace GHD.IntegrationTests
{
    using System;
    using BlizzardApi.WidgetInterfaces;

    using GH.Menu;

    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;
    using WoWSimulator.UISimulation.XMLHandler;

    public class GHM_ScrollFrameTemplateWrapper : ScrollFrame, IGHM_ScrollFrameTemplate
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new GHM_ScrollFrameTemplateWrapper(util, "ScrollFrame", (ScrollFrameType)layout, parent);
        }

        public GHM_ScrollFrameTemplateWrapper(UiInitUtil util, string objectType, ScrollFrameType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
        }

        public void ShowScrollBarBackgrounds()
        {
        }
    }
}
