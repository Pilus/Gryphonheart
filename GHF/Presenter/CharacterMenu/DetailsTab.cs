

namespace GHF.Presenter.CharacterMenu
{
    using System;
    using System.Collections.Generic;
    using GH.Menu.Menus;
    using GH.Menu.Objects.Page;
    using Model;
    using View.CharacterMenuProfile;

    public class DetailsTab : ICharacterMenuTab
    {
        private IDetails currentDetails;
        private IMenu loadedMenu;
        private List<string> additionalFields;

        public PageProfile GetGeneratedProfile()
        {
            return DetailsTabProfileGenerator.GenerateProfile(this.IsFieldAdded);
        }

        public void Load(IMenu menu, Profile profile)
        {
            this.loadedMenu = menu;
            this.currentDetails = profile.Details;
            this.additionalFields = new List<string>();
            this.loadedMenu.SetValue(DetailsTabLabels.Background, profile.Details.Background);

            //this.AddAndUpdateFieldIfNeeded(DetailsTabLabels.Goals, this.currentDetails.Goals);
        }

        public void Save()
        {
            this.ThrowIfMenuIsNotLoaded();
            this.currentDetails.Background = this.loadedMenu.GetValue(DetailsTabLabels.Background) as string;
            //this.currentDetails.Goals = this.loadedMenu.GetValue(DetailsTabLabels.Goals) as string;
            //this.currentDetails.CurrentLocation = this.loadedMenu.GetValue(DetailsTabLabels.CurrentLocation) as string;
        }


        private bool IsFieldAdded(string label)
        {
            this.ThrowIfMenuIsNotLoaded();
            return this.additionalFields.Contains(label);
        }

        private void ThrowIfMenuIsNotLoaded()
        {
            if (this.loadedMenu == null)
            {
                throw new Exception("This action cannot be performed before the menu is loaded.");
            }
        }
    }
}
