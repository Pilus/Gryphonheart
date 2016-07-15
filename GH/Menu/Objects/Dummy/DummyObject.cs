
namespace GH.Menu.Objects.Dummy
{
    using CsLuaFramework.Wrapping;

    class DummyObject : BaseObject, IMenuObjectWithValue
    {
        public static string Type = "Dummy";

        public DummyObject(IWrapper wrapper) : base(Type, wrapper)
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
