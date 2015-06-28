namespace GrinderUnitTests.Model.EntityAdaptor
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using BlizzardApi.Global;
    using CsLuaTestUtils;
    using Moq;
    using Grinder.Model.Entity;
    using Grinder.Model.EntityAdaptor;

    [TestClass]
    public class ItemAdaptorTests
    {
        private static Mock<IApi> apiMock;
        [TestInitialize]
        public void Initialize()
        {
            apiMock = new Mock<IApi>();
            Global.Api = apiMock.Object;
        }

        private static void MockItems()
        {
            apiMock.Setup(api => api.GetItemInfo(It.IsIn(31, 43, 45, 105)))
                .Returns((int id) =>
                      TestUtil.StructureMultipleValues("item" + id, string.Empty, 3, 60, 0, string.Empty, string.Empty, id > 40 && id < 50 ? id - 40 : 1, string.Empty, "texture" + id, 10));

            var containerSim = new ContainerSimulator();
            containerSim.PutItem(1, 2, 31, 1);
            containerSim.PutItem(2, 8, 43, 2);
            containerSim.PutItem(3, 10, 45, 5);
            containerSim.PutItem(4, 6, 45, 3);
            containerSim.PutItem(-1, 2, 45, 4);
            containerSim.PutItem(10, 9, 45, 2);
            containerSim.PutItem(1, 3, 105, 1);

            containerSim.MockApi(apiMock);
        }

        [TestMethod]
        public void TestGetAvailableEntitiesForItems()
        {
            MockItems();

            var adaptorUnderTest = new ItemAdaptor();

            var items = adaptorUnderTest.GetAvailableEntities();

            Assert.AreEqual(2, items.Count);

            var item1 = items.First(item => item.Id.Equals(43));
            Assert.AreEqual(EntityType.Item, item1.Type);
            Assert.AreEqual(43, item1.Id);
            Assert.AreEqual("item43", item1.Name);
            Assert.AreEqual("texture43", item1.IconPath);

            var item2 = items.First(item => item.Id.Equals(45));
            Assert.AreEqual(EntityType.Item, item2.Type);
            Assert.AreEqual(45, item2.Id);
            Assert.AreEqual("item45", item2.Name);
            Assert.AreEqual("texture45", item2.IconPath);
        }

        [TestMethod]
        public void TestGetCurrentAmountForItems()
        {
            MockItems();

            var adaptorUnderTest = new ItemAdaptor();

            Assert.AreEqual(2, adaptorUnderTest.GetCurrentAmount(43));
            Assert.AreEqual(8, adaptorUnderTest.GetCurrentAmount(45));
        }
    }
}
