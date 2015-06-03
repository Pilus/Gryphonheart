

namespace Grinder.Model
{
    using CsLua.Collection;

    public interface IModel
    {
        CsLuaList<IEntity> GetAvailableEntities(EntityType type);
        int GetCurrentAmount(string entityId);
        void SaveEntityTrackingFlag(string entityId, bool track);
        CsLuaList<IEntity> LoadTrackedEntities();
    }
}
