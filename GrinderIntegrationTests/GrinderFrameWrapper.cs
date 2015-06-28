namespace GrinderIntegrationTests
{
    using BlizzardApi.WidgetInterfaces;
    using Grinder.View.Xml;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;

    public class GrinderFrameWrapper : Frame, IGrinderFrame
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new GrinderFrameWrapper(util, layout, parent);
        }

        public GrinderFrameWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "frame", layout as FrameType, parent)
        { }

        public IFontString Label
        {
            get { return (IFontString) this["Label"]; }
        }

        public IButton TrackButton
        {
            get { return (IButton)this["TrackButton"]; }
        }

        public IFrame TrackingContainer
        {
            get { return (IFrame)this["TrackingContainer"]; }
        }
    }
}