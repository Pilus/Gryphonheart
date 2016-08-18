namespace GH.Menu.UnitTests.Containers.Page
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects;
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
            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Frame, "Page1", null, null))
                .Returns(this.pageFrameMock.Object);
            Global.FrameProvider = frameProviderMock.Object;
            Global.Api = new Mock<IApi>().Object;
            this.pageUnderTest = new Page(wrapperMock.Object);
        }

        [TestMethod]
        public void PageTestShow()
        {
            // Act
            this.pageUnderTest.Show();

            // Assert
            this.pageFrameMock.Verify(f => f.Show(), Times.Once());
        }

        [TestMethod]
        public void PageTestHide()
        {
            // Act
            this.pageUnderTest.Hide();

            // Assert
            this.pageFrameMock.Verify(f => f.Hide(), Times.Once());
        }

        [TestMethod]
        public void PageTestPrepare()
        {
            // Setup
            var pageName = "Page name";
            var pageProfile = new PageProfile(pageName)
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var profileList = new List<LineProfile>();
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(profileList, (p, line) => lineMockList.Add(line));

            // Act
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);

            // Assert
            Assert.AreEqual(3, profileList.Count);
            Assert.AreEqual(3, lineMockList.Count);
            Assert.AreEqual(pageName, this.pageUnderTest.Name);

            for (var index = 0; index < lineMockList.Count; index++)
            {
                var lineMock = lineMockList[index];
                var lineProfile = pageProfile[index];

                lineMock.Verify(l => l.Prepare(lineProfile, menuHandlerMock.Object), Times.Once());
            }
        }

        [TestMethod]
        public void PageGetPreferredWidthTestWithNoFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[1].Setup(l => l.GetPreferredWidth()).Returns(90);
            lineMockList[2].Setup(l => l.GetPreferredWidth()).Returns(110);

            // Act
            var preferredWidth = this.pageUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(110, preferredWidth);
        }

        [TestMethod]
        public void PageGetPreferredWidthTestWithOneFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[1].Setup(l => l.GetPreferredWidth()).Returns((double?)null);
            lineMockList[2].Setup(l => l.GetPreferredWidth()).Returns(110);

            // Act
            var preferredWidth = this.pageUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(null, preferredWidth);
        }

        [TestMethod]
        public void PageGetPreferredHeightTestWithNoFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredHeight()).Returns(15);
            lineMockList[1].Setup(l => l.GetPreferredHeight()).Returns(10);
            lineMockList[2].Setup(l => l.GetPreferredHeight()).Returns(20);

            // Act
            var preferredHeight = this.pageUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(15 + 10 + 20 + (2*10), preferredHeight);
        }

        [TestMethod]
        public void PageGetPreferredHeightTestWithOneFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredHeight()).Returns(10);
            lineMockList[1].Setup(l => l.GetPreferredHeight()).Returns((double?)null);
            lineMockList[2].Setup(l => l.GetPreferredHeight()).Returns(15);

            // Act
            var preferredHeight = this.pageUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(null, preferredHeight);
        }

        [TestMethod]
        public void PageTestSetPosition()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile(),
                new LineProfile(),
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredHeight()).Returns(30);
            lineMockList[0].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[1].Setup(l => l.GetPreferredHeight()).Returns((double?)null);
            lineMockList[1].Setup(l => l.GetPreferredWidth()).Returns(90);
            lineMockList[2].Setup(l => l.GetPreferredHeight()).Returns(20);
            lineMockList[2].Setup(l => l.GetPreferredWidth()).Returns((double?)null);
            lineMockList[3].Setup(l => l.GetPreferredHeight()).Returns((double?)null);
            lineMockList[3].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[4].Setup(l => l.GetPreferredHeight()).Returns(10);
            lineMockList[4].Setup(l => l.GetPreferredWidth()).Returns(75);

            var parentMock = new Mock<IFrame>();

            // Act
            this.pageUnderTest.SetPosition(parentMock.Object, 2, 3, 100, 200);

            // Assert
            this.pageFrameMock.Verify(f => f.SetParent(parentMock.Object));
            this.pageFrameMock.Verify(f => f.SetWidth(100));
            this.pageFrameMock.Verify(f => f.SetHeight(200));
            this.pageFrameMock.Verify(f => f.SetPoint(FramePoint.TOPLEFT, parentMock.Object, FramePoint.TOPLEFT, 2, -3));

            lineMockList[0].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 0, 100, 30), Times.Once);
            lineMockList[1].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 40, 100, 50), Times.Once);
            lineMockList[2].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 100, 100, 20), Times.Once);
            lineMockList[3].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 130, 100, 50), Times.Once);
            lineMockList[4].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 190, 100, 10), Times.Once);
        }

        [TestMethod]
        public void PageTestSetPositionWithNoFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredHeight()).Returns(30);
            lineMockList[0].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[1].Setup(l => l.GetPreferredHeight()).Returns(10);
            lineMockList[1].Setup(l => l.GetPreferredWidth()).Returns(90);

            var parentMock = new Mock<IFrame>();

            // Act
            this.pageUnderTest.SetPosition(parentMock.Object, 2, 3, 100, 75);

            // Assert
            this.pageFrameMock.Verify(f => f.SetParent(parentMock.Object));
            this.pageFrameMock.Verify(f => f.SetWidth(100));
            this.pageFrameMock.Verify(f => f.SetHeight(50));
            this.pageFrameMock.Verify(f => f.SetPoint(FramePoint.TOPLEFT, parentMock.Object, FramePoint.TOPLEFT, 2, -3));

            lineMockList[0].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 0, 100, 30), Times.Once);
            lineMockList[1].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 40, 100, 10), Times.Once);
        }

        [TestMethod]
        public void PageTestSetPositionWithOnlyFlexible()
        {
            // Setup
            var pageProfile = new PageProfile()
            {
                new LineProfile(),
                new LineProfile()
            };
            var lineMockList = new List<Mock<ILine>>();
            var menuHandlerMock = SetUpMenuHandlerMock(null, (p, line) => lineMockList.Add(line));
            this.pageUnderTest.Prepare(pageProfile, menuHandlerMock.Object);
            lineMockList[0].Setup(l => l.GetPreferredHeight()).Returns((double?)null);
            lineMockList[0].Setup(l => l.GetPreferredWidth()).Returns(100);
            lineMockList[1].Setup(l => l.GetPreferredHeight()).Returns((double?)null);
            lineMockList[1].Setup(l => l.GetPreferredWidth()).Returns(90);

            var parentMock = new Mock<IFrame>();

            // Act
            this.pageUnderTest.SetPosition(parentMock.Object, 0, 0, 100, 50);

            // Assert
            lineMockList[0].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 0, 100, 20), Times.Once);
            lineMockList[1].Verify(l => l.SetPosition(this.pageFrameMock.Object, 0, 30, 100, 20), Times.Once);
        }

        private static Mock<IMenuHandler> SetUpMenuHandlerMock(List<LineProfile> profilesList = null, Action<LineProfile, Mock<ILine>> lineAction = null)
        {
            var menuHandlerMock = new Mock<IMenuHandler>();
            menuHandlerMock.Setup(mh => mh.CreateRegion(It.IsAny<LineProfile>()))
                .Returns(
                    (IMenuRegionProfile p) =>
                    {
                        profilesList?.Add((LineProfile)p);
                        var line = new Mock<ILine>();
                        lineAction?.Invoke((LineProfile)p, line);
                        return line.Object;
                    });
            var layout = new LayoutSettings();
            layout.objectSpacing = 5;
            layout.lineSpacing = 10;
            menuHandlerMock.Setup(mh => mh.Layout).Returns(layout);

            return menuHandlerMock;
        }
    }
}
