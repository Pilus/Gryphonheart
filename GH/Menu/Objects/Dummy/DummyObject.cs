
namespace GH.Menu.Objects.Dummy
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;

    class DummyObject : BaseObject
    {
        public DummyObject(DummyProfile profile, IMenuContainer parent, LayoutSettings settings) : base(profile, parent, settings)
        {
            this.Frame = (IFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame);
            this.Frame.SetWidth(profile.width ?? 10);
            this.Frame.SetHeight(profile.height ?? 10);
            DebugTools.Msg("Dummy", profile.label, this.Frame.GetName(), this.Frame.GetWidth());
            DebugTools.FrameBg(this.Frame);
        }

        public static DummyObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new DummyObject((DummyProfile)profile, parent, settings);
        }

        public static string Type = "Dummy";

        private object value;
        public override object GetValue()
        {
            return value;
        }

        public override void SetValue(object value)
        {
            this.value = value;
        }

        public override void SetPosition(double xOff, double yOff, double width, double height)
        {
            DebugTools.Msg("SetPosition", this.Frame.GetName(), yOff, height);
            base.SetPosition(xOff, yOff, width, height);
        }
    }
}
