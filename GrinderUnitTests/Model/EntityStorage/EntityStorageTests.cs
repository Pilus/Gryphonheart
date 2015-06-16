namespace UnitTestProject1.Model.EntityStorage
{
    using BlizzardApi.Global;
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using Grinder.Model.EntityStorage;
    using Grinder.View;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class EntityStorageTests
    {
        [TestMethod]
        public void EntityStorageSavedAndLoadsAsIntended()
        {
            MockGlobalGetSet();
            var storageUnderTest = new EntityStorage();

            var intialTrackedEntities = storageUnderTest.LoadTrackedEntities();

            Assert.AreEqual(0, intialTrackedEntities.Count);

            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Item, 1));
            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Item, 2));
            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Item, 2));
            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Item, 3));
            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Currency, 43));

            storageUnderTest.RemoveTrackedEntity(new TrackedEntity(EntityType.Item, 1));

            var otherStorageLoading = new EntityStorage();

            var loadedEntities = otherStorageLoading.LoadTrackedEntities();
            
            Assert.AreEqual(3, loadedEntities.Count);
            Assert.AreEqual(1, loadedEntities.Where(e => e.Id.Equals(2) && e.Type.Equals(EntityType.Item)).Count);
            Assert.AreEqual(1, loadedEntities.Where(e => e.Id.Equals(3) && e.Type.Equals(EntityType.Item)).Count);
            Assert.AreEqual(1, loadedEntities.Where(e => e.Id.Equals(43) && e.Type.Equals(EntityType.Currency)).Count);
        }

        [TestMethod]
        [ExpectedException(typeof(EntityStorageException))]
        public void EntityStorageThrowsOnAdd()
        {
            MockGlobalGetSet();
            var storageUnderTest = new EntityStorage();

            storageUnderTest.AddTrackedEntityIfMissing(new TrackedEntity(EntityType.Item, 1));
        }

        [TestMethod]
        [ExpectedException(typeof(EntityStorageException))]
        public void EntityStorageThrowsOnRemove()
        {
            MockGlobalGetSet();
            var storageUnderTest = new EntityStorage();

            storageUnderTest.RemoveTrackedEntity(new TrackedEntity(EntityType.Item, 1));
        }

        [TestMethod]
        [ExpectedException(typeof(EntityStorageException))]
        public void EntityStorageThrowsOnRemoveIfNotAdded()
        {
            MockGlobalGetSet();
            var storageUnderTest = new EntityStorage();

            storageUnderTest.LoadTrackedEntities();
            storageUnderTest.RemoveTrackedEntity(new TrackedEntity(EntityType.Item, 1));
        }

        private static void MockGlobalGetSet()
        {
            var globalObjects = new CsLuaDictionary<string, object>();
            var apiMock = new Mock<IApi>();

            apiMock.Setup(api => api.SetGlobal(It.IsAny<string>(), It.IsAny<object>()))
                .Callback((string key, object obj) =>{ globalObjects[key] = obj; });
            apiMock.Setup(api => api.GetGlobal(It.IsAny<string>()))
                .Returns((string key) => globalObjects.ContainsKey(key) ? globalObjects[key] : null);

            Global.Api = apiMock.Object;
        }
    }
}
