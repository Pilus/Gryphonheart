namespace GH.Menu.UnitTests.Containers.Page
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Page;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class PageTests
    {
        private Page pageUnderTest;
        private Mock<IFrame> pageFrameMock;

        [TestInitialize]
        public void TestInitialize()
        {
            var wrapperMock = new Mock<IWrapper>();
            this.pageFrameMock = new Mock<IFrame>();
            var frameProviderMock = new Mock<IFrameProvider>();
            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Frame, "Line1", null, null))
                .Returns(this.pageFrameMock.Object);
            Global.FrameProvider = frameProviderMock.Object;
            Global.Api = new Mock<IApi>().Object;
            this.pageUnderTest = new Page(wrapperMock.Object);
        }
    }
}
