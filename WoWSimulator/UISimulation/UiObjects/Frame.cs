namespace WoWSimulator.UISimulation.UiObjects
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using FrameType = FrameType;

    public class Frame : Region, IFrame
    {
        private int id;
        private readonly List<IUIObject> children = new List<IUIObject>();
        private readonly UiInitUtil util;

        private readonly Script<FrameHandler, IFrame> scriptHandler;
        public Frame(UiInitUtil util, string objectType)
            : base(util, objectType)
        {
            this.util = util;
            this.scriptHandler = new Script<FrameHandler, IFrame>(this);
        }

        public Frame(UiInitUtil util, string objectType, string name, IRegion parent)
            : base(util, objectType, name, parent)
        {
            this.util = util;
            this.scriptHandler = new Script<FrameHandler, IFrame>(this);
        }

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

            if (frameType.Items == null) return;
            foreach (var item in frameType.Items)
            {
                if (item is LayoutFrameTypeFrames)
                {
                    this.ApplyFrameTypeFrames(item as LayoutFrameTypeFrames);
                }
                
            }
        }

        private void ApplyFrameTypeFrames(LayoutFrameTypeFrames frames)
        {
            foreach (var frameType in frames.Items)
            {
                this.children.Add(this.util.CreateObject(frameType, this));
            }
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
            throw new System.NotImplementedException();
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

        public string[] GetChildren()
        {
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
        }

        public int GetNumRegions()
        {
            throw new System.NotImplementedException();
        }

        public IRegion[] GetRegions()
        {
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
        }

        public void RegisterEvent(BlizzardApi.EventEnums.SystemEvent eventName)
        {
            throw new System.NotImplementedException();
        }

        public void RegisterForDrag(MouseButton buttonType)
        {
            throw new System.NotImplementedException();
        }

        public void RegisterForDrag(MouseButton buttonType, MouseButton buttonType2)
        {
            throw new System.NotImplementedException();
        }

        public void SetBackdrop(Lua.NativeLuaTable backdropTable)
        {
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
        }

        public void UnregisterEvent(string eventName)
        {
            throw new System.NotImplementedException();
        }

        public void SetScript(FrameHandler handler, System.Action<IFrame> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<IFrame, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<IFrame, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<IFrame, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(FrameHandler handler, System.Action<IFrame, object, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public System.Action<IFrame, object, object, object, object> GetScript(FrameHandler handler)
        {
            return this.scriptHandler.GetScript(handler);
        }

        public bool HasScript(FrameHandler handler)
        {
            return this.scriptHandler.HasScript(handler);
        }

        public void HookScript(FrameHandler handler, System.Action<IFrame, object, object, object, object> function)
        {
            this.scriptHandler.HookScript(handler, function);
        }
    }
}