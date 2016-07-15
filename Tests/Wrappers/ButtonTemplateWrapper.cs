namespace Tests.Wrappers
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects.Button;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;
    using WoWSimulator.UISimulation.XMLHandler;

    public class ButtonTemplateWrapper : Button, IButtonTemplate
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new ButtonTemplateWrapper(util, layout, parent);
        }

        public ButtonTemplateWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "button", layout as ButtonType, parent)
        { }

        public IFontString Text
        {
            get { return (IFontString)this["Text"]; }
        }
    }
}