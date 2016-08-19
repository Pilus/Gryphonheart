
namespace GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation
{
    public interface IClusterButtonAnimationFactory
    {
        IClusterButtonAnimation Create(ClusterButtonAnimationType type, double r);
    }
}
