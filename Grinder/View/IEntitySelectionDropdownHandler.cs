namespace Grinder.View
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEntitySelectionDropdownHandler
    {
        void Show(IFrame anchor, IEntitySelection selction);
    }
}
