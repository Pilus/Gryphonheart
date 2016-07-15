
namespace GHF.View.CharacterMenuProfile.CharacterList
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GH.Misc;
    using GHF.Model;
    using System;
    using System.Collections.Generic;

    public class CharacterListButtonHandler
    {
        public const double Height = 60;
        public const double Width = 120;

        private static Dictionary<string, string> classIcons = new Dictionary<string, string>()
        {
            { "DEATHKNIGHT", "Interface\\Icons\\Spell_Deathknight_ClassIcon"},
            { "DRUID", "Interface\\Icons\\INV_Misc_MonsterClaw_04"},
            { "WARLOCK", "Interface\\Icons\\Spell_Nature_FaerieFire"},
            { "HUNTER", "Interface\\Icons\\INV_Weapon_Bow_07"},
            { "MAGE", "Interface\\Icons\\INV_Staff_13"},
            { "PRIEST", "Interface\\Icons\\INV_Staff_30"},
            { "WARRIOR", "Interface\\Icons\\INV_Sword_27"},
            { "SHAMAN", "Interface\\Icons\\Spell_Nature_BloodLust"},
            { "PALADIN", ""}, // TODO: find missing Paladin and Rogue icon paths or provide texture.
            { "ROGUE", ""},

        };
        private const string Template = "GHF_CharacterListButtonTemplate";

        public ICharacterListButton Button;

        private Action onClickAction;
        private Profile profile;
        private ProfileFormatter formatter;

        public CharacterListButtonHandler(IFrame parent, ProfileFormatter formatter)
        {
            this.Button = (ICharacterListButton)Global.FrameProvider.CreateFrame(FrameType.CheckButton, Misc.GetUniqueGlobalName(parent.GetName() + "Button"), parent, Template);
            this.Button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.Button.SetWidth(Width);
            this.Button.SetHeight(Height);
            this.formatter = formatter;
        }

        public void Display(Profile profile)
        {
            this.profile = profile;
            this.Button.NameLabel.SetText(this.formatter.GetFullName(profile));
            this.Button.Icon.SetTexture(classIcons[profile.GameClass]);
        }

        public void SetClick(Action action)
        {
            this.onClickAction = action;
        }

        private void OnClick(IUIObject obj, object arg1, object arg2)
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
