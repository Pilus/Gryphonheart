namespace GrinderUnitTests.Model
{
    using System;
    using System.Linq;
    using BlizzardApi.Global;
    using CsLua.Collection;
    using CsLua.Wrapping;
    using Moq;

    public class ContainerSimulator
    {
        private readonly CsLuaList<Container> containers;

        public ContainerSimulator()
        {
            this.containers = new CsLuaList<Container>();
            
            for (var i = -1; i <= 11; i++)
            {
                this.containers.Add(new Container()
                {
                    BagId = i,
                    Size = i > 1 && i <= 3 ? 24 : 16,
                });
            }
        }

        public void PutItem(int bagId, int slot, int itemId, int count)
        {
            var matchingContainer = this.containers.First(container => container.BagId.Equals(bagId));

            if (slot < 1 || slot > matchingContainer.Size)
            {
                throw new Exception(string.Format("Slot {0} is not within the bag size of {1}.", slot, matchingContainer.Size));
            }

            matchingContainer.Add(slot, new Slot()
            {
                ItemId = itemId,
                Count = count,
            });
        }

        public void MockApi(Mock<IApi> mock)
        {
            mock.Setup(api => api.GetContainerItemID(It.IsAny<int>(), It.IsAny<int>()))
                .Returns((int bagId, int slotId) => this.GetContainerItemID(bagId, slotId));
            mock.Setup(api => api.GetContainerNumSlots(It.IsInRange(-1, 11, Range.Inclusive)))
                .Returns((int bagId) => this.containers.First(container => container.BagId.Equals(bagId)).Size);
            mock.Setup(api => api.GetItemCount(It.IsAny<int>()))
                .Returns((int itemId) => this.GetItemCount(itemId, false));
            mock.Setup(api => api.GetItemCount(It.IsAny<int>(), It.IsAny<bool>()))
                .Returns((int itemId, bool includeBank) => this.GetItemCount(itemId, includeBank));
            mock.Setup(api => api.GetItemCount(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<bool>()))
                .Returns((int itemId, bool includeBank) => this.GetItemCount(itemId, includeBank));
        }

        private int? GetContainerItemID(int bagId, int slotId)
        {
            var matchingContainer = this.containers.FirstOrDefault(container => container.BagId.Equals(bagId));
            if (matchingContainer != null && matchingContainer.ContainsKey(slotId))
            {
                return matchingContainer[slotId].ItemId;
            }

            return null;
        }

        private int GetItemCount(int itemId, bool includeBank)
        {
            var sum = 0;
            for (var bagId = (includeBank ? -1 : 0); bagId <= (includeBank ? 11 : 4); bagId++)
            {
                var matchingContainer = this.containers.FirstOrDefault(container => container.BagId.Equals(bagId));
                sum += matchingContainer.Sum(slot => slot.Value.ItemId.Equals(itemId) ? slot.Value.Count : 0);
            }
            
            return sum;
        }
    }

    internal class Container : CsLuaDictionary<int, Slot>
    {
        public int BagId;
        public int Size;
    }

    internal class Slot
    {
        public int ItemId;
        public int Count;
    }
}