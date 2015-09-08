namespace Tests.GHFTests.Integration
{
    using BlizzardApi.WidgetInterfaces;
    using GHF.View.CharacterMenuProfile.CharacterList;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;
    using Wrappers;

    public class CharacterListButtonWrapper : CheckButton, ICharacterListButton
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new CharacterListButtonWrapper(util, layout, parent);
        }

        public CharacterListButtonWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "checkButton", layout as CheckButtonType, parent)
        { }

        public IFontString NameLabel
        {
            get { return (IFontString) this["NameLabel"]; }
        }
    }
}