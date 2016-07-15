

namespace Tests.IntegrationTest.GHDTests
{
    using BlizzardApi.WidgetInterfaces;
    using GHD.Document.Buffer;
    using GHD.Document.Containers;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using BlizzardApi.Global;
    using CsLuaFramework.Wrapping;

    //[TestClass]
    public class LineTests
    {
        [TestInitialize]
        public void TestInitialize()
        {
            new MockGlobal();
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
    }
}
