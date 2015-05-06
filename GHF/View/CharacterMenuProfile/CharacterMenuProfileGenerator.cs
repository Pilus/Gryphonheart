


namespace GHF.View.CharacterMenu
{
    using System;
    using System.Collections.Generic;
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects.Page;

    public class CharacterMenuProfileGenerator : IMenuProfileGenerator
    {
        private IEnumerable<PageProfile> pages;
        private Action onHide;

        public CharacterMenuProfileGenerator(IEnumerable<PageProfile> pages, Action onHide)
        {
            this.pages = pages;
            this.onHide = onHide;
        }

        public MenuProfile GenerateMenuProfile()
        {
            var menu = new MenuProfile("GHF_CharacterMenu", 400, () => { })
            {
                height = 360,
                theme = MenuTheme.TabTheme,
                onHide = onHide,
                title = "Gryphonheart Flags - My profile",
            };

            foreach (var page in this.pages)
            {
                menu.Add(page);
            }

            return menu;
        }
    }
}
