namespace GH.Presenter
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;

    public interface IClusterButtonAnimation
    {
        void AnimateButtons(IButton parent, IList<IButton> buttons, bool show);
    }
}