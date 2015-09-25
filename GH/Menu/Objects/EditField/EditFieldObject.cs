namespace GH.Menu.Objects.EditField
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;

    public class EditFieldObject : BaseObject, IMenuObjectWithValue
    {
        private const string Template = "GH_EditFieldFrame_Template";

        private readonly IEditFieldFrame frame;

        private double? width;
        private double? height;

        public static string Type = "EditField";

        public EditFieldObject() : base(Type, FrameType.Frame, Template)
        {
            this.frame = (IEditFieldFrame)this.Frame;
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.SetUpFromProfile((EditFieldProfile)profile);
            // this.SetUpTabbableObject(new TabableEditBox(this.frame.Text));
        }


        private void SetUpFromProfile(EditFieldProfile profile)
        {
            this.width = profile.width;
            this.height = profile.height;

            if (profile.width != null)
            {
                this.frame.SetWidth((double)profile.width);
            }

            if (profile.height != null)
            {
                this.frame.SetHeight((double)profile.height);
            }

        }

        public object GetValue()
        {
            return this.frame.Text.GetText();
        }

        public void SetValue(object value)
        {
            this.frame.Text.SetText((string)value ?? "");
        }

        public override double? GetPreferredWidth()
        {
            return this.width;
        }

        public override double? GetPreferredHeight()
        {
            return this.height;
        }
    }
}