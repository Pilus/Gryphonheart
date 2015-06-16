namespace Grinder.Model.EntityStorage
{
    using CsLua.Collection;
    using View;

    public interface IEntityStorage
    {
        CsLuaList<TrackedEntity> LoadTrackedEntities();
        void AddTrackedEntityIfMissing(TrackedEntity trackedEntity);
        void RemoveTrackedEntity(TrackedEntity trackedEntity);
    }
}
