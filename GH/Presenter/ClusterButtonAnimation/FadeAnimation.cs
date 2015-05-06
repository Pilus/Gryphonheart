
namespace GH.Presenter.ClusterButtonAnimation
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using Lua;

    public class FadeAnimation : AnimationBase, IClusterButtonAnimation
    {
        public FadeAnimation(double r)
            : base(r)
        {
            
        }

        public void AnimateButtons(IButton parent, IList<IButton> buttons, bool show)
        {
            throw new CsException("Not implemented");
        }
    }
}
