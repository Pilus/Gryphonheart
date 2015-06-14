

namespace Grinder.Model
{
    using System;
    using CsLua.Collection;

    public interface IModel
    {
        CsLuaList<IEntity> GetAvailableEntities(EntityType type);
        int GetCurrentAmount(EntityType type, int entityId);
        void SaveEntityTrackingFlag(EntityType type, int entityId, bool track);
        CsLuaList<IEntity> LoadTrackedEntities();
    }
}
