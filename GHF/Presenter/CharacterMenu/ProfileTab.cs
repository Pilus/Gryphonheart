

namespace GHF.Presenter.CharacterMenu
{
    using System;
    using CsLua;
    using CsLua.Collection;
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Page;
    using GH.Menu.Objects.Panel;
    using GHF.View;
    using Lua;
    using Model;
    using Model.AdditionalFields;
    using View.CharacterMenuProfile;

    public class ProfileTab : ICharacterMenuTab
    {
        private readonly ProfileTabProfileGenerator profileGenerator;
        private readonly SupportedFields supportedFields;
        private Profile currentProfile;
        private IMenu loadedMenu;
        private readonly CsLuaList<string> shownAdditionalFields = new CsLuaList<string>();

        public ProfileTab(SupportedFields supportedFields)
        {
            this.supportedFields = supportedFields;
            this.profileGenerator = new ProfileTabProfileGenerator();
        }

        public PageProfile GetGeneratedProfile()
        {
            return this.profileGenerator.GenerateProfile(this.UpdateValue, this.GetAvailableAdditionalFieldActions);
        }

        private void UpdateValue(string key, object obj)
        {
            if (this.currentProfile == null)
            {
                throw new CsException("No profile data loaded.");
            }

            switch (key)
            {            
                case ProfileTabLabels.FirstName:
                    this.currentProfile.FirstName = (string) obj;
                    break;
                case ProfileTabLabels.MiddleNames:
                    this.currentProfile.MiddleNames = (string) obj;
                    break;
                case ProfileTabLabels.LastName:
                    this.currentProfile.LastName = (string) obj;
                    break;
                case ProfileTabLabels.Appearance:
                    this.currentProfile.Appearance = (string) obj;
                    break;
                default:
                    throw new CsException("Unknown menu label key " + key);
            }
        }

        public void Load(IMenu menu, Profile profile)
        {
            this.loadedMenu = menu;
            this.currentProfile = profile;
            menu.SetValue(ProfileTabLabels.FirstName, profile.FirstName);
            menu.SetValue(ProfileTabLabels.MiddleNames, profile.MiddleNames);
            menu.SetValue(ProfileTabLabels.LastName, profile.LastName);
            menu.SetValue(ProfileTabLabels.Appearance, profile.Appearance);

            foreach (var additionalField in profile.AdditionalFields)
            {
                this.AddAdditionalField(additionalField.Key, additionalField.Value);
            }
        }

        private void AddAdditionalField(string key, string value)
        {
            var fieldMeta = this.supportedFields.Fields.FirstOrDefault(f => f.Id.Equals(key));
            if (fieldMeta != null)
            {
                var panel = (PanelObject)this.loadedMenu.GetFrameById(ProfileTabLabels.AdditionalFieldsPanel);
                
                var lastLineIndex = panel.GetNumLines();
                var numObjects = panel.GetNumObjects(lastLineIndex);
                if (numObjects < 2)
                {
                    var profile = fieldMeta.GenerateProfile(numObjects == 0 ? ObjectAlign.l : ObjectAlign.r);
                    panel.AddElement(lastLineIndex, profile);
                }
                else
                {
                    var profile = fieldMeta.GenerateProfile(ObjectAlign.l);
                    panel.AddElement(lastLineIndex, profile);
                }
                var obj = panel.GetFrameById(fieldMeta.Id);
                obj.SetValue(value);
                this.shownAdditionalFields.Add(key);
            }
        }

        private CsLuaDictionary<IField, Action> GetAvailableAdditionalFieldActions()
        {
            var fields = this.supportedFields.Fields.Where(field => !this.shownAdditionalFields.Contains(field.Id));
            var fieldActions = new CsLuaDictionary<IField, Action>();

            fields.Foreach(field =>
            {
                fieldActions[field] = () => { this.AddAdditionalField(field.Id, string.Empty); };
            });

            return fieldActions;
        }

        public void Save()
        {
            this.currentProfile.Appearance = this.loadedMenu.GetValue(ProfileTabLabels.Appearance) as string;

            this.shownAdditionalFields.Foreach(additionalFieldId =>
            {
                var value = this.loadedMenu.GetValue(additionalFieldId) as string;
                this.currentProfile.AdditionalFields[additionalFieldId] = value;
            });
        }
    }
}
