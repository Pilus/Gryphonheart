
namespace Grinder.Model
{
    using System;
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using Grinder.Model.EntityAdaptor;

    public class Model : IModel
    {
        private IEntityAdaptorFactory adaptorFactory;
        private CsLuaDictionary<EntityType, IEntityAdaptor> adaptors;

        public Model(IEntityAdaptorFactory adaptorFactory)
        {
            this.adaptorFactory = adaptorFactory;
            this.adaptors = new CsLuaDictionary<EntityType, IEntityAdaptor>();
            this.CreateAdaptor(EntityType.Currency);
            this.CreateAdaptor(EntityType.Item);
        }

        private void CreateAdaptor(EntityType type)
        {
            this.adaptors.Add(type, this.adaptorFactory.CreateAdoptor(type));
        }

        public CsLuaList<IEntity> GetAvailableEntities(EntityType type)
        {
            return this.adaptors[type].GetAvailableEntities();
        }

        public int GetCurrentAmount(EntityType type, int entityId)
        {
            return this.adaptors[type].GetCurrentAmount(entityId);
        }

        public CsLuaList<IEntity> LoadTrackedEntities()
        {
            var knownEntities = new CsLuaDictionary<EntityType, CsLuaList<IEntity>>();

            throw new NotImplementedException();
        }

        public void SaveEntityTrackingFlag(EntityType type, int entityId, bool track)
        {
            throw new NotImplementedException();
        }
    }
}
