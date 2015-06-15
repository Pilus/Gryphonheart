using Grinder.Model.Entity;

namespace Grinder.Model.EntityAdaptor
{
    public interface IEntityAdaptorFactory
    {
        IEntityAdaptor CreateAdoptor(EntityType type);
    }
}
