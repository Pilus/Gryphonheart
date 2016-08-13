namespace GH.Utils.UnitTests.Entities.Storage
{
    using CsLuaFramework;
    using GH.Utils;
    using GH.Utils.Entities;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Entities.Subscriptions;
    using Lua;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class EntityStoreTests
    {
        private Mock<ISerializer> serializerMock;
        private Mock<ISavedDataHandler> savedDataHandlerMock;
        private Mock<IEntityUpdateSubscriptionCenter<IIdEntity<string>, string>> entityUpdateSubCenterMock;
        private EntityStore<IIdEntity<string>, string> storeUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.serializerMock = new Mock<ISerializer>();
            this.savedDataHandlerMock = new Mock<ISavedDataHandler>();
            this.entityUpdateSubCenterMock = new Mock<IEntityUpdateSubscriptionCenter<IIdEntity<string>, string>>();
            this.storeUnderTest = new EntityStore<IIdEntity<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object, this.entityUpdateSubCenterMock.Object);
        }

        private static IIdEntity<string> MakeEntity(string id)
        {
            var mock = new Mock<IIdEntity<string>>();
            mock.Setup(o => o.Id).Returns(id);
            return mock.Object;
        }


        [TestMethod]
        public void TestEntityStoreCstor()
        {
            new EntityStore<IIdEntity<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object);
        }

        [TestMethod]
        public void TestEntityStoreGet()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData[id1] = savedData1;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(savedData1)).Returns(e1);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var e1Ret = this.storeUnderTest.Get(id1);

            // Assert
            Assert.AreEqual(e1, e1Ret);
        }

        [TestMethod]
        public void TestEntityStoreGetWithWrongId()
        {
            // Set up
            var savedData = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var ret = this.storeUnderTest.Get("WrongID");

            // Assert
            Assert.AreEqual(null, ret);
        }

        [TestMethod]
        public void TestEntityStoreSet()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var dataSet = new NativeLuaTable();
            var e1Serialised = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(dataSet);
            this.serializerMock.Setup(s => s.Serialize(e1)).Returns(e1Serialised);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(e1);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(e1), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, e1Serialised), Times.Once);
            Assert.AreEqual(e1, this.storeUnderTest.Get(id1));
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(e1), Times.Once);
        }

        [TestMethod]
        public void TestEntityStoreSetOverwrites()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var e1New = MakeEntity(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData[id1] = savedData1;
            var e1NewSerialised = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(savedData1)).Returns(e1);
            this.serializerMock.Setup(s => s.Serialize(e1New)).Returns(e1NewSerialised);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(e1New);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(e1New), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, e1NewSerialised), Times.Once);
            Assert.AreEqual(e1New, this.storeUnderTest.Get(id1));
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(e1New), Times.Once);
        }

        [TestMethod]
        [ExpectedException(typeof(DataNotLoadedException))]
        public void TestEntityStoreGetBeforeDataLoadThrows()
        {
            this.storeUnderTest.Get("AnyId");
        }

        [TestMethod]
        public void TestEntityStoreGetIds()
        {
            // Set up
            var id1 = "entity1";
            var id2 = "entity2";
            var id3 = "entity3";
            var e1 = MakeEntity(id1);
            var e2 = MakeEntity(id2);
            var e3 = MakeEntity(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t1)).Returns(e1);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t2)).Returns(e2);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t3)).Returns(e3);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var idList = this.storeUnderTest.GetIds();

            // Assert
            Assert.AreEqual(3, idList.Count);
            Assert.AreEqual(id1, idList[0]);
            Assert.AreEqual(id2, idList[1]);
            Assert.AreEqual(id3, idList[2]);
        }

        [TestMethod]
        public void TestEntityStoreGetAll()
        {
            // Set up
            var id1 = "entity1";
            var id2 = "entity2";
            var id3 = "entity3";
            var e1 = MakeEntity(id1);
            var e2 = MakeEntity(id2);
            var e3 = MakeEntity(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t1)).Returns(e1);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t2)).Returns(e2);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t3)).Returns(e3);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var allEntities = this.storeUnderTest.GetAll();

            // Assert
            Assert.AreEqual(3, allEntities.Count);
            Assert.AreEqual(e1, allEntities[0]);
            Assert.AreEqual(e2, allEntities[1]);
            Assert.AreEqual(e3, allEntities[2]);
        }

        [TestMethod]
        public void TestEntityStoreRemove()
        {
            // Set up
            var id1 = "entity1";
            var id2 = "entity2";
            var id3 = "entity3";
            var e1 = MakeEntity(id1);
            var e2 = MakeEntity(id2);
            var e3 = MakeEntity(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t1)).Returns(e1);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t2)).Returns(e2);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t3)).Returns(e3);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Remove(id2);

            // Assert
            var idList = this.storeUnderTest.GetIds();
            Assert.AreEqual(2, idList.Count);
            Assert.AreEqual(id1, idList[0]);
            Assert.AreEqual(id3, idList[1]);
        }
    }
}