namespace GH.Menu.Objects.EditField
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;

    public class EditFieldObject : BaseObject
    {
        private readonly IEditFieldFrame frame;
        private readonly EditFieldProfile profile;

        public EditFieldObject(EditFieldProfile profile, IMenuContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.frame = (IEditFieldFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame, "GH_EditBoxFrame_Template");
            this.Frame = this.frame;
            this.profile = profile;

            this.SetUpFromProfile();
        }

        public static EditFieldObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new EditFieldObject((EditFieldProfile)profile, parent, settings);
        }

        public static string Type = "EditField";

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

            
            //this.SetUpTabbableObject(this.frame.Box);
        }

        public override object GetValue()
        {
            throw new System.NotImplementedException();
            //return this.frame.Box.GetText();
        }

        public override void Force(object value)
        {
            throw new System.NotImplementedException();
            //this.frame.Box.SetText((string)value ?? "");
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