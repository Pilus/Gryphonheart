using Grinder.Model.Entity;

namespace Grinder.View
{
    public interface IEntityId
    {
        int Id { get; }
        EntityType Type { get; }
    }
}
