
namespace GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;

    public class FadeAnimation : AnimationBase, IClusterButtonAnimation
    {
        public FadeAnimation(double r)
            : base(r)
        {
            
        }

        public void AnimateButtons(IButton parent, List<IButton> buttons, bool show)
        {
            throw new Exception("Not implemented");
        }
    }
}
