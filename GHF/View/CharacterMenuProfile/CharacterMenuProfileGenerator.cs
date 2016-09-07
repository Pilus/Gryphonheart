


namespace GHF.View.CharacterMenuProfile
{
    using System;
    using System.Collections.Generic;

    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;

    public class CharacterMenuProfileGenerator : IMenuProfileGenerator
    {
        private List<PageProfile> pages;
        private Action onHide;

        public CharacterMenuProfileGenerator(List<PageProfile> pages, Action onHide)
        {
            this.pages = pages;
            this.onHide = onHide;
        }

        public MenuProfile GenerateMenuProfile()
        {
            var menu = new MenuProfile("GHF_CharacterMenu", 400, () => { })
            {
                height = 360,
                theme = MenuThemeType.TabTheme,
                onHide = this.onHide,
                title = "Gryphonheart Flags - My profile",
                icon = "Interface\\Icons\\Spell_Misc_EmotionHappy",
            };

            foreach (var page in this.pages)
            {
                menu.Add(page);
            }

            return menu;
        }
    }
}
