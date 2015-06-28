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
    using Lua;

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

            var presenter = new Presenter(this.modelMock.Object, this.viewMock.Object);

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

            Action update = null;
            this.viewMock.Setup(view => view.SetUpdateAction(It.IsAny<Action>()))
                .Callback((Action action) => update = action);

            var presenter = new Presenter(this.modelMock.Object, this.viewMock.Object);

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

        [TestMethod]
        public void PresenterResetsTheInitialSampleOnReset()
        {
            var item = CreateMockEntity(EntityType.Item, 43, "Test item", "The item icon");
            var currency = CreateMockEntity(EntityType.Currency, 20, "Test currency", "The currency icon");

            this.modelMock.Setup(model => model.LoadTrackedEntities()).Returns(new CsLuaList<IEntity>() { item, currency });
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 43)).Returns(CreateMockSample(200000, 10));
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Currency, 20)).Returns(CreateMockSample(200000, 0));

            Action<IEntityId> reset = null;
            this.viewMock.Setup(view => view.SetTrackingEntityHandlers(It.IsAny<Action<IEntityId>>(), It.IsAny<Action<IEntityId>>()))
                .Callback((Action<IEntityId> resetAction, Action<IEntityId> removeAction) => reset = resetAction);

            var presenter = new Presenter(this.modelMock.Object, this.viewMock.Object);

            Assert.IsTrue(reset != null, "Reset function not set.");
            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Never);

            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 43)).Returns(CreateMockSample(200400, 15));

            reset(new EntityId(EntityType.Item, 43));

            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Once);
            this.VerifyAmountAndVelocity(EntityType.Item, 43, 15, 0);
        }

        [TestMethod]
        public void PresenterRemovesTheInitialSampleOnRemove()
        {
            var item = CreateMockEntity(EntityType.Item, 43, "Test item", "The item icon");
            var currency = CreateMockEntity(EntityType.Currency, 20, "Test currency", "The currency icon");

            this.modelMock.Setup(model => model.LoadTrackedEntities()).Returns(new CsLuaList<IEntity>() { item, currency });
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 43)).Returns(CreateMockSample(200000, 10));
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Currency, 20)).Returns(CreateMockSample(200000, 0));

            Action<IEntityId> remove = null;
            this.viewMock.Setup(view => view.SetTrackingEntityHandlers(It.IsAny<Action<IEntityId>>(), It.IsAny<Action<IEntityId>>()))
                .Callback((Action<IEntityId> resetAction, Action<IEntityId> removeAction) => remove = removeAction);

            var presenter = new Presenter(this.modelMock.Object, this.viewMock.Object);

            Assert.IsTrue(remove != null, "Remove function not set.");
            
            remove(new EntityId(EntityType.Item, 43));

            this.viewMock.Verify(view => view.RemoveTrackingEntity(It.IsAny<IEntityId>()), Times.Once);
            this.viewMock.Verify(view => view.RemoveTrackingEntity(It.Is<IEntityId>(entityId => entityId.Id.Equals(43) && entityId.Type.Equals(EntityType.Item))), Times.Exactly(1));

            this.modelMock.Verify(model => model.SaveEntityTrackingFlag(It.IsAny<EntityType>(), It.IsAny<int>(), It.IsAny<bool>() ), Times.Once);
            this.modelMock.Verify(model => model.SaveEntityTrackingFlag(EntityType.Item, 43, false), Times.Once);
        }

        [TestMethod]
        public void PresenterProvidesHandlesTrackClickAndTrackableEntitySelection()
        {
            this.modelMock.Setup(model => model.LoadTrackedEntities()).Returns(new CsLuaList<IEntity>());
            var item1 = CreateMockEntity(EntityType.Item, 43, "Test item 1", "The item icon 1");
            var item2 = CreateMockEntity(EntityType.Item, 45, "Test item 2", "The item icon 2");
            var currency = CreateMockEntity(EntityType.Currency, 20, "Test currency", "The currency icon");

            this.modelMock.Setup(model => model.GetAvailableEntities(EntityType.Item)).Returns(new CsLuaList<IEntity>() { item1, item2 });
            this.modelMock.Setup(model => model.GetAvailableEntities(EntityType.Currency)).Returns(new CsLuaList<IEntity>() { currency });
            this.modelMock.Setup(model => model.GetCurrentSample(EntityType.Item, 45)).Returns(CreateMockSample(200000, 10));

            Action track = null;
            Action update = null;
            this.viewMock.Setup(view => view.SetTrackButtonOnClick(It.IsAny<Action>()))
                .Callback((Action trackClick) => track = trackClick);
            this.viewMock.Setup(view => view.SetUpdateAction(It.IsAny<Action>()))
                .Callback((Action updateAction) => update = updateAction);

            var presenter = new Presenter(this.modelMock.Object, this.viewMock.Object);

            Assert.IsTrue(track != null, "Track click function not set.");
            this.viewMock.Verify(view => view.ShowEntitySelection(It.IsAny<IEntitySelection>()), Times.Never);

            IEntitySelection entitySelection = null;
            this.viewMock.Setup(view => view.ShowEntitySelection(It.IsAny<IEntitySelection>()))
                .Callback((IEntitySelection selection) => entitySelection = selection);

            track();

            this.viewMock.Verify(view => view.ShowEntitySelection(It.IsAny<IEntitySelection>()), Times.Once);
            Assert.IsTrue(entitySelection != null, "Entity selection not provided.");
            Assert.AreEqual(2, entitySelection.Count);

            var itemsString = "Items";
            var currenciesString = "Currencies";

            Assert.IsTrue(entitySelection.ContainsKey(itemsString));
            Assert.IsTrue(entitySelection.ContainsKey(currenciesString));

            Assert.AreEqual(2, entitySelection[itemsString].Count);
            Assert.AreEqual(1, entitySelection[itemsString]
                .Where(item => item.Name.Equals(item1.Name) && item.IconPath.Equals(item1.IconPath)).Count);
            Assert.AreEqual(1, entitySelection[itemsString]
                .Where(item => item.Name.Equals(item2.Name) && item.IconPath.Equals(item2.IconPath)).Count);

            Assert.AreEqual(1, entitySelection[currenciesString].Count);
            Assert.AreEqual(1, entitySelection[currenciesString]
                .Where(c => c.Name.Equals(currency.Name) && c.IconPath.Equals(currency.IconPath)).Count);

            this.viewMock.Verify(view => view.AddTrackingEntity(It.IsAny<IEntityId>(), It.IsAny<string>(), It.IsAny<string>()), Times.Never);
            this.modelMock.Verify(model => model.SaveEntityTrackingFlag(It.IsAny<EntityType>(), It.IsAny<int>(), It.IsAny<bool>()), Times.Never);

            entitySelection[itemsString][1].OnSelect();

            this.viewMock.Verify(view => view.AddTrackingEntity(It.IsAny<IEntityId>(), It.IsAny<string>(), It.IsAny<string>()), Times.Once);
            this.viewMock.Verify(view => view.AddTrackingEntity(It.Is<IEntityId>(entityId => entityId.Id.Equals(item2.Id) && entityId.Type.Equals(item2.Type)), item2.Name, item2.IconPath), Times.Once);
            this.modelMock.Verify(model => model.SaveEntityTrackingFlag(It.IsAny<EntityType>(), It.IsAny<int>(), It.IsAny<bool>()), Times.Once);
            this.modelMock.Verify(model => model.SaveEntityTrackingFlag(item2.Type, item2.Id, true), Times.Once);

            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.IsAny<IEntityId>(), It.IsAny<int>(), It.IsAny<double>()), Times.Once);
            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.Is<IEntityId>(entityId => entityId.Id.Equals(item2.Id) && entityId.Type.Equals(item2.Type)), 10, 0), Times.Once);

            Core.mockTime = Core.time() + 1;
            update();

            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(It.Is<IEntityId>(entityId => entityId.Id.Equals(item2.Id) && entityId.Type.Equals(item2.Type)), 10, 0), Times.Exactly(2));
        }

        private void VerifyAmountAndVelocity(EntityType type, int id, int amount, double velocity)
        {
            this.viewMock.Verify(view => view.UpdateTrackingEntityVelocity(
                It.Is<IEntityId>(entityId => entityId.Id.Equals(id) && entityId.Type.Equals(type)), amount, velocity), Times.Once);
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
