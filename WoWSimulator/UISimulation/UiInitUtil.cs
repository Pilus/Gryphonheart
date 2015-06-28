namespace WoWSimulator.UISimulation
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using UiObjects;

    public class UiInitUtil
    {
        private readonly Dictionary<string, IUIObject> namedObjects;
        private readonly Dictionary<string, LayoutFrameType> xmlTemplates;
        private readonly Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>> wrappers;
        private readonly List<IFrame> framesForEvents;
        public UiInitUtil()
        {
            this.xmlTemplates = new CsLuaDictionary<string, LayoutFrameType>();
            this.namedObjects = new CsLuaDictionary<string, IUIObject>();
            this.wrappers = new Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>>();
            this.framesForEvents = new List<IFrame>();
        }

        public LayoutFrameType GetTemplate(string name)
        {
            return this.xmlTemplates[name];
        }

        public void AddTempate(LayoutFrameType obj)
        {
            if (this.xmlTemplates.ContainsKey(obj.name))
            {
                throw new UiSimuationException(string.Format("An xml element with name {0} is already loaded.", obj.name));
            }
            this.xmlTemplates[obj.name] = obj;
        }

        public IUIObject CreateObject(LayoutFrameType xmlInfo)
        {
            return this.CreateObject(xmlInfo, null);
        }

        public IUIObject CreateObject(LayoutFrameType xmlInfo, IRegion parent)
        {
            if (parent == null && xmlInfo is FrameType && !string.IsNullOrEmpty(((FrameType) xmlInfo).parent))
            {
                parent = (IRegion)this.GetObjectByName(((FrameType) xmlInfo).parent);
            }

            if (!string.IsNullOrEmpty(xmlInfo.inherits) && !this.xmlTemplates.ContainsKey(xmlInfo.inherits))
            {
                // Unknown / non loaded xml template
                xmlInfo.inherits = null;
            }

            IUIObject obj;
            if (this.wrappers.ContainsKey(xmlInfo.name))
            {
                obj = this.wrappers[xmlInfo.name](this, xmlInfo, parent);
            }
            else if (xmlInfo.inherits != null && this.wrappers.ContainsKey(xmlInfo.inherits))
            {
                obj = this.wrappers[xmlInfo.inherits](this, xmlInfo, parent);
            }
            else
            {
                obj = this.Create(xmlInfo, parent);
            }

            var name = obj.GetName();
            if (!string.IsNullOrEmpty(name))
            {
                this.namedObjects[name] = obj;
            }
            return obj;
        }

        private IFrame Create(LayoutFrameType xml, IRegion parent)
        {
            if (xml is ButtonType)
            {
                return new Button(this, "frame", (ButtonType)xml, parent);
            }
            if (xml is FrameType)
            {
                return new Frame(this, "frame", (FrameType) xml, parent);
            }
            throw new UiSimuationException("Unhandled xml type.");
        }

        public void AddWrapper(string frameOrTemplateName, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject> wrapperInit)
        {
            wrappers[frameOrTemplateName] = wrapperInit;
        }

        public IUIObject GetObjectByName(string name)
        {
            return this.namedObjects.ContainsKey(name) ? this.namedObjects[name] : null;
        }

        public T ConvertEnum<T>(object otherEnum)
        {
            return (T)Enum.Parse(typeof(T), otherEnum.ToString());
        }

        public void RegisterForEvents(IFrame frame)
        {
            if (!this.framesForEvents.Contains(frame))
            {
                this.framesForEvents.Add(frame);
            }
        }
    }
}