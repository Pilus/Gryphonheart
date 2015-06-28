
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
        public UiInitUtil Util { get; private set; }
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
                case FrameType.Button:
                    xml = new ButtonType();
                    break;
                case FrameType.EditBox:
                    xml = new EditBoxType();
                    break;
                default:
                    throw new UiSimuationException(string.Format("Unhandled frame type {0}.", frameType));
            }
            xml.inherits = inherits;
            xml.name = name;
            xml.Items = new object[]{};
            return this.Util.CreateObject(xml, parent);
        }

        private NativeLuaTable currentMenu;
        public IUIObject GetMouseFocus()
        {
            throw new NotImplementedException();
        }
        public void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode, double autoHideDelay)
        {
            this.currentMenu = menuList;
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode, double autoHideDelay)
        {
            this.EasyMenu(menuList, frame, this.Util.GetObjectByName(anchor) as IFrame, x, y, displayMode, autoHideDelay);
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode)
        {
            this.EasyMenu(menuList, frame, anchor, x, y, displayMode, 0);
        }

        public void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode)
        {
            this.EasyMenu(menuList, frame, this.Util.GetObjectByName(anchor) as IFrame, x, y, displayMode, 0);
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
            this.Util.TriggerEvent(eventName.ToString(), eventArgs);
        }

        public void TriggerHandler(object handler, params object[] args)
        {
            throw new NotImplementedException();
        }


        public void Click(string text)
        {
            var button = (IButton)this.Util.GetVisibleFrames()
                .FirstOrDefault(b => b is IButton && (b as IButton).GetText().Equals(text));
            if (button != null)
            {
                button.Click();
                return;
            }

            if (this.currentMenu != null)
            {
                var found = false;
                Table.Foreach(this.currentMenu, (key, value) =>
                {
                    if (found) return;
                    if (!(value is NativeLuaTable)) return;

                    var t = (NativeLuaTable) value;
                    if (!t["text"].Equals(text)) return;

                    if (t["menuList"] is NativeLuaTable)
                    {
                        this.currentMenu = (t["menuList"] as NativeLuaTable);
                    }
                    else if (t["func"] is Action)
                    {
                        (t["func"] as Action)();
                    }
                    found = true;
                });
                if (found) return;
            }

            throw new UiSimuationException(string.Format("Could not find element matching text '{0}' to click on.", text));
        }
    }
}
