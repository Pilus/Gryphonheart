namespace GrinderUnitTests.Model
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Grinder.Model;
    using Moq;
    using Grinder.Model.EntityAdaptor;
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using Grinder.Model.EntityStorage;

    [TestClass]
    public class ModelTests
    {
        [TestMethod]
        public void GetAvailableEntitiesCalledOnCorrectAdaptor()
        {
            var itemMock = new Mock<IEntity>();
            var avaiableItems = new CsLuaList<IEntity>() { itemMock.Object };
            var itemAdaptorMock = new Mock<IEntityAdaptor>();
            itemAdaptorMock.Setup(adaptor => adaptor.GetAvailableEntities()).Returns(avaiableItems);
            var currencyAdaptorMock = new Mock<IEntityAdaptor>();

            var adaptorFactoryMock = new Mock<IEntityAdaptorFactory>();
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Currency)).Returns(currencyAdaptorMock.Object);
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Item)).Returns(itemAdaptorMock.Object);

            var modelUnderTest = new Model(adaptorFactoryMock.Object, null);

            Assert.AreEqual(avaiableItems, modelUnderTest.GetAvailableEntities(EntityType.Item));
            itemAdaptorMock.Verify(adaptor => adaptor.GetAvailableEntities(), Times.Once());
            currencyAdaptorMock.Verify(adaptor => adaptor.GetAvailableEntities(), Times.Never());
        }

        [TestMethod]
        public void GetCurrentSampleCallsGetCurrentAmountOnCorrectAdaptor()
        {
            var id = 43;
            var itemAdaptorMock = new Mock<IEntityAdaptor>();
            itemAdaptorMock.Setup(adaptor => adaptor.GetCurrentAmount(id)).Returns(15);
            var currencyAdaptorMock = new Mock<IEntityAdaptor>();
            currencyAdaptorMock.Setup(adaptor => adaptor.GetCurrentAmount(id)).Returns(0);

            var adaptorFactoryMock = new Mock<IEntityAdaptorFactory>();
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Currency)).Returns(currencyAdaptorMock.Object);
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Item)).Returns(itemAdaptorMock.Object);

            var modelUnderTest = new Model(adaptorFactoryMock.Object, null);

            Assert.AreEqual(15, modelUnderTest.GetCurrentSample(EntityType.Item, id).Amount);
            itemAdaptorMock.Verify(adaptor => adaptor.GetCurrentAmount(id), Times.Once());
            currencyAdaptorMock.Verify(adaptor => adaptor.GetCurrentAmount(id), Times.Never());
        }

        [TestMethod]
        public void LoadTrackedEntities()
        {
            var includedItem1 = CreateMockEntity(EntityType.Item, 43);
            var includedItem2 = CreateMockEntity(EntityType.Item, 55);
            var excludedItem = CreateMockEntity(EntityType.Item, 60);
            var excludedCurrency = CreateMockEntity(EntityType.Currency, 43);
            var includedCurrency = CreateMockEntity(EntityType.Currency, 70);

            var itemAdaptorMock = new Mock<IEntityAdaptor>();
            itemAdaptorMock.Setup(adaptor => adaptor.GetAvailableEntities()).Returns(new CsLuaList<IEntity>() { includedItem1, includedItem2, excludedItem });
            var currencyAdaptorMock = new Mock<IEntityAdaptor>();
            currencyAdaptorMock.Setup(adaptor => adaptor.GetAvailableEntities()).Returns(new CsLuaList<IEntity>() { excludedCurrency, includedCurrency });

            var adaptorFactoryMock = new Mock<IEntityAdaptorFactory>();
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Currency)).Returns(currencyAdaptorMock.Object);
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Item)).Returns(itemAdaptorMock.Object);

            var entityStorageMock = new Mock<IEntityStorage>();
            entityStorageMock.Setup(storage => storage.LoadTrackedEntities())
                .Returns(new CsLuaList<TrackedEntity>()
                {
                    new TrackedEntity(EntityType.Item, 43),
                    new TrackedEntity(EntityType.Item, 55),
                    new TrackedEntity(EntityType.Currency, 70),
                    new TrackedEntity(EntityType.Currency, 1008), // Unknown currency.
                });

            var modelUnderTest = new Model(adaptorFactoryMock.Object, entityStorageMock.Object);

            var trackedEntities = modelUnderTest.LoadTrackedEntities();

            Assert.AreEqual(3, trackedEntities.Count);
            Assert.AreEqual(1, trackedEntities.Where(e => e == includedItem1).Count);
            Assert.AreEqual(1, trackedEntities.Where(e => e == includedItem2).Count);
            Assert.AreEqual(1, trackedEntities.Where(e => e == includedCurrency).Count);
        }

        [TestMethod]
        public void SaveEntityTrackingFlagAddsTheFlagToStorage()
        {
            var entityStorageMock = new Mock<IEntityStorage>();

            var modelUnderTest = new Model( new Mock<IEntityAdaptorFactory>().Object, entityStorageMock.Object);

            modelUnderTest.SaveEntityTrackingFlag(EntityType.Item, 42, true);

            entityStorageMock.Verify(storage => storage.AddTrackedEntityIfMissing(It.IsAny<TrackedEntity>()), Times.Once());
            entityStorageMock.Verify(storage => storage.AddTrackedEntityIfMissing(
                It.Is<TrackedEntity>(e => e.Id.Equals(42) && e.Type.Equals(EntityType.Item))), Times.Once());
            entityStorageMock.Verify(storage => storage.RemoveTrackedEntity(It.IsAny<TrackedEntity>()), Times.Never());
        }

        [TestMethod]
        public void SaveEntityTrackingFlagRemovesTheFlagFromStorage()
        {
            var entityStorageMock = new Mock<IEntityStorage>();

            var modelUnderTest = new Model( new Mock<IEntityAdaptorFactory>().Object, entityStorageMock.Object);

            modelUnderTest.SaveEntityTrackingFlag(EntityType.Item, 42, false);

            entityStorageMock.Verify(storage => storage.RemoveTrackedEntity(It.IsAny<TrackedEntity>()), Times.Once());
            entityStorageMock.Verify(storage => storage.RemoveTrackedEntity(
                It.Is<TrackedEntity>(e => e.Id.Equals(42) && e.Type.Equals(EntityType.Item))), Times.Once());
            entityStorageMock.Verify(storage => storage.AddTrackedEntityIfMissing(It.IsAny<TrackedEntity>()), Times.Never());
        }

        private static IEntity CreateMockEntity(EntityType type, int id)
        {
            var mock = new Mock<IEntity>();
            mock.SetupGet(e => e.Id).Returns(id);
            mock.SetupGet(e => e.Type).Returns(type);
            return mock.Object;
        }
    }
}