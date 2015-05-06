
namespace GH.Presenter.ClusterButtonAnimation
{
    using CsLua;
    using Lua;

    public class ClusterButtonAnimationFactory : IClusterButtonAnimationFactory
    {
        public IClusterButtonAnimation Create(ClusterButtonAnimationType type, double r)
        {
            switch (type)
            {
                case ClusterButtonAnimationType.Fade:
                    return new FadeAnimation(r);
                case ClusterButtonAnimationType.Instant:
                    return new InstantAnimation(r);
                default:
                    throw new CsException("Unknown cluster button type.");
            }
        }
    }
}
