namespace GH.Menu.Objects.EditField
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;

    public class EditFieldObject : BaseObject
    {
        private readonly IEditFieldFrame frame;
        private readonly EditFieldProfile profile;

        public static string Type = "EditField";

        public static EditFieldObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new EditFieldObject((EditFieldProfile)profile, parent, settings);
        }

        public EditFieldObject(EditFieldProfile profile, IMenuContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.frame = (IEditFieldFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame, "GH_EditFieldFrame_Template");
            this.Frame = this.frame;
            this.profile = profile;

            this.SetUpFromProfile();
            this.SetUpTabbableObject(this.frame.Text);
        }

        private void SetUpFromProfile()
        {
            if (this.profile.width != null)
            {
                this.frame.SetWidth((double)this.profile.width);
            }

            if (this.profile.height != null)
            {
                this.frame.SetHeight((double)this.profile.height);
            }

        }

        public override object GetValue()
        {
            return this.frame.Text.GetText();
        }

        public override void SetValue(object value)
        {
            this.frame.Text.SetText((string)value ?? "");
        }

        public override double? GetPreferredWidth()
        {
            return this.profile.width;
        }

        public override double? GetPreferredHeight()
        {
            return this.profile.height;
        }
    }
}