namespace GH.Menu.Objects.DropDown.CustomDropDown
{
    using BlizzardApi.WidgetInterfaces;

    public interface ICustomDropDownFrame : IFrame
    {
        IFontString Label { get; }
        IFontString SelectedText { get; }

        IFrame DropDownMenu { get; }

        ITexture MiddleDropDownTexture { get; }
    }
}