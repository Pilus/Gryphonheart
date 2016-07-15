namespace Tests.Wrappers
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects.Text;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;
    using WoWSimulator.UISimulation.XMLHandler;

    public class TextObjectFrameWrapper : Frame, ITextObjectFrame
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new TextObjectFrameWrapper(util, layout, parent);
        }

        public TextObjectFrameWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "frame", layout as FrameType, parent)
        { }

        public IFontString Label
        {
            get { return (IFontString)this["Label"]; }
        }

    }
}