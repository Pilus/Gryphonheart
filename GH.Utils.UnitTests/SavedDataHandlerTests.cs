namespace GH.Utils.UnitTests
{
    using BlizzardApi.Global;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GH.Utils;
    using Lua;
    using Moq;

    [TestClass]
    public class SavedDataHandlerTests
    {
        private NativeLuaTable dataSetInGlobal;
        private string indexOfDataSet = "MyData";
        private string subIndex = "SubSet1";

        [TestInitialize]
        public void TestInitialize()
        {
            this.dataSetInGlobal = new NativeLuaTable {[this.subIndex] = new NativeLuaTable()};
            var globalApiMock = new Mock<IApi>();
            globalApiMock.Setup(api => api.GetGlobal(this.indexOfDataSet)).Returns(this.dataSetInGlobal);
            globalApiMock.Setup(api => api.SetGlobal(this.indexOfDataSet, this.dataSetInGlobal));
            Global.Api = globalApiMock.Object;
        }

        [TestMethod]
        public void TestSavedDataHandlerGetVarWithoutSubIndex()
        {
            // Setup
            var expectedTable = new NativeLuaTable();
            this.dataSetInGlobal["index"] = expectedTable;
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet);

            // Act
            var actualTable = dataHandlerUnderTest.GetVar("index");

            // Assert
            Assert.AreEqual(expectedTable, actualTable);
        }

        [TestMethod]
        public void TestSavedDataHandlerGetVarWithSubIndex()
        {
            // Setup
            var expectedTable = new NativeLuaTable();
            ((NativeLuaTable)this.dataSetInGlobal[this.subIndex])["index"] = expectedTable;
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet, this.subIndex);

            // Act
            var actualTable = dataHandlerUnderTest.GetVar("index");

            // Assert
            Assert.AreEqual(expectedTable, actualTable);
        }

        [TestMethod]
        public void TestSavedDataHandlerSetVarWithoutSubIndex()
        {
            // Setup
            var expectedTable = new NativeLuaTable();
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet);

            // Act
            dataHandlerUnderTest.SetVar("index", expectedTable);

            // Assert
            Assert.AreEqual(expectedTable, this.dataSetInGlobal["index"]);
        }

        [TestMethod]
        public void TestSavedDataHandlerSetVarWithSubIndex()
        {
            // Setup
            var expectedTable = new NativeLuaTable();
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet, this.subIndex);

            // Act
            dataHandlerUnderTest.SetVar("index", expectedTable);

            // Assert
            Assert.AreEqual(expectedTable, ((NativeLuaTable)this.dataSetInGlobal[this.subIndex])["index"]);
        }

        [TestMethod]
        public void TestSavedDataHandlerGetAllWithoutSubIndex()
        {
            // Setup
            var expectedTable1 = new NativeLuaTable();
            var expectedTable2 = new NativeLuaTable();
            this.dataSetInGlobal["index1"] = expectedTable1;
            this.dataSetInGlobal["index2"] = expectedTable2;
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet);

            // Act
            var actualTable = dataHandlerUnderTest.GetAll();

            // Assert
            Assert.AreEqual(expectedTable1, actualTable["index1"]);
            Assert.AreEqual(expectedTable2, actualTable["index2"]);
        }

        [TestMethod]
        public void TestSavedDataHandlerGetAllWithSubIndex()
        {
            // Setup
            var expectedTable1 = new NativeLuaTable();
            var expectedTable2 = new NativeLuaTable();
            ((NativeLuaTable)this.dataSetInGlobal[this.subIndex])["index1"] = expectedTable1;
            ((NativeLuaTable)this.dataSetInGlobal[this.subIndex])["index2"] = expectedTable2;
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet, this.subIndex);

            // Act
            var actualTable = dataHandlerUnderTest.GetAll();

            // Assert
            Assert.AreEqual(expectedTable1, actualTable["index1"]);
            Assert.AreEqual(expectedTable2, actualTable["index2"]);
        }

        [TestMethod]
        public void TestSavedDataHandlerGetAllWithoutSubIndexWhenNoData()
        {
            // Setup
            var dataHandlerUnderTest = new SavedDataHandler("NewIndex");

            // Act
            var actualTable = dataHandlerUnderTest.GetAll();

            // Assert
            Assert.IsNotNull(actualTable);
        }

        [TestMethod]
        public void TestSavedDataHandlerGetAllWithSubIndexWhenNoData()
        {
            // Setup
            var dataHandlerUnderTest = new SavedDataHandler(this.indexOfDataSet, "NewSubIndex");

            // Act
            var actualTable = dataHandlerUnderTest.GetAll();

            // Assert
            Assert.IsNotNull(actualTable);
        }
    }
}