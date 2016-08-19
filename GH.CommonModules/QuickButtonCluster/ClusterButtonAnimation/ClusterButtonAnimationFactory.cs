
namespace GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation
{
    using System;

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
                    throw new Exception("Unknown cluster button type.");
            }
        }
    }
}
