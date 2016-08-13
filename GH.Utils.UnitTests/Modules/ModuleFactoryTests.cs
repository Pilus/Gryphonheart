
namespace GH.Utils.UnitTests.Modules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    using GH.Utils.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GH.Utils.Modules;
    using Moq;

    [TestClass]
    public class ModuleFactoryTests
    {
        private IModuleFactory factoryUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            // Reset the static singleton inside the module factory:
            Type type = typeof(ModuleFactory);
            FieldInfo info = type.GetField("moduleFactory", BindingFlags.NonPublic | BindingFlags.Static);
            info.SetValue(null, null);

            this.factoryUnderTest = ModuleFactory.ModuleFactorySingleton;
        }

        [TestMethod]
        public void TestModuleFactorySingletonProducesTheSameInstace()
        {
            var secondInvocation = ModuleFactory.ModuleFactorySingleton;
            Assert.AreEqual(this.factoryUnderTest, secondInvocation);
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
    }
}