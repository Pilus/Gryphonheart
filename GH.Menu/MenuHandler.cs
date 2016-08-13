namespace GH.Menu
{
    using System;
    using System.Collections.Generic;
    using Containers.Line;

    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Modules;

    using Objects.Button;
    using Objects.DropDown.ButtonWithDropDown;
    using Objects.DropDown.CustomDropDown;
    using Objects.Dummy;
    using Objects.EditBox;
    using Objects.EditField;
    using Objects.Panel;
    using Objects.Text;

    public class MenuHandler : SingletonModule, IMenuHandler
    {
        public MenuHandler()
        {
            this.RecyclePool = new RecyclePool();
            this.Layout = new LayoutSettings()
            {lineSpacing = 5, objectSpacing = 5};
            this.Theme = new MenuTheme()
            {
                TitleBarTextColor = new Color(1.0, 1.0, 1.0),
                TitleBarBackgroundColor = new Color(0.5, 0.1, 0.1),
                BackgroundTexturePath = "Interface/Achievementframe/UI-Achievement-AchievementBackground",
                BackgroundTextureInserts = new Inserts(0.5, 1.0, 0.0, 1.0),
                ButtonColor = new Color(0.5, 0.1, 0.1),
            };
        }

        private static readonly Dictionary<Type, Type> ProfileMapping = new Dictionary<Type, Type>
        {
            {typeof(PageProfile), typeof(Page)},
            {typeof(LineProfile), typeof(Line)},
            {typeof(DummyProfile), typeof(DummyObject)},
            {typeof(ButtonProfile), typeof(ButtonObject)},
            {typeof(ButtonWithDropDownProfile), typeof(ButtonWithDropDownObject)},
            {typeof(CustomDropDownProfile), typeof(CustomDropDownObject)},
            {typeof(PanelProfile), typeof(PanelObject)},
            //{typeof(StandardButtonWithTextureProfile), null},
            {typeof(TextProfile), typeof(TextObject)},
            //{typeof(MultiPageToolbarProfile), typeof(xx)},
            //{typeof(ToolbarLineProfile), typeof(xx)},
            {typeof(EditBoxProfile), typeof(EditBoxObject)},
            {typeof(EditFieldProfile), typeof(EditFieldObject)},
        };

        public LayoutSettings Layout { get; private set; }

        public IRecyclePool RecyclePool { get; private set; }

        public IMenuTheme Theme { get; private set; }

        public TabOrder TabOrder { get; private set; }


        private Type GetMenuObjectType(MenuProfile profile)
        {
            switch (profile.theme)
            {
                case MenuThemeType.StdTheme:
                    return typeof(WindowedMenu);
                case MenuThemeType.BlankTheme:
                    if (profile.useWindow)
                    {
                        return typeof(WindowedMenu);
                    }
                    return typeof(BaseMenu);
                case MenuThemeType.TabTheme:
                    return typeof(TabMenu);
                case MenuThemeType.BlankWizardTheme:
                    throw new NotImplementedException();
                default:
                    throw new Exception("Unknown theme: " + profile.theme);
            }
        }

        public IMenu CreateMenu(MenuProfile profile)
        {
            var type = this.GetMenuObjectType(profile);
            var menu = (IMenu)this.RecyclePool.Retrieve(type);
            menu.Prepare(profile, this);
            menu.UpdatePosition();
            menu.ApplyTheme(this.Theme);
            return menu;
        }

        public IMenuRegion CreateRegion(IMenuRegionProfile profile)
        {
            return this.CreateRegion(profile, false);
        }

        public IMenuRegion CreateRegion(IMenuRegionProfile profile, bool skipWrappingObject)
        {
            var profileType = profile.GetType();
            if (!ProfileMapping.ContainsKey(profileType))
            {
                throw new MenuException("Could not find a mapped object for type {0}.", profileType.Name);
            }
            var type = ProfileMapping[profileType];

            if (!skipWrappingObject && profile is IObjectProfileWithText && !string.IsNullOrEmpty(((IObjectProfileWithText)profile).text))
            {
                type = typeof(BaseObjectWithTextLabel);
            }

            var region = (IMenuRegion)this.RecyclePool.Retrieve(type);
            region.Prepare(profile, this);
            return region;
        }
    }
}
