
namespace GH.Presenter.ClusterButtonAnimation
{
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Lua;

    public class FadeAnimation : AnimationBase, IClusterButtonAnimation
    {
        public FadeAnimation(double r)
            : base(r)
        {
            
        }

        public void AnimateButtons(IButton parent, CsLuaList<IButton> buttons, bool show)
        {
            throw new CsException("Not implemented");
        }
    }
}
