

namespace Tests.IntegrationTest.GHDTests
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using GHD.Document.Buffer;
    using GHD.Document.Containers;
    using GHD.Document.Data;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    //[TestClass]
    public class PageTests
    {
        [TestInitialize]
        public void TestInitialize()
        {
            new MockGlobal();
        }

        [TestMethod]
        public void InsertsIntoEmptyPage()
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

            var pageUnderTest = new Page(flags, new PageProperties()
            {
                Width = 120,
                Height = 200,
            });


            pageUnderTest.SetCursor(false, cursor.Object);

            var buffer1 = new DocumentBuffer();
            buffer1.Append("This is a test that is longer than one line.", flags);
            pageUnderTest.Insert(buffer1, constraints);

            VerifyLabel(1, "This is a test that is");
            VerifyLabel(2, "longer than one line.");
            VerifyLabel(3, null);
        }

        private static void VerifyLabel(int num, string expectedString)
        {
            var label = CsLuaStatic.Wrapper.WrapGlobalObject<IFontString>("FormattedTextFrame" + num + "Label");
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
