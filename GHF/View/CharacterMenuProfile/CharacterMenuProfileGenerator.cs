


namespace GHF.View.CharacterMenu
{
    using System;
    using CsLua.Collection;
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects.Page;

    public class CharacterMenuProfileGenerator : IMenuProfileGenerator
    {
        private CsLuaList<PageProfile> pages;
        private Action onHide;

        public CharacterMenuProfileGenerator(CsLuaList<PageProfile> pages, Action onHide)
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
