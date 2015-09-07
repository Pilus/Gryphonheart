
namespace GHF.View.CharacterMenuProfile.CharacterList
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GH.Misc;
    using GHF.Model;
    using System;

    public class CharacterListButtonHandler
    {
        public const double Height = 60;
        public const double Width = 120;

        private const string Template = "GHF_CharacterListButtonTemplate";

        public ICharacterListButton Button;

        private Action onClickAction;
        private Profile profile;

        public CharacterListButtonHandler(IFrame parent)
        {
            this.Button = (ICharacterListButton)Global.FrameProvider.CreateFrame(FrameType.CheckButton, Misc.GetUniqueGlobalName(parent.GetName() + "Button"), parent, Template);
            this.Button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.Button.SetWidth(Width);
            this.Button.SetHeight(Height);
        }

        public void Display(Profile profile)
        {
            this.Button.NameLabel.SetText(profile.FirstName + " " + profile.LastName);
        }

        public void SetClick(Action action)
        {
            this.onClickAction = action;
        }

        private void OnClick(INativeUIObject obj, object arg1, object arg2)
        {
            if (this.onClickAction != null)
            {
                this.onClickAction();
            }
        }

        public string CurrentId()
        {
            return this.profile.Id;
        }

        public void Highlight(bool highlightOn)
        {
            this.Button.SetChecked(highlightOn);
        }
    }
}
