
namespace Grinder.Model
{
    using BlizzardApi.Global;
    using System;
    using CsLua.Collection;
    using CsLua.Wrapping;

    public class Model : IModel
    {
        public CsLuaList<IEntity> GetAvailableEntities(EntityType type)
        {   
            switch (type)
            {
                case EntityType.Currency:
                    return GetAvailableCurrencies();
                case EntityType.Item:
                    return GetAvailableItems();
                default:
                    throw new Exception("Unknown entity type.");
            }
        }

        private static CsLuaList<IEntity> GetAvailableCurrencies()
        {
            var list = new CsLuaList<IEntity>();

            var id = 1;
            var continuousNullCount = 0;
            while (continuousNullCount < 100)
            {
                var currencyInfo = Global.Api.GetCurrencyInfo(id);

                if (currencyInfo != null)
                {
                    var currency = new Currency(id, currencyInfo);
                    if (currency.IsDiscovered)
                    {
                        list.Add(currency);
                    }
                    
                    continuousNullCount = 0;
                }
                else
                {
                    continuousNullCount++;
                }
                id++;
            }
            
            return list;
        }

        private static CsLuaList<IEntity> GetAvailableItems()
        {
            var list = new CsLuaList<IEntity>();

            for (var bagId = -1; bagId <= 11; bagId++)
            {
                for (var slot = 1; slot < Global.Api.GetContainerNumSlots(bagId); slot++)
                {
                    var itemId = Global.Api.GetContainerItemID(bagId, slot);
                    if (itemId != null && !list.Any(item => item.Id.Equals(itemId)))
                    {
                        var item = new Item((int)itemId, Global.Api.GetItemInfo((int)itemId));
                        if (item.StackSize > 1)
                        {
                            list.Add(item);
                        }
                    }
                }
            }

            return list;
        }

        public int GetCurrentAmount(EntityType type, int entityId)
        {
            switch (type)
            {
                case EntityType.Currency:
                    return Global.Api.GetCurrencyInfo(entityId).Value2;
                case EntityType.Item:
                    return Global.Api.GetItemCount(entityId);
                default:
                    throw new Exception("Unknown entity type.");
            }
        }

        public CsLuaList<IEntity> LoadTrackedEntities()
        {
            throw new NotImplementedException();
        }

        public void SaveEntityTrackingFlag(EntityType type, int entityId, bool track)
        {
            throw new NotImplementedException();
        }
    }
}
