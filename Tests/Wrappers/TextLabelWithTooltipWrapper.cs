namespace Tests.Wrappers
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;

    public class TextLabelWithTooltipWrapper : Frame, ITextLabelWithTooltip
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new TextLabelWithTooltipWrapper(util, layout, parent);
        }

        public TextLabelWithTooltipWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "frame", layout as FrameType, parent)
        { }

        public IFontString Label
        {
            get { return (IFontString) this["Label"]; }
        }

        public string Tooltip { get; set; }
    }
}