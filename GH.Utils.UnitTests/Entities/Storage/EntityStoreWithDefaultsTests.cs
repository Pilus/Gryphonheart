namespace GH.Utils.UnitTests.Entities.Storage
{
    using System;
    using CsLuaFramework;
    using GH.Utils;
    using GH.Utils.Entities;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Entities.Subscriptions;
    using Lua;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class EntityStoreWithDefaultsTests
    {
        private Mock<ISerializer> serializerMock;
        private Mock<ISavedDataHandler> savedDataHandlerMock;
        private Mock<IEntityUpdateSubscriptionCenter<IIdEntity<string>, string>> entityUpdateSubCenterMock;
        private EntityStoreWithDefaults<IIdEntity<string>, string> storeUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.serializerMock = new Mock<ISerializer>();
            this.savedDataHandlerMock = new Mock<ISavedDataHandler>();
            this.entityUpdateSubCenterMock = new Mock<IEntityUpdateSubscriptionCenter<IIdEntity<string>, string>>();
            this.storeUnderTest = new EntityStoreWithDefaults<IIdEntity<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object, this.entityUpdateSubCenterMock.Object);
        }

        private static IIdEntity<string> MakeEntity(string id)
        {
            var mock = new Mock<IIdEntity<string>>();
            mock.Setup(o => o.Id).Returns(id);
            return mock.Object;
        }


        [TestMethod]
        public void TestEntityStoreWithDefaultsCstor()
        {
            new EntityStoreWithDefaults<IIdEntity<string>, string>(this.serializerMock.Object, this.savedDataHandlerMock.Object);
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsGet()
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
        [ExpectedException(typeof(NoDefaultValueFoundException))]
        public void TestEntityStoreWithDefaultsGetWithWrongIdThrows()
        {
            // Set up
            var savedData = new NativeLuaTable();
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Get("WrongID");
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsSet()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var dataSet = new NativeLuaTable();
            var e1Serialised = new NativeLuaTable();
            e1Serialised["Value"] = 43;
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
        [ExpectedException(typeof(ArgumentNullException))]
        public void TestEntityStoreWithDefaultsSetThrowsOnNull()
        {
            this.storeUnderTest.Set(null);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void TestEntityStoreWithDefaultsSetDefaultThrowsOnNull()
        {
            this.storeUnderTest.SetDefault(null);
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsSetOverwrites()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var e1New = MakeEntity(id1);
            var savedData = new NativeLuaTable();
            var savedData1 = new NativeLuaTable();
            savedData1["Value"] = 10;
            savedData[id1] = savedData1;
            var e1NewSerialised = new NativeLuaTable();
            e1NewSerialised["Value"] = 43;
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
        public void TestEntityStoreWithDefaultsGetBeforeDataLoadThrows()
        {
            this.storeUnderTest.Get("AnyId");
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsSetDefault()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var e1Default = MakeEntity(id1);
            var e1Serialised = new NativeLuaTable();
            var e1SubValue = new NativeLuaTable();
            e1SubValue["InEntity"] = true;
            e1SubValue["InBoth"] = 3;
            e1Serialised["Value1"] = 43;
            e1Serialised["Value2"] = 10;
            e1Serialised["Value3"] = e1SubValue;
            var e1SubTable2 = new NativeLuaTable();
            e1SubTable2["Value"] = 1;
            e1Serialised["Value4"] = e1SubTable2;

            var e1DefaultSerialized = new NativeLuaTable();
            var e1DefaultSubValue = new NativeLuaTable();
            e1DefaultSubValue["InBoth"] = 5;
            e1DefaultSubValue["InDef"] = true;
            e1DefaultSerialized["Value1"] = 35;
            e1DefaultSerialized["Value3"] = e1DefaultSubValue;
            var e1DefaultSubTable2 = new NativeLuaTable();
            e1DefaultSubTable2["Value"] = 1;
            e1DefaultSerialized["Value4"] = e1DefaultSubTable2;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(e1)).Returns(e1Serialised);
            this.serializerMock.Setup(s => s.Serialize(e1Default)).Returns(e1DefaultSerialized);
            NativeLuaTable savedId1Table = null;
            this.savedDataHandlerMock
                .Setup(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()))
                .Callback<object, NativeLuaTable>((id, t) => savedId1Table = t);

            // Execute
            this.storeUnderTest.SetDefault(e1Default);
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.Set(e1);

            // Assert
            this.serializerMock.Verify(s => s.Serialize(e1Default), Times.Once);
            this.serializerMock.Verify(s => s.Serialize(e1), Times.Once);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()), Times.Once);
            Assert.IsNotNull(savedId1Table);
            Assert.AreEqual(43, savedId1Table["Value1"]);
            Assert.AreEqual(10, savedId1Table["Value2"]);
            Assert.IsTrue(savedId1Table["Value3"] is NativeLuaTable);
            var value3 = savedId1Table["Value3"] as NativeLuaTable;
            Assert.AreEqual(true, value3["InEntity"]);
            Assert.AreEqual(null, value3["InDef"]);
            Assert.AreEqual(3, value3["InBoth"]);
            
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(e1), Times.Once);
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsLoadsAndMergesWithDefault()
        {
            // Set up
            var id1 = "entity1";
            var e1 = MakeEntity(id1);
            var e1Default = MakeEntity(id1);
            var e1Serialised = new NativeLuaTable();
            var e1SubValue = new NativeLuaTable();
            e1SubValue["InEntity"] = true;
            e1SubValue["InBoth"] = 3;
            e1Serialised["Value1"] = 43;
            e1Serialised["Value2"] = 10;
            e1Serialised["Value3"] = e1SubValue;
            var e1SubTable2 = new NativeLuaTable();
            e1SubTable2["Value"] = 1;
            e1Serialised["Value4"] = e1SubTable2;

            var e1DefaultSerialized = new NativeLuaTable();
            var e1DefaultSubValue = new NativeLuaTable();
            e1DefaultSubValue["InBoth"] = 5;
            e1DefaultSubValue["InDef"] = true;
            e1DefaultSerialized["Value1"] = 35;
            e1DefaultSerialized["Value3"] = e1DefaultSubValue;
            var e1DefaultSubTable2 = new NativeLuaTable();
            e1DefaultSubTable2["Value"] = 1;
            e1DefaultSerialized["Value4"] = e1DefaultSubTable2;

            var allData = new NativeLuaTable();
            allData[id1] = e1Serialised;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(allData);
            this.serializerMock.Setup(s => s.Serialize(e1Default)).Returns(e1DefaultSerialized);
            NativeLuaTable deserializedId1Table = null;
            this.serializerMock
                .Setup(s => s.Deserialize<IIdEntity<string>>(It.IsAny<NativeLuaTable>()))
                .Callback<NativeLuaTable>((t) => deserializedId1Table = t)
                .Returns(e1);

            // Execute
            this.storeUnderTest.SetDefault(e1Default);
            this.storeUnderTest.LoadFromSaved();

            // Assert
            this.serializerMock.Verify(s => s.Serialize(e1Default), Times.Once);
            this.serializerMock.Verify(s => s.Serialize(e1), Times.Never);
            this.savedDataHandlerMock.Verify(s => s.SetVar(id1, It.IsAny<NativeLuaTable>()), Times.Never);
            Assert.IsNotNull(deserializedId1Table);
            Assert.AreEqual(43, deserializedId1Table["Value1"]);
            Assert.AreEqual(10, deserializedId1Table["Value2"]);
            Assert.IsTrue(deserializedId1Table["Value3"] is NativeLuaTable);
            var value3 = deserializedId1Table["Value3"] as NativeLuaTable;
            Assert.AreEqual(true, value3["InEntity"]);
            Assert.AreEqual(true, value3["InDef"]);
            Assert.AreEqual(3, value3["InBoth"]);

            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(e1), Times.Never);
        }

        [TestMethod]
        [ExpectedException(typeof(DefaultEntityAlreadySetException))]
        public void TestEntityStoreWithDefaultsSetDefaultWithAlreadySetIdThrows()
        {
            // Set up
            var id1 = "entity1";
            var e1Default = MakeEntity(id1);
            var e1Default2 = MakeEntity(id1);
            var e1DefaultSerialized = new NativeLuaTable();
            e1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(e1Default)).Returns(e1DefaultSerialized);

            // Execute
            this.storeUnderTest.SetDefault(e1Default);
            this.storeUnderTest.SetDefault(e1Default2);
        }

        [TestMethod]
        [ExpectedException(typeof(DefaultEntityCanNotBeSetAfterLoadException))]
        public void TestEntityStoreWithDefaultsSetDefaultAfterLoadThrows()
        {
            // Set up
            var id1 = "entity1";
            var e1Default = MakeEntity(id1);
            var e1DefaultSerialized = new NativeLuaTable();
            e1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());

            // Execute
            this.storeUnderTest.LoadFromSaved();
            this.storeUnderTest.SetDefault(e1Default);
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsGetIds()
        {
            // Set up
            var id1 = "entity1";
            var id2 = "entity2";
            var id3 = "entity3";
            var id4 = "entity4";
            var e1 = MakeEntity(id1);
            var e2 = MakeEntity(id2);
            var e3 = MakeEntity(id3);
            var e3Default = MakeEntity(id3);
            var o4Default = MakeEntity(id4);
            var t1 = new NativeLuaTable();
            var t2 = new NativeLuaTable();
            var t3 = new NativeLuaTable();
            var t3Default = new NativeLuaTable();

            var savedData = new NativeLuaTable();
            savedData[id1] = t1;
            savedData[id2] = t2;
            savedData[id3] = t3;
            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(savedData);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t1)).Returns(e1);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t2)).Returns(e2);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t3)).Returns(e3);
            this.serializerMock.Setup(s => s.Deserialize<IIdEntity<string>>(t3Default)).Returns(e3);
            this.serializerMock.Setup(s => s.Serialize(e3Default)).Returns(t3Default);

            // Execute
            this.storeUnderTest.SetDefault(e3Default);
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
        public void TestEntityStoreWithDefaultsGetAll()
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
        public void TestEntityStoreWithDefaultsGetDefaultWithNoSet()
        {
            // Set up
            var id1 = "entity1";
            var e1Default = MakeEntity(id1);
            var e1DefaultSerialized = new NativeLuaTable();
            e1DefaultSerialized["Value1"] = 43;

            this.savedDataHandlerMock.Setup(sdh => sdh.GetAll()).Returns(new NativeLuaTable());
            this.serializerMock.Setup(s => s.Serialize(e1Default)).Returns(e1DefaultSerialized);

            // Execute
            this.storeUnderTest.SetDefault(e1Default);
            this.storeUnderTest.LoadFromSaved();
            var res = this.storeUnderTest.Get(id1);

            // Assert
            Assert.AreEqual(e1Default, res);
            this.serializerMock.Verify(s => s.Serialize(e1Default), Times.Never);
            this.serializerMock.Verify(s => s.Deserialize<IIdEntity<string>>(It.IsAny<NativeLuaTable>()), Times.Never);
            this.entityUpdateSubCenterMock.Verify(center => center.TriggerSubscriptionUpdate(It.IsAny<IIdEntity<string>>()), Times.Never);
        }

        [TestMethod]
        public void TestEntityStoreWithDefaultsRemove()
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