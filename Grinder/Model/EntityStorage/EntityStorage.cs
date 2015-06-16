namespace Grinder.Model.EntityStorage
{
    using System;
    using BlizzardApi.Global;
    using CsLua.Collection;
    using Lua;
    using View;

    public class EntityStorage : IEntityStorage
    {
        private const string TrackedEntitiesSavedVariableName = "Grinder_TrackedEntities";

        private readonly TableFormatter<CsLuaList<TrackedEntity>> formatter;
        private CsLuaList<TrackedEntity> trackedEntities;


        public EntityStorage()
        {
            this.formatter = new TableFormatter<CsLuaList<TrackedEntity>>(true);
        }

        
        public CsLuaList<TrackedEntity> LoadTrackedEntities()
        {
            if (this.trackedEntities != null) return this.trackedEntities;

            var savedData = (NativeLuaTable)Global.Api.GetGlobal(TrackedEntitiesSavedVariableName);
            this.trackedEntities = savedData == null ? new CsLuaList<TrackedEntity>() : this.formatter.Deserialize(savedData);

            return this.trackedEntities;
        }

        public void RemoveTrackedEntity(TrackedEntity trackedEntity)
        {
            this.ThrowIfEntitiesNotLoaded();
            var entity = this.trackedEntities.FirstOrDefault(e => e.Equals(trackedEntity));
            if (entity == null)
            {
                throw new EntityStorageException("Could not find the tracked entity to remove.");
            };

            this.trackedEntities.Remove(entity);
            this.SaveTrackedEntities();
        }

        public void AddTrackedEntityIfMissing(TrackedEntity trackedEntity)
        {
            this.ThrowIfEntitiesNotLoaded();
            if (this.trackedEntities.Any(e => e.Equals(trackedEntity))) return;

            this.trackedEntities.Add(trackedEntity);
            this.SaveTrackedEntities();
        }

        private void SaveTrackedEntities()
        {
            Global.Api.SetGlobal(TrackedEntitiesSavedVariableName, this.formatter.Serialize(this.trackedEntities));
        }

        private void ThrowIfEntitiesNotLoaded()
        {
            if (this.trackedEntities == null)
            {
                throw new EntityStorageException("Entities not yet loaded.");
            }
        }

    }
}
