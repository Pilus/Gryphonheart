

namespace Grinder.Model.EntityStorage
{
    using Grinder.Model.Entity;

    public interface ITrackedEntity
    {
        EntityType Type { get; set; }
        int Id { get; set; }
    }
}
