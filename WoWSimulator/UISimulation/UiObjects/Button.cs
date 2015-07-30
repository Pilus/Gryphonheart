namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class Button : Frame, IButton
    {
        private Script<ButtonHandler, IButton> scriptHandler;
        private string text;

        public Button(UiInitUtil util, string objectType, ButtonType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
            this.scriptHandler = new Script<ButtonHandler, IButton>(this);

            if (!string.IsNullOrEmpty(frameType.inherits))
            {
                this.ApplyType((ButtonType)util.GetTemplate(frameType.inherits));
            }
            this.ApplyType(frameType);
        }

        private void ApplyType(ButtonType type)
        {
            this.text = type.text;
        }

        public void Click()
        {
            this.scriptHandler.ExecuteScript(ButtonHandler.OnClick, "LeftButton", false, null, null);
        }

        public void Disable()
        {
            throw new NotImplementedException();
        }

        public ButtonState GetButtonState()
        {
            throw new NotImplementedException();
        }

        public IFontString GetDisabledFontObject()
        {
            throw new NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetDisabledTextColor()
        {
            throw new NotImplementedException();
        }

        public ITexture GetDisabledTexture()
        {
            throw new NotImplementedException();
        }

        public IFontString GetFontString()
        {
            throw new NotImplementedException();
        }

        public IFontString GetHighlightFontObject()
        {
            throw new NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetHighLightTextColor()
        {
            throw new NotImplementedException();
        }

        public ITexture GetHighlightTexture()
        {
            throw new NotImplementedException();
        }

        public ITexture GetNormalTexture()
        {
            throw new NotImplementedException();
        }

        public IFontString GetNormalFontObject()
        {
            throw new NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double> GetPushedTextOffset()
        {
            throw new NotImplementedException();
        }

        public ITexture GetPushedTexture()
        {
            throw new NotImplementedException();
        }

        public string GetText()
        {
            return this.text ?? string.Empty;
        }

        public double GetTextHeight()
        {
            throw new NotImplementedException();
        }

        public double GetTextWidth()
        {
            throw new NotImplementedException();
        }

        public bool IsEnabled()
        {
            throw new NotImplementedException();
        }

        public void LockHighlight()
        {
            throw new NotImplementedException();
        }

        public void RegisterForClicks(ClickType clickType)
        {
            throw new NotImplementedException();
        }

        public void RegisterForClicks(ClickType clickType, ClickType clickType2)
        {
            //throw new NotImplementedException();
        }

        public void SetButtonState(ButtonState state)
        {
            throw new NotImplementedException();
        }

        public void SetButtonState(ButtonState state, bool locked)
        {
            throw new NotImplementedException();
        }

        public void SetDisabledFontObject()
        {
            throw new NotImplementedException();
        }

        public void SetDisabledFontObject(IFontString font)
        {
            throw new NotImplementedException();
        }

        public void SetDisabledTexture(ITexture texture)
        {
            throw new NotImplementedException();
        }

        public void SetDisabledTexture(string texturePath)
        {
            throw new NotImplementedException();
        }

        public void SetFont(string font, double size)
        {
            throw new NotImplementedException();
        }

        public void SetFont(string font, double size, string flags)
        {
            throw new NotImplementedException();
        }

        public void SetFontString(IFontString fontString)
        {
            throw new NotImplementedException();
        }

        public void SetFormattedText(string formatstring)
        {
            throw new NotImplementedException();
        }

        public void SetHighlightFontObject()
        {
            throw new NotImplementedException();
        }

        public void SetHighlightFontObject(IFontString font)
        {
            throw new NotImplementedException();
        }

        public void SetHighlightTexture(ITexture texture)
        {
            throw new NotImplementedException();
        }

        public void SetHighlightTexture(string texturePath)
        {
            throw new NotImplementedException();
        }

        public void SetHighlightTexture(ITexture texture, bool alphaMode)
        {
            throw new NotImplementedException();
        }

        public void SetHighlightTexture(string texturePath, bool alphaMode)
        {
            throw new NotImplementedException();
        }

        public void SetNormalTexture(ITexture texture)
        {
            throw new NotImplementedException();
        }

        public void SetNormalTexture(string texturePath)
        {
            throw new NotImplementedException();
        }

        public void SetNormalFontObject(IFontString fontString)
        {
            throw new NotImplementedException();
        }

        public void SetPushedTextOffset(double x, double y)
        {
            throw new NotImplementedException();
        }

        public void SetPushedTexture(ITexture texture)
        {
            throw new NotImplementedException();
        }

        public void SetPushedTexture(string texturePath)
        {
            throw new NotImplementedException();
        }

        public void SetText(string text)
        {
            this.text = text;
        }

        public void UnlockHighlight()
        {
            throw new NotImplementedException();
        }

        public void SetScript(ButtonHandler handler, Action<IButton> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(ButtonHandler handler, Action<IButton, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(ButtonHandler handler, Action<IButton, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(ButtonHandler handler, Action<IButton, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(ButtonHandler handler, Action<IButton, object, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public Action<IButton, object, object, object, object> GetScript(ButtonHandler handler)
        {
            return this.scriptHandler.GetScript(handler);
        }

        public bool HasScript(ButtonHandler handler)
        {
            return this.scriptHandler.HasScript(handler);
        }

        public void HookScript(ButtonHandler handler, Action<IButton, object, object, object, object> function)
        {
            this.scriptHandler.HookScript(handler, function);
        }
    }
}