﻿namespace WoWSimulator.UISimulation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using UiObjects;
    using FrameType = FrameType;

    public class UiInitUtil
    {
        private readonly Dictionary<string, IUIObject> namedObjects;
        private readonly Dictionary<string, LayoutFrameType> xmlTemplates;
        private readonly Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>> wrappers;
        private readonly List<IFrame> frames;
        private readonly List<string> ignoredTemplates = new List<string>();

        public UiInitUtil()
        {
            this.xmlTemplates = new CsLuaDictionary<string, LayoutFrameType>();
            this.namedObjects = new CsLuaDictionary<string, IUIObject>();
            this.wrappers = new Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>>();
            this.frames = new List<IFrame>();
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

            var providedInherits = xmlInfo.inherits;
            if (!string.IsNullOrEmpty(providedInherits) && !this.xmlTemplates.ContainsKey(providedInherits))
            {
                // Unknown / non loaded xml template
                if (this.ignoredTemplates.Contains(providedInherits))
                {
                    xmlInfo.inherits = null;
                }
                else
                {
                    throw new UiSimuationException(string.Format("Could not find referenced template '{0}'.", providedInherits));
                }
                
            }

            IUIObject obj;
            if (this.wrappers.ContainsKey(xmlInfo.name))
            {
                obj = this.wrappers[xmlInfo.name](this, xmlInfo, parent);
            }
            else if (!string.IsNullOrEmpty(providedInherits) && this.wrappers.ContainsKey(providedInherits))
            {
                obj = this.wrappers[providedInherits](this, xmlInfo, parent);
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

            if (obj is IFrame)
            {
                this.frames.Add(obj as IFrame);
            }

            return obj;
        }

        private IUIObject Create(LayoutFrameType xml, IRegion parent)
        {
            if (xml is ButtonType)
            {
                return new Button(this, "button", (ButtonType)xml, parent);
            }
            if (xml is FrameType)
            {
                return new Frame(this, "frame", (FrameType) xml, parent);
            }
            if (xml is FontStringType)
            {
                return new FontString(this, "fontString", (FontStringType)xml, parent);
            }
            if (xml is TextureType)
            {
                return new Texture(this, "texture", (TextureType)xml, parent);
            }
            throw new UiSimuationException(string.Format("Unhandled xml type '{0}'.", xml.GetType().Name));
        }

        public void AddWrapper(string frameOrTemplateName, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject> wrapperInit)
        {
            this.wrappers[frameOrTemplateName] = wrapperInit;
        }

        public void AddIgnoredTemplate(string templateName)
        {
            this.ignoredTemplates.Add(templateName);
        }

        public IUIObject GetObjectByName(string name)
        {
            return this.namedObjects.ContainsKey(name) ? this.namedObjects[name] : null;
        }

        public T ConvertEnum<T>(object otherEnum)
        {
            return (T)Enum.Parse(typeof(T), otherEnum.ToString());
        }

        public void TriggerEvent(string eventName, object[] eventArgs)
        {
            Func<int, object> Get = (index) => index < eventName.Length ? eventArgs[index] : null;

            foreach (var frame in this.frames.Where(f => f.HasScript(FrameHandler.OnEvent) && f.IsEventRegistered(eventName)))
            {
                frame.GetScript(FrameHandler.OnEvent)(frame, eventName, Get(0), Get(1), Get(2));
            }
        }

        public void UpdateTick(float elapsed)
        {
            foreach (var frame in this.frames.Where(f => f.HasScript(FrameHandler.OnUpdate)))
            {
                frame.GetScript(FrameHandler.OnUpdate)(frame, elapsed, null, null, null);
            }
        }

        public IEnumerable<IFrame> GetVisibleFrames()
        {
            return this.frames.Where(f => f.IsVisible());
        }
    }
}