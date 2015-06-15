
namespace Grinder.Model.EntityAdaptor
{
    using CsLua.Collection;
    using Grinder.Model.Entity;

    public interface IEntityAdaptor
    {
        CsLuaList<IEntity> GetAvailableEntities();
        int GetCurrentAmount(int entityId);
    }
}
