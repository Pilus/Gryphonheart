
namespace GH.Presenter
{
    public interface IClusterButtonAnimationFactory
    {
        IClusterButtonAnimation Create(ClusterButtonAnimationType type, double r);
    }
}
