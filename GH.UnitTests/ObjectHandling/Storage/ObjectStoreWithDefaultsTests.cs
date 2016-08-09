namespace GH.UnitTests.ObjectHandling.Storage
{
    using System;
    using System.Linq.Expressions;

    using CsLuaFramework;

    using GH.Misc;
    using GH.ObjectHandling;
    using GH.ObjectHandling.Storage;
    using GH.ObjectHandling.Subscription;

    using Lua;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class ObjectStoreWithDefaultsTests
    {
        private Mock<ISerializer> serializerMock;
        private Mock<ISavedDataHandler> savedDataHandlerMock;
        private Mock<IEntityUpdateSubscriptionCenter<IIdObject<string>, string>> entityUpdateSubCenterMock;
        private ObjectStoreWithDefaults<IIdObject<string>, string> storeUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.serializerMock = new Mock<ISerializer>();
            this.savedDataHandlerMock = new Mock<ISavedDataHandler>();
            this.entityUpdateSubCenterMock = new Mock<IEntityUpdateSubscriptionCenter<IIdObject<string>, string>>();
            this.storeUnderTest = new ObjectStoreWithDefaults<IIdObject<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object, this.entityUpdateSubCenterMock.Object);
        }

        private static IIdObject<string> MakeObject(string id)
        {
            var mock = new Mock<IIdObject<string>>();
            mock.Setup(o => o.Id).Returns(id);
            return mock.Object;
        }


        [TestMethod]
        public void TestObjectStoreWithDefaultsCstor()
        {
            new ObjectStoreWithDefaults<IIdObject<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsGet()
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
        [ExpectedException(typeof(NoDefaultValueFoundException))]
        public void TestObjectStoreWithDefaultsGetWithWrongIdThrows()
        {
            // Set up
            var savedData = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Get("WrongID");
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsSet()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var dataSet = new NativeLuaTable();
            var o1Serialised = new NativeLuaTable();
            o1Serialised["Value"] = 43;
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
        [ExpectedException(typeof(ArgumentNullException))]
        public void TestObjectStoreWithDefaultsSetThrowsOnNull()
        {
            this.storeUnderTest.Set(null);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void TestObjectStoreWithDefaultsSetDefaultThrowsOnNull()
        {
            this.storeUnderTest.SetDefault(null);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsSetOverwrites()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var o1New = MakeObject(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData1["Value"] = 10;
            savedData[id1] = savedData1;
            var o1NewSerialised = new NativeLuaTable();
            o1NewSerialised["Value"] = 43;
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
        public void TestObjectStoreWithDefaultsGetBeforeDataLoadThrows()
        {
            this.storeUnderTest.Get("AnyId");
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsSetDefault()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var o1Default = MakeObject(id1);
            var o1Serialised = new NativeLuaTable();
            var o1SubValue = new NativeLuaTable();
            o1SubValue["InObj"] = true;
            o1SubValue["InBoth"] = 3;
            o1Serialised["Value1"] = 43;
            o1Serialised["Value2"] = 10;
            o1Serialised["Value3"] = o1SubValue;
            var o1SubTable2 = new NativeLuaTable();
            o1SubTable2["Value"] = 1;
            o1Serialised["Value4"] = o1SubTable2;

            var o1DefaultSerialized = new NativeLuaTable();
            var o1DefaultSubValue = new NativeLuaTable();
            o1DefaultSubValue["InBoth"] = 5;
            o1DefaultSubValue["InDef"] = true;
            o1DefaultSerialized["Value1"] = 35;
            o1DefaultSerialized["Value3"] = o1DefaultSubValue;
            var o1DefaultSubTable2 = new NativeLuaTable();
            o1DefaultSubTable2["Value"] = 1;
            o1DefaultSerialized["Value4"] = o1DefaultSubTable2;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(o1)).Returns(o1Serialised);
            this.serializerMock.Setup(s => s.Serialize(o1Default)).Returns(o1DefaultSerialized);
            NativeLuaTable savedId1Table = null;
            this.savedDataHandlerMock
                .Setup(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()))
                .Callback<object, NativeLuaTable>((id, t) => savedId1Table = t);

            // Execute
            this.storeUnderTest.SetDefault(o1Default);
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(o1);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(o1Default), Times.Once);
            this.serializerMock.Verify(s => s.Serialize(o1), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()), Times.Once);
            Assert.IsNotNull(savedId1Table);
            Assert.AreEqual(43, savedId1Table["Value1"]);
            Assert.AreEqual(10, savedId1Table["Value2"]);
            Assert.IsTrue(savedId1Table["Value3"] is NativeLuaTable);
            var value3 = savedId1Table["Value3"] as NativeLuaTable;
            Assert.AreEqual(true, value3["InObj"]);
            Assert.AreEqual(null, value3["InDef"]);
            Assert.AreEqual(3, value3["InBoth"]);
            
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(o1), Times.Once);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsLoadsAndMergesWithDefault()
        {
            // Set up
            var id1 = "obj1";
            var o1 = MakeObject(id1);
            var o1Default = MakeObject(id1);
            var o1Serialised = new NativeLuaTable();
            var o1SubValue = new NativeLuaTable();
            o1SubValue["InObj"] = true;
            o1SubValue["InBoth"] = 3;
            o1Serialised["Value1"] = 43;
            o1Serialised["Value2"] = 10;
            o1Serialised["Value3"] = o1SubValue;
            var o1SubTable2 = new NativeLuaTable();
            o1SubTable2["Value"] = 1;
            o1Serialised["Value4"] = o1SubTable2;

            var o1DefaultSerialized = new NativeLuaTable();
            var o1DefaultSubValue = new NativeLuaTable();
            o1DefaultSubValue["InBoth"] = 5;
            o1DefaultSubValue["InDef"] = true;
            o1DefaultSerialized["Value1"] = 35;
            o1DefaultSerialized["Value3"] = o1DefaultSubValue;
            var o1DefaultSubTable2 = new NativeLuaTable();
            o1DefaultSubTable2["Value"] = 1;
            o1DefaultSerialized["Value4"] = o1DefaultSubTable2;

            var allData = new NativeLuaTable();
            allData[id1] = o1Serialised;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(allData);
            this.serializerMock.Setup(s => s.Serialize(o1Default)).Returns(o1DefaultSerialized);
            NativeLuaTable deserializedId1Table = null;
            this.serializerMock
                .Setup(s => s.Deserialize<IIdObject<string>>(It.IsAny<NativeLuaTable>()))
                .Callback<NativeLuaTable>((t) => deserializedId1Table = t)
                .Returns(o1);

            // Execute
            this.storeUnderTest.SetDefault(o1Default);
            this.storeUnderTest.LoadFromSaved();

            // Assert
            this.serializerMock.Verify(s => s.Serialize(o1Default), Times.Once);
            this.serializerMock.Verify(s => s.Serialize(o1), Times.Never);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()), Times.Never);
            Assert.IsNotNull(deserializedId1Table);
            Assert.AreEqual(43, deserializedId1Table["Value1"]);
            Assert.AreEqual(10, deserializedId1Table["Value2"]);
            Assert.IsTrue(deserializedId1Table["Value3"] is NativeLuaTable);
            var value3 = deserializedId1Table["Value3"] as NativeLuaTable;
            Assert.AreEqual(true, value3["InObj"]);
            Assert.AreEqual(true, value3["InDef"]);
            Assert.AreEqual(3, value3["InBoth"]);

            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(o1), Times.Never);
        }

        [TestMethod]
        [ExpectedException(typeof(DefaultObjectAlreadySetException))]
        public void TestObjectStoreWithDefaultsSetDefaultWithAlreadySetIdThrows()
        {
            // Set up
            var id1 = "obj1";
            var o1Default = MakeObject(id1);
            var o1Default2 = MakeObject(id1);
            var o1DefaultSerialized = new NativeLuaTable();
            o1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(o1Default)).Returns(o1DefaultSerialized);

            // Execute
            this.storeUnderTest.SetDefault(o1Default);
            this.storeUnderTest.SetDefault(o1Default2);
        }

        [TestMethod]
        [ExpectedException(typeof(DefaultObjectCanNotBeSetAfterLoadException))]
        public void TestObjectStoreWithDefaultsSetDefaultAfterLoadThrows()
        {
            // Set up
            var id1 = "obj1";
            var o1Default = MakeObject(id1);
            var o1DefaultSerialized = new NativeLuaTable();
            o1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.SetDefault(o1Default);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsGetIds()
        {
            // Set up
            var id1 = "obj1";
            var id2 = "obj2";
            var id3 = "obj3";
            var id4 = "obj4";
            var o1 = MakeObject(id1);
            var o2 = MakeObject(id2);
            var o3 = MakeObject(id3);
            var o3Default = MakeObject(id3);
            var o4Default = MakeObject(id4);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();
            var t3Default = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t1)).Returns(o1);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t2)).Returns(o2);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t3)).Returns(o3);
            this.serializerMock.Setup(s => s.Deserialize<IIdObject<string>>(t3Default)).Returns(o3);
            this.serializerMock.Setup(s => s.Serialize(o3Default)).Returns(t3Default);

            // Execute
            this.storeUnderTest.SetDefault(o3Default);
            this.storeUnderTest.SetDefault(o4Default);
            this.storeUnderTest.LoadFromSaved();
            var idList = this.storeUnderTest.GetIds();

            // Assert
            Assert.AreEqual(4, idList.Count);
            Assert.AreEqual(id1, idList[0]);
            Assert.AreEqual(id2, idList[1]);
            Assert.AreEqual(id3, idList[2]);
            Assert.AreEqual(id4, idList[3]);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsGetAll()
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
        public void TestObjectStorageWithDefaultsGetDefaultWithNoSet()
        {
            // Set up
            var id1 = "obj1";
            var o1Default = MakeObject(id1);
            var o1DefaultSerialized = new NativeLuaTable();
            o1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(o1Default)).Returns(o1DefaultSerialized);

            // Execute
            this.storeUnderTest.SetDefault(o1Default);
            this.storeUnderTest.LoadFromSaved();
            var res = this.storeUnderTest.Get(id1);

            // Assert
            Assert.AreEqual(o1Default, res);
            this.serializerMock.Verify(s => s.Serialize(o1Default), Times.Never);
            this.serializerMock.Verify(s => s.Deserialize<IIdObject<string>>(It.IsAny<NativeLuaTable>()), Times.Never);
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(It.IsAny<IIdObject<string>>()), Times.Never);
        }

        [TestMethod]
        public void TestObjectStoreWithDefaultsRemove()
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