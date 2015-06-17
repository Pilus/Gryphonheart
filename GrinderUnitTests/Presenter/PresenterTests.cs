namespace GrinderUnitTests.Presenter
{
    using Grinder.Presenter;
    using CsLua.Collection;
    using Grinder.Model;
    using Grinder.Model.Entity;
    using Grinder.View;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;

    [TestClass]
    public class PresenterTests
    {
        private Mock<IModel> modelMock;
        private Mock<IView> viewMock;

        [TestInitialize]
        public void TestInitialize()
        {
            this.modelMock = new Mock<IModel>();
            this.viewMock = new Mock<IView>();
        }

        [TestMethod]
        public void PresenterCallsLoadTrackedEntitiesAndDisplaysThemInTheView()
        {
            var item = CreateMockEntity(EntityType.Item, 43, "Test item", "The item icon");
            var currency = CreateMockEntity(EntityType.Currency, 20, "Test currency", "The currency icon");

            this.modelMock.Setup(model => model.LoadTrackedEntities()).Returns(new CsLuaList<IEntity>() { item, currency });
            this.viewMock.Setup(view => view.AddTrackingEntity(It.IsAny<IEntityId>(), It.IsAny<string>(), It.IsAny<string>()));

            var presenter = new Presenter(modelMock.Object, viewMock.Object);

            this.viewMock.Verify(view => view.AddTrackingEntity(It.IsAny<IEntityId>(), It.IsAny<string>(), It.IsAny<string>()), Times.Exactly(2));
            this.viewMock.Verify(view => view.AddTrackingEntity(It.Is<IEntityId>(id => id.Id.Equals(item.Id) && id.Type.Equals(item.Type)), item.Name, item.IconPath), Times.Once());
            this.viewMock.Verify(view => view.AddTrackingEntity(It.Is<IEntityId>(id => id.Id.Equals(currency.Id) && id.Type.Equals(currency.Type)), currency.Name, currency.IconPath), Times.Once());
        }

        [TestMethod]
        public void PresenterUpdatesCountAndVelocityOnUpdateCall()
        {
            var item = CreateMockEntity(EntityType.Item, 43, "Test item", "The item icon");
            var currency = CreateMockEntity(EntityType.Currency, 20, "Test currency", "The currency icon");

            this.modelMock.Setup(model => model.LoadTrackedEntities()).Returns(new CsLuaList<IEntity>() { item, currency });
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 43)).Returns(CreateMockSample(200000, 10));
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Currency, 20)).Returns(CreateMockSample(200000, 0));

            this.viewMock.Setup(view => view.AddTrackingEntity(It.IsAny<IEntityId>(), It.IsAny<string>(), It.IsAny<string>()));
            this.viewMock.Setup(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()));

            Action update = null;
            this.viewMock.Setup(view => view.SetUpdateAction(It.IsAny<Action>()))
                .Callback((Action action) => update = action);

            var presenter = new Presenter(modelMock.Object, viewMock.Object);

            Assert.IsTrue(update != null, "Update function not set.");
            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Never);

            update();

            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Exactly(2));
            this.VerifyAmountAndVelocity(EntityType.Item, 43, 10, 0);
            this.VerifyAmountAndVelocity(EntityType.Currency, 20, 0, 0);

            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 43)).Returns(CreateMockSample(200300, 5));
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Currency, 20)).Returns(CreateMockSample(200300, 30));

            update();

            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Exactly(4));
            this.VerifyAmountAndVelocity(EntityType.Item, 43, 5, -60);
            this.VerifyAmountAndVelocity(EntityType.Currency, 20, 30, 360);
        }

        private void VerifyAmountAndVelocity(EntityType type, int id, int amount, double velocity)
        {
            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(
                It.Is<IEntityId>(entityId => entityId.Id.Equals(id) && entityId.Type.Equals(type)), amount, velocity), Times.Once());
        }

        private static IEntity CreateMockEntity(EntityType type, int id, string name, string icon)
        {
            var mock = new Mock<IEntity>();
            mock.SetupGet(e => e.Id).Returns(id);
            mock.SetupGet(e => e.Type).Returns(type);
            mock.SetupGet(e => e.Name).Returns(name);
            mock.SetupGet(e => e.IconPath).Returns(icon);
            return mock.Object;
        }

        private static IEntitySample CreateMockSample(double time, int amount)
        {
            var mock = new Mock<IEntitySample>();
            mock.SetupGet(e => e.Amount).Returns(amount);
            mock.SetupGet(e => e.Timestamp).Returns(time);
            return mock.Object;
        }
    }
}
