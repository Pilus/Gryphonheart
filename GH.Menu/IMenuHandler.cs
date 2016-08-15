namespace GH.Menu
{
    using System;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Containers.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using GH.Utils.Modules;

    public interface IMenuHandler : IModule
    {
        IMenuTheme Theme { get; }
        LayoutSettings Layout { get; }
        IMenu CreateMenu(MenuProfile profile);
        IMenuRegion CreateRegion(IMenuRegionProfile profile);
        IMenuRegion CreateRegion(IMenuRegionProfile profile, bool skipWrappingObject);
        IMenuRegion CreateRegion(IMenuRegionProfile profile, bool skipWrappingObject, Type specificType);
        IRecyclePool RecyclePool { get; }
        TabOrder TabOrder { get; }
    }
}
