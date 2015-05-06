
namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;
    using CsLua;

    public interface IMenuRegion
    {
        void SetPosition(double xOff, double yOff, double width, double height);

        double? GetPreferredWidth();
        double? GetPreferredHeight();

        IFrame Frame { get; }
    }
}
