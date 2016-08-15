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
            var menuHandlerMock = new Mock<IMenuHandler>();
            var profiles = new List<LineProfile>();
            menuHandlerMock.Setup(mh => mh.CreateRegion(It.IsAny<LineProfile>(), false, typeof(AlignedBlock)))
                .Callback((IMenuRegionProfile p, bool _, Type t) => profiles.Add((LineProfile)p))
                .Returns(new Mock<IAlignedBlock>().Object);
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

        private static IObjectProfile GenerateObjectProfile(ObjectAlign align)
        {
            var objectProfileMock = new Mock<IObjectProfile>();
            objectProfileMock.Setup(p => p.align).Returns(align);
            return objectProfileMock.Object;
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

            this.lineUnderTest.Prepare(profile, menuHandlerMock.Object);
        }

        private static Mock<IMenuObject> GenerateElement(ObjectAlign align)
        {
            var elementMock = new Mock<IMenuObject>();
            elementMock.Setup(e => e.GetAlignment()).Returns(align);
            return elementMock;
        }
    }
}
