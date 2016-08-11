namespace GH.Utils.UnitTests.AddOnIntegration
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GH.Utils.AddOnIntegration;

    [TestClass]
    public class AddOnRegistryTests
    {
        private AddOnRegistry registryUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.registryUnderTest = new AddOnRegistry();
        }

        [TestMethod]
        public void TestAddOnRegistryIsAddOnLoadedWithLoadedReference()
        {
            this.registryUnderTest.RegisterAddOn(AddOnReference.GH);
            var result = this.registryUnderTest.IsAddOnLoaded(AddOnReference.GH);

            Assert.IsTrue(result, "AddOn should have been flagged as loaded.");
        }

        [TestMethod]
        public void TestAddOnRegistryIsAddOnLoadedWithNonLoadedReference()
        {
            var result = this.registryUnderTest.IsAddOnLoaded(AddOnReference.GHF);

            Assert.IsFalse(result, "AddOn should not have been flagged as loaded.");
        }

        [TestMethod]
        public void TestAddOnRegistryIsAddOnLoadedWithNoneReference()
        {
            var result = this.registryUnderTest.IsAddOnLoaded(AddOnReference.None);

            Assert.IsTrue(result, "The 'None' reference should have been flagged as loaded.");
        }

        [TestMethod]
        [ExpectedException(typeof(AddOnAlreadyRegisteredException))]
        public void TestAddOnRegistryRegisterAddOnWithTheSameReferenceTwiceThrows()
        {
            this.registryUnderTest.RegisterAddOn(AddOnReference.GH);
            this.registryUnderTest.RegisterAddOn(AddOnReference.GH);
        }

        [TestMethod]
        public void TestAddOnRegistryRegisterAddOnWithMultipleAddOns()
        {
            this.registryUnderTest.RegisterAddOn(AddOnReference.GH);
            this.registryUnderTest.RegisterAddOn(AddOnReference.GHI);
        }
    }
}