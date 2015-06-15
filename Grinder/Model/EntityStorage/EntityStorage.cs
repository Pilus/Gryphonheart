namespace Grinder.Model.EntityStorage
{
    using System;
    using CsLua.Collection;

    public class EntityStorage : IEntityStorage
    {
        private const string TrackedEntitiesSavedVariableName = "Grinder_TrackedEntities";

        private TableFormatter<CsLuaList<ITrackedEntity>> formatter;

        public EntityStorage()
        {
            this.formatter = new TableFormatter<CsLuaList<ITrackedEntity>>(true);
        }

        public void AddTrackedEntityIfMissing(ITrackedEntity trackedEntity)
        {
            throw new NotImplementedException();
        }

        public CsLuaList<ITrackedEntity> LoadTrackedEntities()
        {
            throw new NotImplementedException();
        }

        public void RemoveTrackedEntity(ITrackedEntity trackedEntity)
        {
            throw new NotImplementedException();
        }
    }
}
