namespace Grinder.Model.EntityStorage
{
    using CsLua.Collection;
    interface IEntityStorage
    {
        CsLuaList<ITrackedEntity> LoadTrackedEntities();
        void AddTrackedEntityIfMissing(ITrackedEntity trackedEntity);
        void RemoveTrackedEntity(ITrackedEntity trackedEntity);
    }
}
