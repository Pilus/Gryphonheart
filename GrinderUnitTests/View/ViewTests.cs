namespace GrinderUnitTests.View
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Grinder.View;
    using Grinder.View.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;
    using System.Collections.Generic;

    [TestClass]
    public class ViewTests
    {
        private static string TrackingRowTemplateXmlName = "GrinderTrackingRowTemplate";
        private Mock<IApi> apiMock;
        private Mock<IGrinderFrame> frameMock;

        [TestInitialize]
        public void TestInitialize()
        {
            this.apiMock = new Mock<IApi>();
            Global.Api = this.apiMock.Object;
            ApplyMockGlobalGetSet(this.apiMock);

            this.frameMock = new Mock<IGrinderFrame>();
            Global.Api.SetGlobal("GrinderFrame", this.frameMock.Object);
        }

        [TestMethod]
        public void ViewShowsGrinderFrameOnInit()
        {
            var viewUnderTest = new View();

            this.frameMock.Verify(f => f.Show(), Times.Once);
            this.frameMock.Verify(f => f.Hide(), Times.Never);
        }

        [TestMethod]
        public void ViewRegistersTrackingButtonClickWhenProvided()
        {
            var buttonMock = new Mock<IButton>();
            this.frameMock.SetupGet(frame => frame.TrackButton).Returns(buttonMock.Object);

            var viewUnderTest = new View();

            var invoked = 0;
            Action clickAction = new Action(() => { invoked++; });

            Action<IButton> providedAction = null;
            buttonMock.Setup(f => f.SetScript(ButtonHandler.OnClick, It.IsAny<Action<IButton>>()))
                .Callback((ButtonHandler handler, Action<IButton> action) => providedAction = action);

            viewUnderTest.SetTrackButtonOnClick(clickAction);

            buttonMock.Verify(f => f.SetScript(ButtonHandler.OnClick, It.IsAny<Action<IButton>>()), Times.Once);
            Assert.IsTrue(providedAction != null, "SetScript action not received.");
            providedAction(buttonMock.Object);

            Assert.AreEqual(1, invoked);
        }

        [TestMethod]
        public void ViewAddsTrackingEntityRowsWhenAdded()
        {
            var containerMock = new Mock<IFrame>();
            this.frameMock.SetupGet(frame => frame.TrackingContainer).Returns(containerMock.Object);

            var frameProviderMock = new Mock<IFrameProvider>();
            Global.FrameProvider = frameProviderMock.Object;

            var trackingRowMocks = new List<Mock<IGrinderTrackingRow>>();
            frameProviderMock.Setup(fp => fp.CreateFrame(FrameType.Frame, It.IsAny<string>(), containerMock.Object, TrackingRowTemplateXmlName))
                .Returns(() => {
                    var mock = CreateTrackingRowMock();
                    trackingRowMocks.Add(mock);
                    return mock.Object;
            });

            var viewUnderTest = new View();

            viewUnderTest.AddTrackingEntity(new Mock<IEntityId>().Object, "EntityA", "IconA");
            viewUnderTest.AddTrackingEntity(new Mock<IEntityId>().Object, "EntityB", "IconB");
            viewUnderTest.AddTrackingEntity(new Mock<IEntityId>().Object, "EntityC", "IconC");

            Assert.AreEqual(3, trackingRowMocks.Count);
            Assert.AreEqual("EntityA", trackingRowMocks[0].Object.Name.GetText());
            Assert.AreEqual("IconA", trackingRowMocks[0].Object.IconTexture.GetTexture());
            Assert.AreEqual("EntityB", trackingRowMocks[1].Object.Name.GetText());
            Assert.AreEqual("IconB", trackingRowMocks[1].Object.IconTexture.GetTexture());
            Assert.AreEqual("EntityC", trackingRowMocks[2].Object.Name.GetText());
            Assert.AreEqual("IconC", trackingRowMocks[2].Object.IconTexture.GetTexture());

            // TODO: validate anchoring.
        }

        private static Mock<IGrinderTrackingRow> CreateTrackingRowMock()
        {
            var mock = new Mock<IGrinderTrackingRow>();

            var nameMock = MockFontString();
            mock.SetupGet(row => row.Name).Returns(nameMock.Object);
            var amountMock = MockFontString();
            mock.SetupGet(row => row.Amount).Returns(amountMock.Object);
            var velocityMock = MockFontString();
            mock.SetupGet(row => row.Velocity).Returns(velocityMock.Object);
            var iconTextureMock = MockTexture();
            mock.SetupGet(row => row.IconTexture).Returns(iconTextureMock.Object);

            return mock;
        }

        private static Mock<IFontString> MockFontString()
        {
            string text = string.Empty;
            var mock = new Mock<IFontString>();
            mock.Setup(fs => fs.SetText(It.IsAny<string>()))
                .Callback((string s) => text = s);
            mock.Setup(fs => fs.GetText())
                .Returns(() => text);
            return mock;
        }

        private static Mock<ITexture> MockTexture()
        {
            string texture = string.Empty;
            var mock = new Mock<ITexture>();
            mock.Setup(fs => fs.SetTexture(It.IsAny<string>()))
                .Callback((string s) => texture = s);
            mock.Setup(fs => fs.GetTexture())
                .Returns(() => texture);
            return mock;
        }

        private static void ApplyMockGlobalGetSet(Mock<IApi> apiMock)
        {
            var globalObjects = new CsLuaDictionary<string, object>();

            apiMock.Setup(api => api.SetGlobal(It.IsAny<string>(), It.IsAny<object>()))
                .Callback((string key, object obj) => { globalObjects[key] = obj; });
            apiMock.Setup(api => api.GetGlobal(It.IsAny<string>()))
                .Returns((string key) => globalObjects.ContainsKey(key) ? globalObjects[key] : null);
        }
    }
}
