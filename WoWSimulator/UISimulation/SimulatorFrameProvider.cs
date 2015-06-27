
namespace WoWSimulator.UISimulation
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;
    using Moq;

    public class SimulatorFrameProvider : ISimulatorFrameProvider
    {
        private readonly IList<IUIObject> objects;
        private readonly EventHandler eventHandler;

        public SimulatorFrameProvider()
        {
            this.objects = new List<IUIObject>();
            this.eventHandler = new EventHandler();
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
                return this.MockFrame(name, parent, inherits).Object;
            }
            throw new NotImplementedException();
        }


        public IUIObject GetMouseFocus()
        {
            throw new NotImplementedException();
        }


        public void TriggerEvent(object eventName, params object[] eventArgs)
        {
            this.eventHandler.TriggerEvent(eventName, eventArgs);
        }

        public void TriggerHandler(object handler, params object[] args)
        {
            this.eventHandler.TriggerHandler(handler, args);
        }

        private Mock<IFrame> MockFrame(string name, IRegion parent, string inherits)
        {
            var mock = new Mock<IFrame>();
            this.SimulateFrame(mock, name, parent);
            this.objects.Add(mock.Object);
            return mock;
        }

        private Mock<IFontString> MockFontString(IRegion parent, string name, Layer layer, string inherits)
        {
            var mock = new Mock<IFontString>();
            this.SimulateFontString(mock, parent, name);
            this.objects.Add(mock.Object);
            return mock;
        }

        private Mock<ITexture> MockTexture(IRegion parent, string name)
        {
            var mock = new Mock<ITexture>();
            this.SimulateTexture(mock, parent, name);
            this.objects.Add(mock.Object);
            return mock;
        }

        private void SimulateFrame(Mock<IFrame> mock, string name, IRegion parent)
        {
            this.SimulateUIObject(mock.As<IUIObject>(), name);
            this.SimulateRegion(mock.As<IRegion>(), parent);

            mock.Setup(f => f.CreateFontString())
                .Returns(() => this.MockFontString(mock.Object, null, Layer.BORDER, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>()))
                .Returns((string n) => this.MockFontString(mock.Object, n, Layer.BORDER, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>(), It.IsAny<Layer>()))
                .Returns((string n, Layer l) => this.MockFontString(mock.Object, n, l, null).Object);
            mock.Setup(f => f.CreateFontString(It.IsAny<string>(), It.IsAny<Layer>(), It.IsAny<string>()))
                .Returns((string n, Layer l, string i) => this.MockFontString(mock.Object, n, l, i).Object);

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
            this.SimulateFontInstance(mock.As<IFontInstance>(), parent, name);

            var text = string.Empty;
            mock.Setup(fs => fs.GetText()).Returns(() => text);
            mock.Setup(fs => fs.SetText(It.IsAny<string>())).Callback((string t) => text = t);
            mock.Setup(fs => fs.GetStringWidth()).Returns(() => text.Length * 5);
        }

        private void SimulateFontInstance(Mock<IFontInstance> mock, IRegion parent, string name)
        {
            this.SimulateUIObject(mock.As<IUIObject>(), name);
            this.SimulateRegion(mock.As<IRegion>(), parent);
        }

        private void SimulateTexture(Mock<ITexture> mock, IRegion parent, string name)
        {
            this.SimulateUIObject(mock.As<IUIObject>(), name);
            this.SimulateLayeredRegion(mock.As<ILayeredRegion>(), parent);
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



        public void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode, double autoHideDelay)
        {
            throw new NotImplementedException();
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode, double autoHideDelay)
        {
            throw new NotImplementedException();
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode)
        {
            throw new NotImplementedException();
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode)
        {
            throw new NotImplementedException();
        }
    }
}
