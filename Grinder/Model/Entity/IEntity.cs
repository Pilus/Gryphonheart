

namespace Grinder.Model.Entity
{
    public interface IEntity
    {
        int Id { get; }
        EntityType Type { get; }
        string Name { get; }
        string IconPath { get; }
    }
}
