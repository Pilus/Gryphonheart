namespace Tests.Wrappers
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects;
    using GH.Menu.Objects.EditField;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;

    public class EditFieldFrameWrapper : Frame, IEditFieldFrame
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new EditFieldFrameWrapper(util, layout, parent);
        }

        public EditFieldFrameWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "frame", layout as FrameType, parent)
        { }

        public IEditBox Text
        {
            get { return (IEditBox) ((IUIObject)this["Scroll"])["Text"]; }
        }
    }
}