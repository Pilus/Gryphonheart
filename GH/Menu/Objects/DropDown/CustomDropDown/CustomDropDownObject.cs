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
        private const string Template = "GH_CustomDropDown_Template";

        public static string Type = "CustomDD";

        private readonly ICustomDropDownFrame frame;

        public CustomDropDownObject() : base(Type, FrameType.Frame, Template)
        {
            this.frame = (ICustomDropDownFrame) this.Frame;
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.ApplyProfile((CustomDropDownProfile)profile);
        }

        private void ApplyProfile(CustomDropDownProfile profile)
        {
            if (profile.width != null)
            {
                this.frame.DropDownMenu.SetWidth((double) profile.width);
                this.frame.SetWidth((double)profile.width + 6);
                this.frame.MiddleDropDownTexture.SetWidth((double)profile.width - 40);
            }
            else
            {
                this.frame.DropDownMenu.SetWidth(120);
                this.frame.SetWidth(126);
            }
            this.frame.SetHeight(this.frame.DropDownMenu.GetHeight() + this.frame.Label.GetHeight() + 5);
        }
    }
}