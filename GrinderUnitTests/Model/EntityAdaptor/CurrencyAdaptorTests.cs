namespace GrinderUnitTests.Model.EntityAdaptor
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using BlizzardApi.Global;
    using Moq;
    using CsLuaTestUtils;
    using Grinder.Model.Entity;
    using Grinder.Model.EntityAdaptor;

    [TestClass]
    public class CurrencyAdaptorTests
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
                .Returns((int id) => TestUtil.StructureMultipleValues("CurrencyName" + id, id == 80 ? 55 : 10, "iconPath" + id, 7, 100, 1000, id < 100));
        }

        [TestMethod]
        public void TestGetAvailableEntitiesReturnsCurrencies()
        {
            MockCurrencies();

            var adaptorUnderTest = new CurrencyAdaptor();

            var currencies = adaptorUnderTest.GetAvailableEntities();

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
        public void TestGetCurrentAmountForCurrencies()
        {
            MockCurrencies();

            var adaptorUnderTest = new CurrencyAdaptor();

            Assert.AreEqual(10, adaptorUnderTest.GetCurrentAmount(77));
            Assert.AreEqual(55, adaptorUnderTest.GetCurrentAmount(80));
            Assert.AreEqual(10, adaptorUnderTest.GetCurrentAmount(150));
        }
    }
}
