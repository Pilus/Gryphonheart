namespace Grinder.Model.EntityAdaptor
{
    using System;
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using BlizzardApi.Global;

    public class ItemAdaptor : IEntityAdaptor
    {
        private const int FirstBagId = -1;
        private const int LastBagId = 11;

        public CsLuaList<IEntity> GetAvailableEntities()
        {
            var list = new CsLuaList<IEntity>();

            for (var bagId = FirstBagId; bagId <= LastBagId; bagId++)
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

        public int GetCurrentAmount(int entityId)
        {
            return Global.Api.GetItemCount(entityId);
        }
    }
}
