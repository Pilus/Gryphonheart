

namespace GHF.Presenter.CharacterMenu
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using GH.Menu;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Panel;
    using GHF.View;
    using Model;
    using Model.AdditionalFields;
    using View.CharacterMenuProfile;

    public class ProfileTab : ICharacterMenuTab
    {
        private readonly ProfileTabProfileGenerator profileGenerator;
        private readonly SupportedFields supportedFields;
        private readonly IMenuHandler menuHandler;
        private Profile currentProfile;
        private IMenu loadedMenu;
        private readonly List<string> shownAdditionalFields = new List<string>();

        public ProfileTab(SupportedFields supportedFields, IMenuHandler menuHandler)
        {
            this.supportedFields = supportedFields;
            this.menuHandler = menuHandler;
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
                throw new Exception("No profile data loaded.");
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
                    throw new Exception("Unknown menu label key " + key);
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

                var numberOfLines = panel.GetNumElements();
                if (numberOfLines == 0 || panel.GetElement(numberOfLines-1).GetNumElements() == 2)
                {
                    var profile = fieldMeta.GenerateProfile(ObjectAlign.l);
                    var lineProfile = new LineProfile() { profile };
                    var newLine = (ILine)this.menuHandler.CreateRegion(lineProfile);
                    newLine.Prepare(lineProfile, this.menuHandler);
                    panel.AddElement(newLine);
                }
                else
                {
                    var line = panel.GetElement(numberOfLines-1);
                    var profile = fieldMeta.GenerateProfile(ObjectAlign.r);
                    
                    line.AddObjectByProfile(profile, this.menuHandler);
                }

                this.loadedMenu.UpdatePosition();

                var obj = (IMenuObjectWithValue)panel.GetFrameById(fieldMeta.Id);
                obj.SetValue(value);
                this.shownAdditionalFields.Add(key);
            }
        }

        private Dictionary<IField, Action> GetAvailableAdditionalFieldActions()
        {
            var fields = this.supportedFields.Fields.Where(field => !this.shownAdditionalFields.Contains(field.Id)).ToList();
            var fieldActions = new Dictionary<IField, Action>();

            fields.ForEach(field =>
            {
                fieldActions[field] = () => { this.AddAdditionalField(field.Id, string.Empty); };
            });

            return fieldActions;
        }

        public void Save()
        {
            this.currentProfile.Appearance = this.loadedMenu.GetValue(ProfileTabLabels.Appearance) as string;

            this.shownAdditionalFields.ForEach(additionalFieldId =>
            {
                var value = this.loadedMenu.GetValue(additionalFieldId) as string;
                this.currentProfile.AdditionalFields[additionalFieldId] = value;
            });
        }
    }
}
