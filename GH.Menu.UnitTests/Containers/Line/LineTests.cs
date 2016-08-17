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
        public void LineSetPositionTestWithFlexibleHeight()
        {
            Assert.Fail();
        }

        /// <summary>
        /// Tests all 29 combinations of flexible, static or skipped blocks for each of the three.
        /// </summary>
        [TestMethod]
        public void LineSetPositionTestWithAllWidthCombinations()
        {
            this.PerformSetPositionTestWithWidth(Tdq(  10,   20,   30), Td( 0, 40, 70), Td(10, 20, 30));
            this.PerformSetPositionTestWithWidth(Tdq(   0,   20,   30), Td( 0, 40, 70), Td( 0, 20, 30));
            this.PerformSetPositionTestWithWidth(Tdq(null,   20,   30), Td( 0, 40, 70), Td(35, 20, 30));
            this.PerformSetPositionTestWithWidth(Tdq(  10,    0,   30), Td( 0,  0, 70), Td(10,  0, 30));
            this.PerformSetPositionTestWithWidth(Tdq(   0,    0,   30), Td( 0,  0, 70), Td( 0,  0, 30));
            this.PerformSetPositionTestWithWidth(Tdq(null,    0,   30), Td( 0,  0, 70), Td(65,  0, 30));
            this.PerformSetPositionTestWithWidth(Tdq(  10, null,   30), Td( 0, 35, 70), Td(10, 30, 30));
            this.PerformSetPositionTestWithWidth(Tdq(  20, null,   10), Td( 0, 25, 90), Td(20, 50, 10)); // Extra
            this.PerformSetPositionTestWithWidth(Tdq(   0, null,   30), Td( 0, 35, 70), Td( 0, 30, 30));
            this.PerformSetPositionTestWithWidth(Tdq(null, null,   20), Td( 0, 35, 80), Td(30, 30, 20));
            this.PerformSetPositionTestWithWidth(Tdq(null, null,   40), Td( 0, 45, 60), Td(40, 10, 40)); // Extra
            this.PerformSetPositionTestWithWidth(Tdq(  10,   20,    0), Td( 0, 40,  0), Td(10, 20,  0));
            this.PerformSetPositionTestWithWidth(Tdq(   0,   20,    0), Td( 0, 40,  0), Td( 0, 20,  0));
            this.PerformSetPositionTestWithWidth(Tdq(null,   20,    0), Td( 0, 40,  0), Td(35, 20,  0));
            this.PerformSetPositionTestWithWidth(Tdq(  10,    0,    0), Td( 0,  0,  0), Td(10,  0,  0));
            this.PerformSetPositionTestWithWidth(Tdq(   0,    0,    0), Td( 0,  0,  0), Td( 0,  0,  0));
            this.PerformSetPositionTestWithWidth(Tdq(null,    0,    0), Td( 0,  0,  0), Td(100, 0,  0));
            this.PerformSetPositionTestWithWidth(Tdq(  10, null,    0), Td( 0, 15,  0), Td(10, 70,  0));
            this.PerformSetPositionTestWithWidth(Tdq(   0, null,    0), Td( 0,  0,  0), Td( 0,100,  0));
            this.PerformSetPositionTestWithWidth(Tdq(null, null,    0), Td( 0, 35,  0), Td(30, 30,  0));
            this.PerformSetPositionTestWithWidth(Tdq(  10,   20, null), Td( 0, 40, 65), Td(10, 20, 35));
            this.PerformSetPositionTestWithWidth(Tdq(   0,   20, null), Td( 0, 40, 65), Td( 0, 20, 35));
            this.PerformSetPositionTestWithWidth(Tdq(null,   20, null), Td( 0, 40, 65), Td(35, 20, 35));
            this.PerformSetPositionTestWithWidth(Tdq(  10,    0, null), Td( 0,  0, 15), Td(10,  0, 85));
            this.PerformSetPositionTestWithWidth(Tdq(   0,    0, null), Td( 0,  0,  0), Td( 0,  0,100));
            this.PerformSetPositionTestWithWidth(Tdq(null,    0, null), Td( 0, 0,52.5), Td(47.5,0,47.5));
            this.PerformSetPositionTestWithWidth(Tdq(  10, null, null), Td( 0, 35, 70), Td(10, 30, 30));
            this.PerformSetPositionTestWithWidth(Tdq(  40, null, null), Td( 0, 45, 60), Td(40, 10, 40)); // Extra
            this.PerformSetPositionTestWithWidth(Tdq(   0, null, null), Td( 0, 35, 70), Td( 0, 30, 30));
            this.PerformSetPositionTestWithWidth(Tdq(null, null, null), Td( 0, 35, 70), Td(30, 30, 30));
        }

        private void PerformSetPositionTestWithWidth(Tuple<double?, double?, double?> widths, Tuple<double, double, double> expectedXOff, Tuple<double, double, double> expectedWidths)
        {
            // Setup
            this.lineUnderTest = new Line(new Mock<IWrapper>().Object);
            var profiles = new List<LineProfile>();
            var dimensionsMapping = new Dictionary<ObjectAlign, double?>();
            dimensionsMapping.Add(ObjectAlign.l, widths.Item1);
            dimensionsMapping.Add(ObjectAlign.c, widths.Item2);
            dimensionsMapping.Add(ObjectAlign.r, widths.Item3);

            var blockMocks = new Dictionary<ObjectAlign, Mock<IAlignedBlock>>();
            var menuHandlerMock = SetUpMenuHandlerMock(profiles, ((lineProfile, mock) =>
            {
                var align = lineProfile.SingleOrDefault()?.align;
                if (align == null)
                {
                    return;
                }

                blockMocks.Add((ObjectAlign)align, mock);
                mock.Setup(e => e.GetPreferredWidth()).Returns(dimensionsMapping[(ObjectAlign)align]);
                mock.Setup(e => e.GetPreferredHeight()).Returns(15);
            }));

            var profile = new LineProfile();
            GenerateAndAddObjectProfile(profile, ObjectAlign.l, widths.Item1 == 0);
            GenerateAndAddObjectProfile(profile, ObjectAlign.c, widths.Item2 == 0);
            GenerateAndAddObjectProfile(profile, ObjectAlign.r, widths.Item3 == 0);
            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);

            var parentMock = new Mock<IFrame>();

            // Act
            this.lineUnderTest.SetPosition(parentMock.Object, 0, 0, 100, 15);

            // Assert
            foreach (var blockMockPair in blockMocks)
            {
                blockMockPair.Value.Verify(
                    b =>
                    b.SetPosition(
                        It.IsAny<IFrame>(),
                        It.IsAny<double>(),
                        It.IsAny<double>(),
                        It.IsAny<double>(),
                        It.IsAny<double>()),
                    Times.Once(),
                    $"No invocations for align '{blockMockPair.Key}'. Widths: {widths.Item1}, {widths.Item2}, {widths.Item3}.");
                var xOff = SelectFromTuple(expectedXOff, blockMockPair.Key);
                var width = SelectFromTuple(expectedWidths, blockMockPair.Key);
                blockMockPair.Value.Verify(
                    b =>
                    b.SetPosition(
                        this.lineFrameMock.Object,
                        xOff,
                        0,
                        width,
                        15),
                    Times.Once(),
                    $"Incorrect values for align '{blockMockPair.Key}'. Widths: {widths.Item1}, {widths.Item2}, {widths.Item3}."
                    + $"\nExpected (Object, {xOff}, 0, {width}, 15)");
            }
        }

        private static Tuple<double, double, double> Td(double v1, double v2, double v3)
        {
            return new Tuple<double, double, double>(v1, v2, v3);
        }

        private static Tuple<double?, double?, double?> Tdq(double? v1, double? v2, double? v3)
        {
            return new Tuple<double?, double?, double?>(v1, v2, v3);
        }

        private static double SelectFromTuple(Tuple<double, double, double> tuple, ObjectAlign align)
        {
            switch (align)
            {
                case ObjectAlign.l:
                    return tuple.Item1;
                case ObjectAlign.c:
                    return tuple.Item2;
                default:
                    return tuple.Item3;
            }
        }

        private static void GenerateAndAddObjectProfile(LineProfile parentProfile, ObjectAlign align, bool skip)
        {
            if (!skip)
            {
                parentProfile.Add(GenerateObjectProfile(align));
            }
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
