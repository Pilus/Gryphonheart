namespace GrinderUnitTests.Model
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Grinder.Model;
    using System;
    using Moq;
    using Grinder.Model.EntityAdaptor;
    using CsLua.Collection;
    using Grinder.Model.Entity;

    [TestClass()]
    public class ModelTests
    {
        [TestMethod()]
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

            var modelUnderTest = new Model(adaptorFactoryMock.Object);

            Assert.AreEqual(avaiableItems, modelUnderTest.GetAvailableEntities(EntityType.Item));
            itemAdaptorMock.Verify(adaptor => adaptor.GetAvailableEntities(), Times.Once());
            currencyAdaptorMock.Verify(adaptor => adaptor.GetAvailableEntities(), Times.Never());
        }

        [TestMethod()]
        public void GetCurrentAmountCalledOnCorrectAdaptor()
        {
            var id = 43;
            var itemAdaptorMock = new Mock<IEntityAdaptor>();
            itemAdaptorMock.Setup(adaptor => adaptor.GetCurrentAmount(id)).Returns(15);
            var currencyAdaptorMock = new Mock<IEntityAdaptor>();
            currencyAdaptorMock.Setup(adaptor => adaptor.GetCurrentAmount(id)).Returns(0);

            var adaptorFactoryMock = new Mock<IEntityAdaptorFactory>();
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Currency)).Returns(currencyAdaptorMock.Object);
            adaptorFactoryMock.Setup(factory => factory.CreateAdoptor(EntityType.Item)).Returns(itemAdaptorMock.Object);

            var modelUnderTest = new Model(adaptorFactoryMock.Object);

            Assert.AreEqual(15, modelUnderTest.GetCurrentAmount(EntityType.Item, id));
            itemAdaptorMock.Verify(adaptor => adaptor.GetCurrentAmount(id), Times.Once());
            currencyAdaptorMock.Verify(adaptor => adaptor.GetCurrentAmount(id), Times.Never());
        }

        [TestMethod()]
        public void LoadTrackedEntities()
        {
            throw new NotImplementedException();
        }

        [TestMethod()]
        public void SaveEntityTrackingFlag()
        {
            throw new NotImplementedException();
        }
    }
}