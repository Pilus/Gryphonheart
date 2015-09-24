namespace GH.Menu.Objects.DropDown.CustomDropDown
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Line;
    using Panel;

    public class CustomDropDownObject : BaseObject
    {
        private readonly CustomDropDownProfile profile;
        private readonly ICustomDropDownFrame frame;

        public CustomDropDownObject(CustomDropDownProfile profile, IObjectContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.profile = profile;

            this.frame = (ICustomDropDownFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame, "GH_CustomDropDown_Template");
            this.Frame = this.frame;
            this.SetUp();
        }

        public static CustomDropDownObject Initialize(IObjectProfile profile, IObjectContainer parent, LayoutSettings settings)
        {
            return new CustomDropDownObject((CustomDropDownProfile)profile, parent, settings);
        }

        public static string Type = "CustomDD";

        private void SetUp()
        {
            this.UpdateDimensions();
        }

        private void UpdateDimensions()
        {
            if (this.profile.width != null)
            {
                this.frame.DropDownMenu.SetWidth((double) this.profile.width);
                this.frame.SetWidth((double)this.profile.width + 6);
                this.frame.MiddleDropDownTexture.SetWidth((double)this.profile.width - 40);
            }
            else
            {
                this.frame.DropDownMenu.SetWidth(120);
                this.frame.SetWidth(126);
            }
            this.frame.SetHeight(this.frame.DropDownMenu.GetHeight() + this.frame.Label.GetHeight() + 5);
        }

        public override object GetValue()
        {
            throw new System.NotImplementedException();
        }

        public override void SetValue(object value)
        {
            throw new System.NotImplementedException();
        }
    }
}