namespace Grinder.View
{
    using Grinder.Model.Entity;
    public interface IEntityId
    {
        int Id { get; }
        EntityType Type { get; }
    }
}
