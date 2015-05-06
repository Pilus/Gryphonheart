
namespace Tests.IntegrationTest.UISimulator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Moq;

    public class SimulatorFrameProvider : IFrameProvider
    {
        private readonly IList<IUIObject> objects;
        
        public SimulatorFrameProvider()
        {
            this.objects = new List<IUIObject>();
        }

        public IUIObject CreateFrame(FrameType frameType)
        {
            return this.CreateFrame(frameType, null, null, null);
        }

        public IUIObject CreateFrame(FrameType frameType, string name)
        {
            return this.CreateFrame(frameType, name, null, null);
        }

        public IUIObject CreateFrame(FrameType frameType, string name, IFrame parent)
        {
            return this.CreateFrame(frameType, name, parent, null);
        }

        public IUIObject CreateFrame(FrameType frameType, string name, IFrame parent, string inherits)
        {
            if (frameType.Equals(FrameType.Frame))
            {
                return MockFrame(name, parent, inherits).Object;
            }
            throw new NotImplementedException();
        }

        public IUIObject GetFrameByGlobalName(string name)
        {
            return this.objects.SingleOrDefault(o => name.Equals(o.GetName()));
        }

        public IUIObject GetMouseFocus()
        {
            throw new NotImplementedException();
        }

        public IUIObject AddSelfReferencesToNonCsFrameObject(object obj)
        {
            throw new NotImplementedException();
        }

        private Mock<IFrame> MockFrame(string name, IRegion parent, string inherits)
        {
            var mock = new Mock<IFrame>();
            SimulateFrame(mock, name, parent);
            this.objects.Add(mock.Object);
            return mock;
        }

        private Mock<IFontString> MockFontString(IRegion parent, string name, Layer layer, string inherits)
        {
            var mock = new Mock<IFontString>();
            SimulateFontString(mock, parent, name);
            this.objects.Add(mock.Object);
            return mock;
        }

        private Mock<ITexture> MockTexture(IRegion parent, string name)
        {
            var mock = new Mock<ITexture>();
            SimulateTexture(mock, parent, name);
            this.objects.Add(mock.Object);
            return mock;
        }

        private void SimulateFrame(Mock<IFrame> mock, string name, IRegion parent)
        {
            SimulateUIObject(mock.As<IUIObject>(), name);
            SimulateRegion(mock.As<IRegion>(), parent);

            mock.Setup(f => f.CreateFontString())
                .Returns(() => MockFontString(mock.Object, null, Layer.BORDER, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>()))
                .Returns((string n) => MockFontString(mock.Object, n, Layer.BORDER, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>(), It.IsAny<Layer>()))
                .Returns((string n, Layer l) => MockFontString(mock.Object, n, l, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>(), It.IsAny<Layer>(), It.IsAny<string>()))
                .Returns((string n, Layer l, string i) => MockFontString(mock.Object, n, l, i).Object);

            mock.Setup(f => f.CreateTexture())
                .Returns(() => this.MockTexture(mock.Object, null).Object);
            mock.Setup(f => f.CreateTexture(It.IsAny<string>()))
                .Returns((string n) => this.MockTexture(mock.Object, n).Object);
            mock.Setup(f => f.CreateTexture(It.IsAny<string>(), It.IsAny<Layer>()))
                .Returns((string n) => this.MockTexture(mock.Object, n).Object);
            mock.Setup(f => f.CreateTexture(It.IsAny<string>(), It.IsAny<Layer>(), It.IsAny<string>()))
                .Returns((string n) => this.MockTexture(mock.Object, n).Object);
            mock.Setup(f => f.CreateTexture(It.IsAny<string>(), It.IsAny<string>()))
                .Returns((string n) => this.MockTexture(mock.Object, n).Object);
        }

        private void SimulateFontString(Mock<IFontString> mock, IRegion parent, string name)
        {
            SimulateFontInstance(mock.As<IFontInstance>(), parent, name);

            var text = string.Empty;
            mock.Setup(fs => fs.GetText()).Returns(() => text);
            mock.Setup(fs => fs.SetText(It.IsAny<string>())).Callback((string t) => text = t);
            mock.Setup(fs => fs.GetStringWidth()).Returns(() => text.Length*5);
        }

        private void SimulateFontInstance(Mock<IFontInstance> mock, IRegion parent, string name)
        {
            SimulateUIObject(mock.As<IUIObject>(), name);
            SimulateRegion(mock.As<IRegion>(), parent);
        }

        private void SimulateTexture(Mock<ITexture> mock, IRegion parent, string name)
        {
            SimulateUIObject(mock.As<IUIObject>(), name);
            SimulateLayeredRegion(mock.As<ILayeredRegion>(), parent);
        }

        private void SimulateLayeredRegion(Mock<ILayeredRegion> mock, IRegion parent)
        {
            this.SimulateRegion(mock.As<IRegion>(), parent);
        }

        private void SimulateUIObject(Mock<IUIObject> mock, string name)
        {
            mock.Setup(f => f.GetName()).Returns(() => name);
        }

        private void SimulateRegion(Mock<IRegion> mock, IRegion parent)
        {
            mock.Setup(f => f.GetParent()).Returns(() => parent);
            mock.Setup(f => f.SetParent(It.IsAny<IRegion>())).Callback((IRegion r) => parent = r);
        }
    }
}
