namespace GH.Menu
{
    using GH.Menu.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using GH.UIModules;

    public interface IMenuHandler : ISingletonModule
    {
        IMenuTheme Theme { get; }
        LayoutSettings Layout { get; }
        IMenu CreateMenu(MenuProfile profile);
        IMenuRegion CreateRegion(IMenuRegionProfile profile);
        IRecyclePool RecyclePool { get; }
        TabOrder TabOrder { get; }
    }
}
