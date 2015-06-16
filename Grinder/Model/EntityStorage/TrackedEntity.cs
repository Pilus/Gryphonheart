namespace Grinder.Model.EntityStorage
{
    using System;
    using Entity;

    [Serializable]
    public class TrackedEntity
    {
        public TrackedEntity()
        {
            
        }

        public TrackedEntity(EntityType type, int id)
        {
            this.Id = id;
            this.Type = type;
        }

        public EntityType Type { get; set; }
        public int Id { get; set; }
        public bool Equals(TrackedEntity otherEntity)
        {
            return this.Id.Equals(otherEntity.Id) && this.Type.Equals(otherEntity.Type);
        }
    }
}