namespace GrinderUnitTests
{
    using System;
    using Grinder.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using BlizzardApi.Global;
    using Moq;
    using CsLua.Wrapping;

    [TestClass]
    public class ModelTests
    {
        private static Mock<IApi> apiMock;
        [TestInitialize]
        public void Initialize()
        {
            apiMock = new Mock<IApi>();
            Global.Api = apiMock.Object;
        }

        private static void MockCurrencies()
        {
            apiMock.Setup(api => api.GetCurrencyInfo(It.IsInRange(77, 160, Range.Inclusive)))
                .Returns((int id) => TestUtill.StructureMultipleValues("CurrencyName" + id, id == 80 ? 55 : 10, "iconPath" + id, 7, 100, 1000, id < 100));
        }

        private static void MockItems()
        {
            apiMock.Setup(api => api.GetItemInfo(It.IsIn(31, 43, 45, 105)))
                .Returns((int id) =>
                      TestUtill.StructureMultipleValues("item" + id, string.Empty, 3, 60, 0, string.Empty, string.Empty, id > 40 && id < 50 ? id - 40 : 1, string.Empty, "texture" + id, 10));

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
        public void TestGetAvailableEntitiesReturnsCurrencies()
        {
            MockCurrencies();

            var modelUnderTest = new Model();

            var currencies = modelUnderTest.GetAvailableEntities(EntityType.Currency);

            Assert.AreEqual(23, currencies.Count);

            for (var i = 1; i <= 23; i++)
            {
                var currency = currencies.Skip(i - 1).First();
                var expectedId = i + 76;

                Assert.AreEqual(currency.Type, EntityType.Currency);
                Assert.AreEqual(currency.Id, expectedId);
                Assert.AreEqual(currency.Name, "CurrencyName" + expectedId);
                Assert.AreEqual(currency.IconPath, "iconPath" + expectedId);
            }
        }

        [TestMethod]
        public void TestGetAvailableEntitiesReturnsItems()
        {
            MockItems();

            var modelUnderTest = new Model();

            var items = modelUnderTest.GetAvailableEntities(EntityType.Item);

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
            MockCurrencies();
            MockItems();

            var modelUnderTest = new Model();

            Assert.AreEqual(2, modelUnderTest.GetCurrentAmount(EntityType.Item, 43));
            Assert.AreEqual(8, modelUnderTest.GetCurrentAmount(EntityType.Item, 45));
        }

        [TestMethod]
        public void TestGetCurrentAmountForCurrencies()
        {
            MockCurrencies();
            MockItems();

            var modelUnderTest = new Model();

            Assert.AreEqual(10, modelUnderTest.GetCurrentAmount(EntityType.Currency, 77));
            Assert.AreEqual(55, modelUnderTest.GetCurrentAmount(EntityType.Currency, 80));
            Assert.AreEqual(10, modelUnderTest.GetCurrentAmount(EntityType.Currency, 150));
        }
    }
}
