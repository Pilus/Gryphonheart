namespace GH.Menu.Objects.DropDown.ButtonWithDropDown
{
    using Button;

    public class ButtonWithDropDownObject : ButtonObject
    {
        public new static string Type = "ButtonWithDropDown";
        public new static ButtonWithDropDownObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new ButtonWithDropDownObject((ButtonWithDropDownProfile)profile, parent, settings);
        }

        public ButtonWithDropDownObject(ButtonProfile profile, IMenuContainer parent, LayoutSettings settings) : base(profile, parent, settings)
        {
            
        }
    }
}