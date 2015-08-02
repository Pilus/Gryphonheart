namespace WoWSimulator.UISimulation.UiObjects
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using FrameType = FrameType;

    public class Frame : Region, IFrame
    {
        private int id;
        public readonly List<IFrame> Children = new List<IFrame>();
        private readonly UiInitUtil util;
        private readonly List<string> registeredEvents = new List<string>();

        private readonly Script<FrameHandler, IFrame> scriptHandler;
        private readonly List<ILayeredRegion> regions = new List<ILayeredRegion>();

        public Frame(UiInitUtil util, string objectType, FrameType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
            this.util = util;
            this.scriptHandler = new Script<FrameHandler, IFrame>(this);

            if (!string.IsNullOrEmpty(frameType.inherits))
            {
                this.ApplyType((FrameType)util.GetTemplate(frameType.inherits));
            }
            this.ApplyType(frameType);
        }

        private void ApplyType(FrameType frameType)
        {
            this.id = frameType.id;

            this.ApplyItems(frameType.Items);
            this.ApplyItems(frameType.Items1);
        }

        private void ApplyItems(object[] items)
        {
            if (items == null) return;

            foreach (var item in items)
            {
                if (item is LayoutFrameTypeFrames)
                {
                    this.ApplyFrameTypeFrames(item as LayoutFrameTypeFrames);
                }
                else if (item is LayoutFrameTypeLayers)
                {
                    this.ApplyFrameTypeLayers(item as LayoutFrameTypeLayers);
                }
            }
        }

        private void ApplyFrameTypeFrames(LayoutFrameTypeFrames frames)
        {
            if (frames.Items == null) return;

            foreach (var frameType in frames.Items)
            {
                this.util.CreateObject(frameType, this);
            }
        }

        private void ApplyFrameTypeLayers(LayoutFrameTypeLayers layers)
        {
            if (layers.Layer == null) return;

            foreach (var layer in layers.Layer)
            {
                if (layer.Items == null) continue;

                foreach (var layerItem in layer.Items)
                {
                    this.ApplyLayerItem(layerItem, layer);
                }
            }
        }

        private void ApplyLayerItem(LayoutFrameType item, LayoutFrameTypeLayersLayer layer)
        {
            var obj = (ILayeredRegion)this.util.CreateObject(item, this);
            obj.SetDrawLayer(this.util.ConvertEnum<DrawLayer>(layer.level));
            this.regions.Add(obj);
        }


        public IFontString CreateFontString()
        {
            throw new System.NotImplementedException();
        }

        public IFontString CreateFontString(string name)
        {
            throw new System.NotImplementedException();
        }

        public IFontString CreateFontString(string name, Layer layer)
        {
            throw new System.NotImplementedException();
        }

        public IFontString CreateFontString(string name, Layer layer, string inheritsFrom)
        {
            throw new System.NotImplementedException();
        }

        public ITexture CreateTexture()
        {
            throw new System.NotImplementedException();
        }

        public ITexture CreateTexture(string name)
        {
            throw new System.NotImplementedException();
        }

        public ITexture CreateTexture(string name, Layer layer)
        {
            var texture = this.util.CreateObject(new TextureType()) as ITexture;
            texture.SetDrawLayer(this.util.ConvertEnum<DrawLayer>(layer));
            this.regions.Add(texture);
            return texture;
        }

        public ITexture CreateTexture(string name, string inheritsFrom)
        {
            throw new System.NotImplementedException();
        }

        public ITexture CreateTexture(string name, Layer layer, string inheritsFrom)
        {
            throw new System.NotImplementedException();
        }

        public IRegion CreateTitleRegion()
        {
            throw new System.NotImplementedException();
        }

        public void DisableDrawLayer(Layer layer)
        {
            throw new System.NotImplementedException();
        }

        public void EnableDrawLayer(Layer layer)
        {
            throw new System.NotImplementedException();
        }

        public void EnableKeyboard(bool enableFlag)
        {
            throw new System.NotImplementedException();
        }

        public void EnableMouse(bool enableFlag)
        {
            throw new System.NotImplementedException();
        }

        public void EnableMouseWheel(bool enableFlag)
        {
            throw new System.NotImplementedException();
        }

        public object GetAttribute(string prefix, string name, string suffix)
        {
            throw new System.NotImplementedException();
        }

        public object GetBackdrop()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetBackdropBorderColor()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetBackdropColor()
        {
            throw new System.NotImplementedException();
        }

        public IFrame[] GetChildren()
        {
            return this.Children.ToArray();
        }

        public object GetClampRectInsets()
        {
            throw new System.NotImplementedException();
        }

        public object GetDepth()
        {
            throw new System.NotImplementedException();
        }

        public double GetEffectiveAlpha()
        {
            throw new System.NotImplementedException();
        }

        public double GetEffectiveDepth()
        {
            throw new System.NotImplementedException();
        }

        public double GetEffectiveScale()
        {
            throw new System.NotImplementedException();
        }

        public int GetFrameLevel()
        {
            throw new System.NotImplementedException();
        }

        public FrameStrata GetFrameStrata()
        {
            throw new System.NotImplementedException();
        }

        public string GetFrameType()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetHitRectInsets()
        {
            throw new System.NotImplementedException();
        }

        public int GetID()
        {
            return this.id;
        }

        public CsLua.Wrapping.IMultipleValues<double, double> GetMaxResize()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double> GetMinResize()
        {
            throw new System.NotImplementedException();
        }

        public int GetNumChildren()
        {
            return this.Children.Count;
        }

        public int GetNumRegions()
        {
            return this.regions.Count;
        }

        public ILayeredRegion[] GetRegions()
        {
            return this.regions.ToArray();
        }

        public double GetScale()
        {
            throw new System.NotImplementedException();
        }

        public IRegion GetTitleRegion()
        {
            throw new System.NotImplementedException();
        }

        public void IgnoreDepth(bool ignoreFlag)
        {
            throw new System.NotImplementedException();
        }

        public bool IsClampedToScreen()
        {
            throw new System.NotImplementedException();
        }

        public bool IsEventRegistered(string eventName)
        {
            return this.registeredEvents.Contains(eventName);
        }

        public bool IsFrameType(string type)
        {
            throw new System.NotImplementedException();
        }

        public bool IsIgnoringDepth()
        {
            throw new System.NotImplementedException();
        }

        public bool IsKeyboardEnabled()
        {
            throw new System.NotImplementedException();
        }

        public bool IsMouseEnabled()
        {
            throw new System.NotImplementedException();
        }

        public bool IsMouseWheelEnabled()
        {
            throw new System.NotImplementedException();
        }

        public bool IsMovable()
        {
            throw new System.NotImplementedException();
        }

        public bool IsResizable()
        {
            throw new System.NotImplementedException();
        }

        public bool IsToplevel()
        {
            throw new System.NotImplementedException();
        }

        public bool IsUserPlaced()
        {
            throw new System.NotImplementedException();
        }

        public void Lower()
        {
            throw new System.NotImplementedException();
        }

        public void Raise()
        {
            throw new System.NotImplementedException();
        }

        public void RegisterAllEvents()
        {
            throw new System.NotImplementedException();
        }

        public void RegisterEvent(string eventName)
        {
            if (!this.IsEventRegistered(eventName))
            {
                registeredEvents.Add(eventName);
            }
        }

        public void RegisterEvent(BlizzardApi.EventEnums.SystemEvent eventName)
        {
            this.RegisterEvent(eventName.ToString());
        }

        public void RegisterForDrag(MouseButton buttonType)
        {
            //throw new System.NotImplementedException();
        }

        public void RegisterForDrag(MouseButton buttonType, MouseButton buttonType2)
        {
            //throw new System.NotImplementedException();
        }

        public void SetBackdrop(Lua.NativeLuaTable backdropTable)
        {
            //throw new System.NotImplementedException();
        }

        public void SetBackdropBorderColor(double r, double g, double b)
        {
            throw new System.NotImplementedException();
        }

        public void SetBackdropBorderColor(double r, double g, double b, double a)
        {
            throw new System.NotImplementedException();
        }

        public void SetBackdropColor(double r, double g, double b)
        {
            throw new System.NotImplementedException();
        }

        public void SetBackdropColor(double r, double g, double b, double a)
        {
            throw new System.NotImplementedException();
        }

        public void SetClampedToScreen(bool clamped)
        {
            throw new System.NotImplementedException();
        }

        public void SetClampRectInsets(double left, double right, double top, double bottom)
        {
            throw new System.NotImplementedException();
        }

        public void SetDepth(double depth)
        {
            throw new System.NotImplementedException();
        }

        public void SetFrameLevel(int level)
        {
            throw new System.NotImplementedException();
        }

        public void SetFrameStrata(FrameStrata strata)
        {
            throw new System.NotImplementedException();
        }

        public void SetHitRectInsets(double left, double right, double top, double bottom)
        {
            throw new System.NotImplementedException();
        }

        public void SetID(int id)
        {
            this.id = id;
        }

        public void SetMaxResize(double maxWidth, double maxHeight)
        {
            throw new System.NotImplementedException();
        }

        public void SetMinResize(double minWidth, double minHeight)
        {
            throw new System.NotImplementedException();
        }

        public void SetMovable(bool isMovable)
        {
            //throw new System.NotImplementedException();
        }

        public void SetResizable(bool isResizable)
        {
            throw new System.NotImplementedException();
        }

        public void SetScale(double scale)
        {
            throw new System.NotImplementedException();
        }

        public void SetToplevel(bool isTopLevel)
        {
            throw new System.NotImplementedException();
        }

        public void SetUserPlaced(bool isUserPlaced)
        {
            throw new System.NotImplementedException();
        }

        public void StartMoving()
        {
            throw new System.NotImplementedException();
        }

        public void StartSizing(FramePoint point)
        {
            throw new System.NotImplementedException();
        }

        public void StopMovingOrSizing()
        {
            throw new System.NotImplementedException();
        }

        public void UnregisterAllEvents()
        {
            this.registeredEvents.Clear();
        }

        public void UnregisterEvent(string eventName)
        {
            this.registeredEvents.Remove(eventName);
        }

        public void SetScript(FrameHandler handler, System.Action<INativeUIObject> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<INativeUIObject, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<INativeUIObject, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<INativeUIObject, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<INativeUIObject, object, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public System.Action<INativeUIObject, object, object, object, object> GetScript(FrameHandler handler)
        {
            return this.scriptHandler.GetScript(handler);
        }

        public bool HasScript(FrameHandler handler)
        {
            return this.scriptHandler.HasScript(handler);
        }

        public void HookScript(FrameHandler handler, System.Action<INativeUIObject, object, object, object, object> function)
        {
            this.scriptHandler.HookScript(handler, function);
        }
    }
}