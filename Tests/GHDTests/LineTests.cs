

namespace Tests.GHDTests
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;
    using GHD.Document.Elements;
    using GHD.Document.Flags;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class LineTests
    {
        /*
        [TestInitialize]
        public void TestInitialize()
        {
            new MockGlobal();
            var frameProviderMock = new Mock<IFrameProvider>();
            frameProviderMock.Setup(p => p.CreateFrame(FrameType.Frame, It.IsAny<string>())).Returns(() =>
            {
                var frameMock = new Mock<IFrame>();
                frameMock.Setup(f => f.CreateFontString(It.IsAny<string>(), It.IsAny<Layer>())).Returns(() =>
                {
                    var fontStringMock = new Mock<IFontString>();
                    return fontStringMock.Object;
                });
                frameMock.Setup(f => f.CreateFontString()).Returns(() =>
                {
                    var fontStringMock = new Mock<IFontString>();
                    return fontStringMock.Object;
                });
                return frameMock.Object;
            });
            Global.FrameProvider = frameProviderMock.Object;

            var uiParent = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, "UIParent");
            var framesMock = new Mock<IFrames>();
            framesMock.SetupGet(f => f.UIParent).Returns(uiParent);
            Global.Frames = framesMock.Object;
        }

        [TestMethod]
        public void InsertsIntoEmptyLine()
        {
            var flags = new Flags();
            flags.Font = "f";
            flags.FontSize = 12;
            var constraints = new DimensionConstraint()
            {
                MaxHeight = 300,
                MaxWidth = 200,
            };

            var cursor = new Mock<ICursor>();

            var lineUnderTest = new Line(flags);


            lineUnderTest.SetCursor(false, cursor.Object);

            var buffer1 = new DocumentBuffer();
            buffer1.Append("A", flags);
            lineUnderTest.Insert(buffer1, constraints);

            var buffer2 = new DocumentBuffer();
            buffer2.Append("b", flags);
            lineUnderTest.Insert(buffer2, constraints);

            var buffer3 = new DocumentBuffer();
            buffer3.Append("c", flags);
            lineUnderTest.Insert(buffer3, constraints);

            VerifyLabel(1, "Abc");
            VerifyLabel(2, null);
        }

        [TestMethod]
        public void InsertInsideElement()
        {
            var flags = new Flags();
            flags.Font = "f";
            flags.FontSize = 12;
            var constraints = new DimensionConstraint()
            {
                MaxHeight = 300,
                MaxWidth = 200,
            };

            var cursor = new Mock<ICursor>();

            var lineUnderTest = new Line(flags);


            lineUnderTest.SetCursor(false, cursor.Object);

            var buffer1 = new DocumentBuffer();
            buffer1.Append("BeforeAfter", flags);
            lineUnderTest.Insert(buffer1, constraints);

            for (var i = 0; i < 5; i++)
            {
                lineUnderTest.NavigateCursor(NavigationType.Left);
            }

            var buffer2 = new DocumentBuffer();
            buffer2.Append("Middle", flags);
            lineUnderTest.Insert(buffer2, constraints);

            VerifyLabel(1, "BeforeMiddleAfter");
            VerifyLabel(2, null);
        }

        [TestMethod]
        public void InsertsDifferentFlagsInLine()
        {
            var flags = new Flags();
            flags.Font = "f";
            flags.FontSize = 12;
            var constraints = new DimensionConstraint()
            {
                MaxHeight = 300,
                MaxWidth = 200,
            };

            var cursor = new Mock<ICursor>();

            var lineUnderTest = new Line(flags);


            lineUnderTest.SetCursor(false, cursor.Object);

            var buffer1 = new DocumentBuffer();
            buffer1.Append("A", flags);
            lineUnderTest.Insert(buffer1, constraints);

            var buffer2 = new DocumentBuffer();
            buffer2.Append("b", flags);
            lineUnderTest.Insert(buffer2, constraints);

            var flags2 = new Flags();
            flags2.Font = "f";
            flags2.FontSize = 16;
            var buffer3 = new DocumentBuffer();
            buffer3.Append("c", flags2);
            lineUnderTest.Insert(buffer3, constraints);

            VerifyLabel(1, "Ab");
            VerifyLabel(2, "c");
            VerifyLabel(3, null);
        }

        [TestMethod]
        public void InsertDifferentFlagInsideElement()
        {
            var flags = new Flags();
            flags.Font = "f";
            flags.FontSize = 12;
            var constraints = new DimensionConstraint()
            {
                MaxHeight = 300,
                MaxWidth = 200,
            };

            var cursor = new Mock<ICursor>();

            var lineUnderTest = new Line(flags);


            lineUnderTest.SetCursor(false, cursor.Object);

            var buffer1 = new DocumentBuffer();
            buffer1.Append("BeforeAfter", flags);
            lineUnderTest.Insert(buffer1, constraints);

            for (var i = 0; i < 5; i++)
            {
                lineUnderTest.NavigateCursor(NavigationType.Left);
            }

            var flags2 = new Flags();
            flags2.Font = "f";
            flags2.FontSize = 14;
            var buffer2 = new DocumentBuffer();
            buffer2.Append("Middle", flags2);
            lineUnderTest.Insert(buffer2, constraints);

            VerifyLabel(1, "Before");
            VerifyLabel(2, "Middle");
            VerifyLabel(3, "After");
            VerifyLabel(4, null);
        }

        private static void VerifyLabel(int num, string expectedString)
        {
            var label = new Wrapper().Wrap<IFontString>("FormattedTextFrame" + num + "Label");
            if (expectedString == null)
            {
                Assert.AreEqual(null, label);
                return;
            }

            Assert.AreNotEqual(null, label);
            Assert.AreEqual(expectedString, label.GetText());
        }
        //*/
    }
}
