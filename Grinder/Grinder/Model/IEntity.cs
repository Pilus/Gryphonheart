

namespace Grinder.Model
{
    public interface IEntity
    {
        string Id { get; }
        EntityType Type { get; }
        string Name { get; }
        string IconPath { get; }
    }
}
