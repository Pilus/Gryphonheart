namespace GH.Menu.UnitTests.Containers.Line
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
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
    public class LineTests
    {
        private Line lineUnderTest;
        private Mock<IFrame> lineFrameMock;

        [TestInitialize]
        public void TestInitialize()
        {
            var wrapperMock = new Mock<IWrapper>();
            this.lineFrameMock = new Mock<IFrame>();
            var frameProviderMock = new Mock<IFrameProvider>();
            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Frame, "Line1", null, null))
                .Returns(this.lineFrameMock.Object);
            Global.FrameProvider = frameProviderMock.Object;
            Global.Api = new Mock<IApi>().Object;
            this.lineUnderTest = new Line(wrapperMock.Object);
        }

        [TestMethod]
        public void LinePrepareTest()
        {
            // Setup
            var profiles = new List<LineProfile>();
            var menuHandlerMock = SetUpMenuHandlerMock(profiles);
            var c1 = GenerateObjectProfile(ObjectAlign.c);
            var c2 = GenerateObjectProfile(ObjectAlign.c);
            var c3 = GenerateObjectProfile(ObjectAlign.c);
            var l1 = GenerateObjectProfile(ObjectAlign.l);
            var l2 = GenerateObjectProfile(ObjectAlign.l);
            var r1 = GenerateObjectProfile(ObjectAlign.r);
            var r2 = GenerateObjectProfile(ObjectAlign.r);

            var profile = new LineProfile()
            {
                c1, l1, c2, r1, c3, r2, l2
            };

            // Act
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            // Assert
            Assert.AreEqual(3, profiles.Count);
            var leftProfile = profiles[0];
            Assert.AreEqual(2, leftProfile.Count);
            Assert.AreEqual(l1, leftProfile[0]);
            Assert.AreEqual(l2, leftProfile[1]);
            var centerProfile = profiles[1];
            Assert.AreEqual(3, centerProfile.Count);
            Assert.AreEqual(c1, centerProfile[0]);
            Assert.AreEqual(c2, centerProfile[1]);
            Assert.AreEqual(c3, centerProfile[2]);
            var rightProfile = profiles[2];
            Assert.AreEqual(2, rightProfile.Count);
            Assert.AreEqual(r1, rightProfile[0]);
            Assert.AreEqual(r2, rightProfile[1]);
        }

        [TestMethod]
        public void LineGetPreferredWidthTestWithNoNull()
        {
            // Setup
            var profiles = new List<LineProfile>();
            var dimensionsMapping = new Dictionary<ObjectAlign, double?>()
                                        {
                                            { ObjectAlign.l, 20 },
                                            { ObjectAlign.c, 30 },
                                            { ObjectAlign.r, 40 },
                                        };
            
            var menuHandlerMock = SetUpMenuHandlerMock(profiles, ((lineProfile, mock) =>
                {
                    mock.Setup(e => e.GetPreferredWidth()).Returns(dimensionsMapping[lineProfile.Single().align]);
                }));

            var profile = new LineProfile()
            {
                GenerateObjectProfile(ObjectAlign.l),
                GenerateObjectProfile(ObjectAlign.c),
                GenerateObjectProfile(ObjectAlign.r),
            };
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            // Act
            var width = this.lineUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(100, width);
        }

        [TestMethod]
        public void LineGetPreferredWidthTestWithNull()
        {
            // Setup
            var profiles = new List<LineProfile>();
            var dimensionsMapping = new Dictionary<ObjectAlign, double?>()
                                        {
                                            { ObjectAlign.l, 20 },
                                            { ObjectAlign.c, null },
                                            { ObjectAlign.r, 40 },
                                        };

            var menuHandlerMock = SetUpMenuHandlerMock(profiles, ((lineProfile, mock) =>
            {
                mock.Setup(e => e.GetPreferredWidth()).Returns(dimensionsMapping[lineProfile.Single().align]);
            }));

            var profile = new LineProfile()
            {
                GenerateObjectProfile(ObjectAlign.l),
                GenerateObjectProfile(ObjectAlign.c),
                GenerateObjectProfile(ObjectAlign.r),
            };
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            // Act
            var width = this.lineUnderTest.GetPreferredWidth();

            // Assert
            Assert.AreEqual(null, width);
        }

        [TestMethod]
        public void LineGetPreferredHeightTestWithNoNull()
        {
            // Setup
            var profiles = new List<LineProfile>();
            var dimensionsMapping = new Dictionary<ObjectAlign, double?>()
                                        {
                                            { ObjectAlign.l, 20 },
                                            { ObjectAlign.c, 40 },
                                            { ObjectAlign.r, 30 },
                                        };

            var menuHandlerMock = SetUpMenuHandlerMock(profiles, ((lineProfile, mock) =>
            {
                mock.Setup(e => e.GetPreferredHeight()).Returns(dimensionsMapping[lineProfile.Single().align]);
            }));

            var profile = new LineProfile()
            {
                GenerateObjectProfile(ObjectAlign.l),
                GenerateObjectProfile(ObjectAlign.c),
                GenerateObjectProfile(ObjectAlign.r),
            };
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            // Act
            var height = this.lineUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(40, height);
        }

        [TestMethod]
        public void LineGetPreferredHeightTestWithNull()
        {
            // Setup
            var profiles = new List<LineProfile>();
            var dimensionsMapping = new Dictionary<ObjectAlign, double?>()
                                        {
                                            { ObjectAlign.l, 20 },
                                            { ObjectAlign.c, null },
                                            { ObjectAlign.r, 40 },
                                        };

            var menuHandlerMock = SetUpMenuHandlerMock(profiles, ((lineProfile, mock) =>
            {
                mock.Setup(e => e.GetPreferredHeight()).Returns(dimensionsMapping[lineProfile.Single().align]);
            }));

            var profile = new LineProfile()
            {
                GenerateObjectProfile(ObjectAlign.l),
                GenerateObjectProfile(ObjectAlign.c),
                GenerateObjectProfile(ObjectAlign.r),
            };
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            // Act
            var height = this.lineUnderTest.GetPreferredHeight();

            // Assert
            Assert.AreEqual(null, height);
        }


        [TestMethod]
        public void LineSetPositionTest()
        {
            Assert.Fail();
        }

        private static Mock<IMenuHandler> SetUpMenuHandlerMock(List<LineProfile> profilesList = null, Action<LineProfile, Mock<IAlignedBlock>> blockAction = null)
        {
            var menuHandlerMock = new Mock<IMenuHandler>();
            menuHandlerMock.Setup(mh => mh.CreateRegion(It.IsAny<LineProfile>(), false, typeof(AlignedBlock)))
                .Returns(
                    (IMenuRegionProfile p, bool _, Type t) =>
                        {
                            profilesList.Add((LineProfile)p);
                            var block = new Mock<IAlignedBlock>();
                            blockAction?.Invoke((LineProfile)p, block);
                            return block.Object;
                        });
            var layout = new LayoutSettings();
            layout.objectSpacing = 5;
            menuHandlerMock.Setup(mh => mh.Layout).Returns(layout);

            return menuHandlerMock;
        }

        private static IObjectProfile GenerateObjectProfile(ObjectAlign align)
        {
            var objectProfileMock = new Mock<IObjectProfile>();
            objectProfileMock.Setup(p => p.align).Returns(align);
            return objectProfileMock.Object;
        }
    }
}
