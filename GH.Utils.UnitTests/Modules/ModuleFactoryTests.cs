
namespace GH.Utils.UnitTests.Modules
{
    using System;
    using System.Collections.Generic;
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
            // Set up
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            var nonSingletonSetting = GenerateSetting(NonSingletonTestModule.SettingId);
            var singletonSetting = GenerateSetting(SingletonTestModule.SettingId);
            var singleton2Setting = GenerateSetting(SingletonTestModule2.SettingId);

            // Act
            this.factoryUnderTest.LoadSettings(new[] {nonSingletonSetting, singletonSetting, singleton2Setting });
            var moduleLoadedAfterSettings = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule2 = this.factoryUnderTest.GetModule<SingletonTestModule2>();

            // Assert
            Assert.AreEqual(singletonSetting, singletonModule.AppliedSettings);
            Assert.AreEqual(nonSingletonSetting, firstModule.AppliedSettings);
            Assert.AreEqual(nonSingletonSetting, secondModule.AppliedSettings);
            Assert.AreEqual(nonSingletonSetting, moduleLoadedAfterSettings.AppliedSettings);
            Assert.AreEqual(singleton2Setting, singletonModule2.AppliedSettings);
        }

        [TestMethod]
        public void TestModuleFactoryGetDefaultSettingsOfLoadedModules()
        {
            // Set up
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule = this.factoryUnderTest.GetModule<SingletonTestModule>();

            // Act
            var defaultSettings = this.factoryUnderTest.GetDefaultSettingsOfLoadedModules().ToArray();

            // Assert
            Assert.AreEqual(2, defaultSettings.Length);
            Assert.IsTrue(defaultSettings.Contains(firstModule.DefaultSettings.Object));
            Assert.IsTrue(defaultSettings.Contains(singletonModule.DefaultSettings.Object));
        }

        [TestMethod]
        public void TestModuleFactoryRegisterForModuleLoadEvents()
        {
            // Setup
            var invocations = new List<IModule>();
            var callback = new Action<IModule>((module =>
            {
                invocations.Add(module);
            }));

            // Act
            this.factoryUnderTest.RegisterForModuleLoadEvents(callback);
            var firstModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var secondModule = this.factoryUnderTest.GetModule<NonSingletonTestModule>();
            var singletonModule = this.factoryUnderTest.GetModule<SingletonTestModule>();
            var singletonModuleAgain = this.factoryUnderTest.GetModule<SingletonTestModule>();

            // Assert
            Assert.IsTrue(invocations.Contains(firstModule));
            Assert.IsTrue(invocations.Contains(secondModule));
            Assert.IsTrue(invocations.Contains(singletonModule));
            Assert.AreEqual(3, invocations.Count);
        }

        private static IIdObject<string> GenerateSetting(string id)
        {
            var settingsMock = new Mock<IIdObject<string>>();
            settingsMock.Setup(s => s.Id).Returns(id);
            return settingsMock.Object;
        }
    }
}