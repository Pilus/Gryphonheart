namespace GH.Menu
{
    using System;
    using GH.Menu.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using GH.Model;
    using GH.ObjectHandling.Storage;

    public class MenuHandler : IMenuHandler
    {
        public MenuHandler()
        {
            
        }

        public LayoutSettings Layout { get; private set; }

        public IRecyclePool RecyclePool { get; private set; }

        public IMenuTheme Theme { get; private set; }

        public TabOrder TabOrder { get; private set; }

        public IMenu CreateMenu(MenuProfile profile)
        {
            throw new NotImplementedException();
        }

        public IMenuRegion CreateRegion(IMenuRegionProfile profile)
        {
            throw new NotImplementedException();
        }

        public void LoadSettings(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            throw new NotImplementedException();
        }

        public void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            throw new NotImplementedException();
        }
    }
}
