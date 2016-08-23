namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.EventEnums;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using Lua;
    using XMLHandler;
    using FrameType = XMLHandler.FrameType;

    public class Frame : Region, IFrame
    {
        private int id;
        private int level;
        private FrameStrata frameStrata;

        public readonly List<IFrame> Children = new List<IFrame>();
        public readonly List<ILayeredRegion> Regions = new List<ILayeredRegion>();

        private readonly UiInitUtil util;
        private readonly List<string> registeredEvents = new List<string>();

        private readonly Script<FrameHandler, IFrame> scriptHandler;

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
            this.Regions.Add(obj);
        }


        public override void Hide()
        {
            base.Hide();
            this.scriptHandler.ExecuteScript(FrameHandler.OnHide, null, null, null, null);
        }

        public IFontString CreateFontString()
        {
            return this.CreateFontString(null);
        }

        public IFontString CreateFontString(string name)
        {
            return this.CreateFontString(name, Layer.ARTWORK);
        }

        public IFontString CreateFontString(string name, Layer layer)
        {
            return this.CreateFontString(name, layer, null);
        }

        public IFontString CreateFontString(string name, Layer layer, string inheritsFrom)
        {
            var fontString = this.util.CreateObject(new FontStringType()
            {
                name = name,
            }) as IFontString;
            fontString.SetDrawLayer(this.util.ConvertEnum<DrawLayer>(layer));

            this.Regions.Add(fontString);
            return fontString;
        }

        public ITexture CreateTexture()
        {
            return this.CreateTexture(null);
        }

        public ITexture CreateTexture(string name)
        {
            return this.CreateTexture(name, Layer.BACKGROUND);
        }

        public ITexture CreateTexture(string name, Layer layer)
        {
            var texture = this.util.CreateObject(new TextureType()
            {
                name = name,
            }) as ITexture;

            texture.SetDrawLayer(this.util.ConvertEnum<DrawLayer>(layer));
            this.Regions.Add(texture);
            return texture;
        }

        public ITexture CreateTexture(string name, string inheritsFrom)
        {
            throw new NotImplementedException();
        }

        public ITexture CreateTexture(string name, Layer layer, string inheritsFrom)
        {
            throw new NotImplementedException();
        }

        public IRegion CreateTitleRegion()
        {
            throw new NotImplementedException();
        }

        public void DisableDrawLayer(Layer layer)
        {
            throw new NotImplementedException();
        }

        public void EnableDrawLayer(Layer layer)
        {
            throw new NotImplementedException();
        }

        public void EnableKeyboard(bool enableFlag)
        {
            throw new NotImplementedException();
        }

        public void EnableMouse(bool enableFlag)
        {
            throw new NotImplementedException();
        }

        public void EnableMouseWheel(bool enableFlag)
        {
            throw new NotImplementedException();
        }

        public object GetAttribute(string prefix, string name, string suffix)
        {
            throw new NotImplementedException();
        }

        public object GetBackdrop()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double, double, double> GetBackdropBorderColor()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double, double, double> GetBackdropColor()
        {
            throw new NotImplementedException();
        }

        public IFrame[] GetChildren()
        {
            return this.Children.ToArray();
        }

        public object GetClampRectInsets()
        {
            throw new NotImplementedException();
        }

        public object GetDepth()
        {
            throw new NotImplementedException();
        }

        public double GetEffectiveAlpha()
        {
            throw new NotImplementedException();
        }

        public double GetEffectiveDepth()
        {
            throw new NotImplementedException();
        }

        public double GetEffectiveScale()
        {
            return 1;
        }

        public int GetFrameLevel()
        {
            return this.level;
        }

        public FrameStrata GetFrameStrata()
        {
            return this.frameStrata;
        }

        public string GetFrameType()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double, double, double> GetHitRectInsets()
        {
            throw new NotImplementedException();
        }

        public int GetID()
        {
            return this.id;
        }

        public IMultipleValues<double, double> GetMaxResize()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double> GetMinResize()
        {
            throw new NotImplementedException();
        }

        public int GetNumChildren()
        {
            return this.Children.Count;
        }

        public int GetNumRegions()
        {
            return this.Regions.Count;
        }

        public ILayeredRegion[] GetRegions()
        {
            return this.Regions.ToArray();
        }

        public double GetScale()
        {
            throw new NotImplementedException();
        }

        public IRegion GetTitleRegion()
        {
            throw new NotImplementedException();
        }

        public void IgnoreDepth(bool ignoreFlag)
        {
            throw new NotImplementedException();
        }

        public bool IsClampedToScreen()
        {
            throw new NotImplementedException();
        }

        public bool IsEventRegistered(string eventName)
        {
            return this.registeredEvents.Contains(eventName);
        }

        public bool IsFrameType(string type)
        {
            throw new NotImplementedException();
        }

        public bool IsIgnoringDepth()
        {
            throw new NotImplementedException();
        }

        public bool IsKeyboardEnabled()
        {
            throw new NotImplementedException();
        }

        public bool IsMouseEnabled()
        {
            throw new NotImplementedException();
        }

        public bool IsMouseWheelEnabled()
        {
            throw new NotImplementedException();
        }

        public bool IsMovable()
        {
            throw new NotImplementedException();
        }

        public bool IsResizable()
        {
            throw new NotImplementedException();
        }

        public bool IsToplevel()
        {
            throw new NotImplementedException();
        }

        public bool IsUserPlaced()
        {
            throw new NotImplementedException();
        }

        public void Lower()
        {
            throw new NotImplementedException();
        }

        public void Raise()
        {
            throw new NotImplementedException();
        }

        public void RegisterAllEvents()
        {
            throw new NotImplementedException();
        }

        public void RegisterEvent(string eventName)
        {
            if (!this.IsEventRegistered(eventName))
            {
                registeredEvents.Add(eventName);
            }
        }

        public void RegisterEvent(SystemEvent eventName)
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

        public void SetBackdrop(NativeLuaTable backdropTable)
        {
            //throw new System.NotImplementedException();
        }

        public void SetBackdropBorderColor(double r, double g, double b)
        {
            throw new NotImplementedException();
        }

        public void SetBackdropBorderColor(double r, double g, double b, double a)
        {
            throw new NotImplementedException();
        }

        public void SetBackdropColor(double r, double g, double b)
        {
            throw new NotImplementedException();
        }

        public void SetBackdropColor(double r, double g, double b, double a)
        {
            throw new NotImplementedException();
        }

        public void SetClampedToScreen(bool clamped)
        {
            throw new NotImplementedException();
        }

        public void SetClampRectInsets(double left, double right, double top, double bottom)
        {
            throw new NotImplementedException();
        }

        public void SetDepth(double depth)
        {
            throw new NotImplementedException();
        }

        public void SetFrameLevel(int level)
        {
            this.level = level;
        }

        public void SetFrameStrata(FrameStrata strata)
        {
            this.frameStrata = strata;
        }

        public void SetHitRectInsets(double left, double right, double top, double bottom)
        {
            throw new NotImplementedException();
        }

        public void SetID(int id)
        {
            this.id = id;
        }

        public void SetMaxResize(double maxWidth, double maxHeight)
        {
            throw new NotImplementedException();
        }

        public void SetMinResize(double minWidth, double minHeight)
        {
            throw new NotImplementedException();
        }

        public void SetMovable(bool isMovable)
        {
            //throw new System.NotImplementedException();
        }

        public void SetResizable(bool isResizable)
        {
            throw new NotImplementedException();
        }

        public void SetScale(double scale)
        {
            throw new NotImplementedException();
        }

        public void SetToplevel(bool isTopLevel)
        {
            throw new NotImplementedException();
        }

        public void SetUserPlaced(bool isUserPlaced)
        {
            throw new NotImplementedException();
        }

        public void StartMoving()
        {
            throw new NotImplementedException();
        }

        public void StartSizing(FramePoint point)
        {
            throw new NotImplementedException();
        }

        public void StopMovingOrSizing()
        {
            throw new NotImplementedException();
        }

        public void UnregisterAllEvents()
        {
            this.registeredEvents.Clear();
        }

        public void UnregisterEvent(string eventName)
        {
            this.registeredEvents.Remove(eventName);
        }

        public void SetScript(FrameHandler handler, Action<IUIObject> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, Action<IUIObject, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, Action<IUIObject, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, Action<IUIObject, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, Action<IUIObject, object, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public Action<IFrame, object, object, object, object> GetScript(FrameHandler handler)
        {
            return this.scriptHandler.GetScript(handler);
        }

        public bool HasScript(FrameHandler handler)
        {
            return this.scriptHandler.HasScript(handler);
        }

        public void HookScript(FrameHandler handler, Action<IUIObject, object, object, object, object> function)
        {
            this.scriptHandler.HookScript(handler, function);
        }
    }
}