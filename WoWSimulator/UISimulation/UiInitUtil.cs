namespace WoWSimulator.UISimulation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using UiObjects;
    using XMLHandler;
    using FrameType = XMLHandler.FrameType;

    public class UiInitUtil
    {
        private readonly Dictionary<string, IUIObject> namedObjects;
        private readonly Dictionary<string, LayoutFrameType> xmlTemplates;
        private readonly Dictionary<string, FontType> fontTemplates; 
        private readonly Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>> wrappers;
        private readonly List<IFrame> frames;
        private readonly List<string> ignoredTemplates = new List<string>();

        public UiInitUtil()
        {
            this.xmlTemplates = new Dictionary<string, LayoutFrameType>();
            this.fontTemplates = new Dictionary<string, FontType>();
            this.namedObjects = new Dictionary<string, IUIObject>();
            this.wrappers = new Dictionary<string, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject>>();
            this.frames = new List<IFrame>();
        }

        public object GetTemplate(string name)
        {
            if (this.xmlTemplates[name] != null)
            {
                return this.xmlTemplates[name];
            }
            return this.fontTemplates[name];
        }

        public void AddTempate(FontType obj)
        {
            if (this.fontTemplates.ContainsKey(obj.name))
            {
                throw new UiSimuationException(string.Format("An xml element with name {0} is already loaded.", obj.name));
            }
            this.fontTemplates[obj.name] = obj;
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
            if (xmlInfo.name != null && this.wrappers.ContainsKey(xmlInfo.name))
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

                if (parent is Frame)
                {
                    (parent as Frame).Children.Add(obj as IFrame);
                }
            }
            else if (obj is ILayeredRegion)
            {
                if (parent is Frame)
                {
                    (parent as Frame).Regions.Add(obj as ILayeredRegion);
                }
            }

            return obj;
        }

        private IUIObject Create(LayoutFrameType xml, IRegion parent)
        {
            // Important: Check for the highest level of types first.

            if (xml is ScrollFrameType)
            {
                return new ScrollFrame(this, "scrollFrame", (ScrollFrameType)xml, parent);
            }
            if (xml is GameTooltipType)
            {
                return new GameTooltip(this, "gameTooltip", (GameTooltipType)xml, parent);
            }
            if (xml is CheckButtonType)
            {
                return new CheckButton(this, "checkButton", (CheckButtonType)xml, parent);
            }
            if (xml is ButtonType)
            {
                return new Button(this, "button", (ButtonType)xml, parent);
            }
            if (xml is EditBoxType)
            {
                return new EditBox(this, "editBox", (EditBoxType)xml, parent);
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

        public void TriggerEvent(string eventName, params object[] eventArgs)
        {
            Func<int, object> Get = (index) => eventArgs != null && index < eventArgs.Length ? eventArgs[index] : null;

            foreach (var frame in this.frames.Where(f => f.HasScript(FrameHandler.OnEvent) && f.IsEventRegistered(eventName)).ToList())
            {
                frame.GetScript(FrameHandler.OnEvent)(null, eventName, Get(0), Get(1), Get(2));
            }
        }

        public void TriggerEvent(object eventName, params object[] eventArgs)
        {
            this.TriggerEvent(eventName.ToString(), eventArgs);
        }

        public void UpdateTick(float elapsed)
        {
            foreach (var frame in this.frames.Where(f => f.HasScript(FrameHandler.OnUpdate)))
            {
                frame.GetScript(FrameHandler.OnUpdate)(null, elapsed, null, null, null);
            }
        }

        public IEnumerable<IFrame> GetVisibleFrames()
        {
            return this.frames.Where(f => f.IsVisible());
        }
    }
}