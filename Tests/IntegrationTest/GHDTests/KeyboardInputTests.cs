
namespace Tests.IntegrationTest.GHDTests
{
    using System;
    using BlizzardApi;

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Tests.IntegrationTest.UISimulator;

    [TestClass]
    public class KeyboardInputTests
    {
        [TestInitialize]
        public void TestInitialize()
        {
            new Simulator();
        }

        [TestMethod]
        public void TestMethod1()
        {
        }
    }
}
