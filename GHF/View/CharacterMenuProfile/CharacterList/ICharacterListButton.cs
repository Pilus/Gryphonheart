
namespace GHF.View.CharacterMenuProfile.CharacterList
{
    using BlizzardApi.WidgetInterfaces;

    public interface ICharacterListButton : ICheckButton
    {
        IFontString NameLabel { get; }
        ITexture Icon { get; }
    }
}
