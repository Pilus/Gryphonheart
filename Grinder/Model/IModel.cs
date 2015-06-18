

namespace Grinder.Model
{
    using CsLua.Collection;
    using Grinder.Model.Entity;

    public interface IModel
    {
        CsLuaList<IEntity> GetAvailableEntities(EntityType type);
        IEntitySample GetCurrentSample(EntityType type, int entityId);
        void SaveEntityTrackingFlag(EntityType type, int entityId, bool track);
        CsLuaList<IEntity> LoadTrackedEntities();
    }
}
