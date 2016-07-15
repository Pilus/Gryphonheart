namespace GH.Menu.Objects.DropDown.CustomDropDown
{
    using System;
    using BlizzardApi.WidgetEnums;
    using CsLuaFramework.Wrapping;

    public class CustomDropDownObject : BaseObject, IMenuObjectWithValue
    {
        private const string Template = "GH_CustomDropDown_Template";

        public static string Type = "CustomDD";

        private readonly ICustomDropDownFrame frame;

        public CustomDropDownObject(IWrapper wrapper) : base(Type, FrameType.Frame, Template, wrapper)
        {
            this.frame = (ICustomDropDownFrame) this.Frame;
        }

        public object GetValue()
        {
            throw new NotImplementedException();
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.ApplyProfile((CustomDropDownProfile)profile);
        }

        public void SetValue(object value)
        {
            throw new NotImplementedException();
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