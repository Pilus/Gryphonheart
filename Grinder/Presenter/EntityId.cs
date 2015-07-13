namespace Grinder.Presenter
{
    using Grinder.Model.Entity;
    using Grinder.View;
    public class EntityId : IEntityId
    {
        public EntityId(EntityType type, int id)
        {
            this.Type = type;
            this.Id = id;
        }

        public int Id { get; private set; }

        public EntityType Type { get; private set; }

        public override bool Equals(object obj)
        {
            if (obj is IEntityId)
            {
                var other = ((IEntityId)obj);
                return this.Id.Equals(other.Id) && this.Type.Equals(other.Type);
            }
            return base.Equals(obj);
        }
    }
}
