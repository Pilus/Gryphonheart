
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
            UiDebugTools.FrameBg(this.Frame);
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
    }
}
