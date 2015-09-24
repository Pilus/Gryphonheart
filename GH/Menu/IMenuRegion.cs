
namespace GH.Menu
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Line;
    using GH.Menu.Objects.Page;

    public interface IMenuRegion : IElement
    {
        void SetPosition(IFrame parent, double xOff, double yOff, double width, double height);

        double? GetPreferredWidth();
        double? GetPreferredHeight();
    }
}
