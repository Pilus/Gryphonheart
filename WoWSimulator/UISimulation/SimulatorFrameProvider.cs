
namespace WoWSimulator.UISimulation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;
    using Moq;
    using XMLHandler;
    using ObjFrameType = FrameType;

    public class SimulatorFrameProvider : ISimulatorFrameProvider
    {
        private readonly IList<IUIObject> objects;
        private readonly EventHandler eventHandler;
        public readonly UiInitUtil Util;
        private readonly List<string> xmlFiles;

        public SimulatorFrameProvider()
        {
            this.objects = new List<IUIObject>();
            this.eventHandler = new EventHandler();
            this.Util = new UiInitUtil();
            this.xmlFiles = new List<string>();
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
            LayoutFrameType xml;
            switch (frameType)
            {
                case FrameType.Frame:
                    xml = new ObjFrameType();
                    break;
                //case FrameType.Button:
                default:
                    throw new UiSimuationException(string.Format("Unhandled frame type {0}.", frameType));
            }
            xml.inherits = inherits;
            xml.name = name;
            xml.Items = new object[]{};
            return this.Util.CreateObject(xml, parent);
        }

        public IUIObject GetMouseFocus()
        {
            throw new NotImplementedException();
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


        public void LoadXmlFile(string path)
        {
            this.xmlFiles.Add(path);
        }

        public void LoadXmlFiles()
        {
            foreach (var xmlFilePath in this.xmlFiles)
            {
                var ui = XmlUiLoader.Load(xmlFilePath);
                var items = ui.Items.OfType<LayoutFrameType>().ToList();

                foreach (var obj in items.Where(item => item.@virtual))
                {
                    this.Util.AddTempate(obj);
                }


                foreach (var obj in items.Where(item => !item.@virtual))
                {
                    this.Util.CreateObject(obj);
                }
            }
        }

        public void TriggerEvent(object eventName, params object[] eventArgs)
        {
            //throw new NotImplementedException();
        }

        public void TriggerHandler(object handler, params object[] args)
        {
            throw new NotImplementedException();
        }
    }
}
