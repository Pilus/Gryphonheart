namespace GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;

    public interface IClusterButtonAnimation
    {
        void AnimateButtons(IButton parent, List<IButton> buttons, bool show);
    }
}