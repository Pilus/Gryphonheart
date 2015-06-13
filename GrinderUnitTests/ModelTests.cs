namespace GrinderUnitTests
{
    using Grinder.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using BlizzardApi.Global;
    using Moq;
    using CsLua.Wrapping;

    [TestClass]
    public class ModelTests
    {
        private static void MockCurrenciesAndItems()
        {
            var apiMock = new Mock<IApi>();

            apiMock.Setup(api => api.GetCurrencyInfo(It.IsInRange(77, 160, Range.Inclusive)))
                .Returns((int id) => StructureMultipleValues("CurrencyName" + id, 10, "iconPath" + id, 7, 100, 1000, id < 100));

            Global.Api = apiMock.Object;
        }

        private static IMultipleValues<T1, T2, T3, T4, T5, T6, T7> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);

            return mock.Object;
        }

        [TestMethod]
        public void TestGetAvailableEntitiesReturnsCurrencies()
        {
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
    }
}
