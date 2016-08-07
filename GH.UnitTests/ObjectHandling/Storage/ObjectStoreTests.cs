namespace GH.UnitTests.ObjectHandling.Storage
{
    using CsLuaFramework;
    using GH.ObjectHandling;
    using GH.ObjectHandling.Storage;
    using GH.ObjectHandling.Subscription;
    using Lua;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Misc;
    using Moq;

    [TestClass]
    public class ObjectStoreTests
    {
        private Mock<ISerializer> serializerMock;
        private Mock<ISavedDataHandler> savedDataHandlerMock;
        private Mock<IEntityUpdateSubscriptionCenter<IIdObject<string>, string>> entityUpdateSubCenterMock;
        private ObjectStore<IIdObject<string>, string> storeUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.serializerMock = new Mock<ISerializer>();
            this.savedDataHandlerMock = new Mock<ISavedDataHandler>();
            this.entityUpdateSubCenterMock = new Mock<IEntityUpdateSubscriptionCenter<IIdObject<string>, string>>();
            this.storeUnderTest = new ObjectStore<IIdObject<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object, this.entityUpdateSubCenterMock.Object);
        }

        private static IIdObject<string> MakeObject(string id)
        {
            var mock = new Mock<IIdObject<string>>();
            mock.Setup(o => o.Id).Returns(id);
            return mock.Object;
        }


        [TestMethod]
        public void TestObjectStoreTestCstor()
        {
            new ObjectStore<IIdObject<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object);
        }

        [TestMethod]
        public void TestObjectStoreGet()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData[id1] = savedData1;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(savedData1)).Returns(o1);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var o1Ret = this.storeUnderTest.Get(id1);

            // Assert
            Assert.AreEqual(o1, o1Ret);
        }

        [TestMethod]
        public void TestObjectStoreGetWithWrongId()
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
        public void TestObjectStoreSet()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var dataSet = new NativeLuaTable();
            var o1Serialised = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(dataSet);
            this.serializerMock.Setup(s => s.Serialize(o1)).Returns(o1Serialised);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(o1);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(o1), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, o1Serialised), Times.Once);
            Assert.AreEqual(o1, this.storeUnderTest.Get(id1));
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(o1), Times.Once);
        }

        [TestMethod]
        public void TestObjectStoreSetOverwrites()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var o1New = MakeObject(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData[id1] = savedData1;
            var o1NewSerialised = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(savedData1)).Returns(o1);
            this.serializerMock.Setup(s => s.Serialize(o1New)).Returns(o1NewSerialised);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(o1New);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(o1New), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, o1NewSerialised), Times.Once);
            Assert.AreEqual(o1New, this.storeUnderTest.Get(id1));
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(o1New), Times.Once);
        }

        [TestMethod]
        [ExpectedException(typeof(DataNotLoadedException))]
        public void TestObjectStoreGetBeforeDataLoadThrows()
        {
            this.storeUnderTest.Get("AnyId");
        }

        [TestMethod]
        public void TestObjectStoreGetIds()
        {
            // Set up
            var id1 = "obj1";
            var id2 = "obj2";
            var id3 = "obj3";
            var o1 = MakeObject(id1);
            var o2 = MakeObject(id2);
            var o3 = MakeObject(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t1)).Returns(o1);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t2)).Returns(o2);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t3)).Returns(o3);

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
        public void TestObjectStoreGetAll()
        {
            // Set up
            var id1 = "obj1";
            var id2 = "obj2";
            var id3 = "obj3";
            var o1 = MakeObject(id1);
            var o2 = MakeObject(id2);
            var o3 = MakeObject(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t1)).Returns(o1);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t2)).Returns(o2);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t3)).Returns(o3);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            var allObjs = this.storeUnderTest.GetAll();

            // Assert
            Assert.AreEqual(3, allObjs.Count);
            Assert.AreEqual(o1, allObjs[0]);
            Assert.AreEqual(o2, allObjs[1]);
            Assert.AreEqual(o3, allObjs[2]);
        }

        [TestMethod]
        public void TestObjectStoreRemove()
        {
            // Set up
            var id1 = "obj1";
            var id2 = "obj2";
            var id3 = "obj3";
            var o1 = MakeObject(id1);
            var o2 = MakeObject(id2);
            var o3 = MakeObject(id3);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t1)).Returns(o1);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t2)).Returns(o2);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t3)).Returns(o3);

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