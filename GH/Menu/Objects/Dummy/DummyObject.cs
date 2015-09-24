
namespace GH.Menu.Objects.Dummy
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;

    class DummyObject : BaseObject, IMenuObjectWithValue
    {
        public static string Type = "Dummy";

        public DummyObject() : base(Type)
        {
            
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var dummyProfile = (DummyProfile)profile;
            this.Frame.SetWidth(dummyProfile.width ?? 10);
            this.Frame.SetHeight(dummyProfile.height ?? 10);
            this.value = null;
        }


        private object value;
        public object GetValue()
        {
            return value;
        }

        public void SetValue(object value)
        {
            this.value = value;
        }
    }
}
