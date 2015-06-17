namespace Grinder.Presenter
{
    using System;
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
    }
}
