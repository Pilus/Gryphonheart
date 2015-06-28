namespace GrinderIntegrationTests
{
    using BlizzardApi.WidgetInterfaces;
    using Grinder.View;
    using Grinder.View.Xml;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;

    public class GrinderTrackingRowWrapper : Frame, IGrinderTrackingRow
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new GrinderTrackingRowWrapper(util, layout, parent);
        }

        public GrinderTrackingRowWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "frame", layout as FrameType, parent)
        { }

        public ITexture IconTexture
        {
            get { return (ITexture)this["IconTexture"]; }
        }

        public IFontString Name
        {
            get { return (IFontString)this["Name"]; }
        }

        public IFontString Amount
        {
            get { return (IFontString)this["Amount"]; }
        }

        public IFontString Velocity
        {
            get { return (IFontString)this["Velocity"]; }
        }

        public IButton ResetButton
        {
            get { return (IButton)this["ResetButton"]; }
        }

        public IButton RemoveButton
        {
            get { return (IButton)this["RemoveButton"]; }
        }

        public IEntityId Id { get; set; }
    }
}