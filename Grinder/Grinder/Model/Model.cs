
namespace Grinder.Model
{
    using BlizzardApi.Global;
    using System;
    using CsLua.Collection;

    public class Model : IModel
    {
        public CsLuaList<IEntity> GetAvailableEntities(EntityType type)
        {
            var list = new CsLuaList<IEntity>();

            switch (type)
            {
                case EntityType.Currency:
                    
                    break;
                case EntityType.Item:
                    break;
                default:
                    break;
            }

            return list;
        }

        public int GetCurrentAmount(string entityId)
        {
            throw new NotImplementedException();
        }

        public CsLuaList<IEntity> LoadTrackedEntities()
        {
            throw new NotImplementedException();
        }

        public void SaveEntityTrackingFlag(string entityId, bool track)
        {
            throw new NotImplementedException();
        }
    }
}
