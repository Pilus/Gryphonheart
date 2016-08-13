namespace GH.Menu.UnitTests.Containers.AlignedBlock
{
    using System;
    using System.Linq;
    using System.Net;

    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Containers.Line;
    using GH.Menu.Objects;

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class AlignedBlockTests
    {
        private AlignedBlock alignedBlockUnderTest;

        private Mock<IFrame> blockFrameMock;

        [TestInitialize]
        public void TestInitialize()
        {
            var wrapperMock = new Mock<IWrapper>();
            this.blockFrameMock = new Mock<IFrame>();
            var frameProviderMock = new Mock<IFrameProvider>();
            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Frame, "AlignedBlock1", null, null))
                .Returns(this.blockFrameMock.Object);
            Global.FrameProvider = frameProviderMock.Object;
            Global.Api = new Mock<IApi>().Object;
            this.alignedBlockUnderTest = new AlignedBlock(wrapperMock.Object);
        }

        [TestMethod]
        public void GetPreferredWidthTest()
        {
            // Setup
            this.SetUpWithElements(5, GenerateElement(20,15).Object, GenerateElement(25,10).Object, GenerateElement(10, 20).Object);

            // Act
            var preferredWidth = this.alignedBlockUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(65, preferredWidth);
        }

        [TestMethod]
        public void GetPreferredWidthTestWithFlexibleWidth()
        {
            // Setup
            this.SetUpWithElements(5, GenerateElement(20, 15).Object, GenerateElement(null, 10).Object, GenerateElement(10, 20).Object);

            // Act
            var preferredWidth = this.alignedBlockUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(null, preferredWidth);
        }

        [TestMethod]
        public void GetPreferredHeightTest()
        {
            // Setup
            this.SetUpWithElements(5, GenerateElement(20, 15).Object, GenerateElement(25, 10).Object, GenerateElement(10, 20).Object);

            // Act
            var preferredHeight = this.alignedBlockUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(20, preferredHeight);
        }

        [TestMethod]
        public void GetPreferredHeightTestWithFlexibleHeight()
        {
            // Setup
            this.SetUpWithElements(5, GenerateElement(20, null).Object, GenerateElement(25, 10).Object, GenerateElement(10, 20).Object);

            // Act
            var preferredHeight = this.alignedBlockUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(null, preferredHeight);
        }

        [TestMethod]
        public void SetPositionTest()
        {
            // Setup
            var element1Mock = GenerateElement(20, 15);
            var element2Mock = GenerateElement(25, 10);
            var element3Mock = GenerateElement(10, 20);

            this.SetUpWithElements(5, element1Mock.Object, element2Mock.Object, element3Mock.Object);
            var parentMock = new Mock<IFrame>();

            // Act
            this.alignedBlockUnderTest.SetPosition(parentMock.Object, 10, 15, 65, 20);

            // Assert
            this.blockFrameMock.Verify(f => f.SetPoint(FramePoint.TOPLEFT, parentMock.Object, FramePoint.TOPLEFT, 10, -15));
            element1Mock.Verify(e => e.SetPosition(this.blockFrameMock.Object, 0, 0, 20, 15));
            element2Mock.Verify(e => e.SetPosition(this.blockFrameMock.Object, 25, 0, 25, 10));
            element3Mock.Verify(e => e.SetPosition(this.blockFrameMock.Object, 55, 0, 10, 20));
        }

        private void SetUpWithElements(double objectSpacing, params IMenuObject[] elements)
        {
            var profile = new LineProfile();
            profile.AddRange(elements.Select(e => new Mock<IObjectProfile>().Object));

            var menuHandlerMock = new Mock<IMenuHandler>();
            var layoutSettings = new LayoutSettings() { lineSpacing = 5, objectSpacing = objectSpacing };
            menuHandlerMock.Setup(mh => mh.Layout).Returns(layoutSettings);
            menuHandlerMock.Setup(mh => mh.CreateRegion(It.IsAny<IObjectProfile>()))
                .Returns(new Func<IObjectProfile, IMenuRegion>(p => elements[profile.IndexOf(p)]));

            this.alignedBlockUnderTest.Prepare(profile, menuHandlerMock.Object);
        }

        private static Mock<IMenuObject> GenerateElement(double? width, double? height)
        {
            var elementMock = new Mock<IMenuObject>();
            elementMock.Setup(e => e.GetPreferredWidth()).Returns(width);
            elementMock.Setup(e => e.GetPreferredHeight()).Returns(height);
            return elementMock;
        }
    }
}