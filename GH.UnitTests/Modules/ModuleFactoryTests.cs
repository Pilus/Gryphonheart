
namespace GH.Utils.UnitTests.Modules
{
    using System.Linq;
    using GH.Utils.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GH.Utils.Modules;
    using Moq;

    [TestClass]
    public class ModuleFactoryTests
    {
        private ModuleFactory factoryUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.factoryUnderTest = new ModuleFactory();
        }

        [TestMethod]
        public void TestModuleFactoryGetNonSingletonModule()
        {
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();

            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();

            Assert.AreNotEqual(firstModule, secondModule);
        }

        [TestMethod]
        public void TestModuleFactoryGetSingletonModule()
        {
            var firstModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            var secondModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            Assert.AreEqual(firstModule, secondModule);
        }

        [TestMethod]
        public void TestModuleFactoryLoadSettings()
        {
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            var settingsMock = new Mock<IIdObject<string>>();


            Assert.Fail();
        }

        [TestMethod]
        public void TestModuleFactoryGetDefaultSettingsOfLoadedModules()
        {
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            var defaultSettings = this.factoryUnderTest.GetDefaultSettingsOfLoadedModules().ToArray();

            Assert.AreEqual(2, defaultSettings.Length);
            Assert.IsTrue(defaultSettings.Contains(firstModule.DefaultSettings.Object));
            Assert.IsTrue(defaultSettings.Contains(singletonModule.DefaultSettings.Object));
        }

        [TestMethod]
        public void TestModuleFactoryRegisterForModuleLoadEvents()
        {
            Assert.Fail();
        }
    }
}