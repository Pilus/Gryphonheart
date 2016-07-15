namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using FrameType = XMLHandler.FrameType;

    public class EditBox : Frame, IEditBox
    {
        private Script<EditBoxHandler, IEditBox> scriptHandler;

        private string text;

        public EditBox(UiInitUtil util, string objectType, FrameType frameType, IRegion parent) : base(util, objectType, frameType, parent)
        {
            this.scriptHandler = new Script<EditBoxHandler, IEditBox>(this);
        }

        public void SetFont(string path, double height)
        {
            throw new NotImplementedException();
        }

        public void SetFont(string path, double height, string flags)
        {
            throw new NotImplementedException();
        }

        public void SetJustifyH(JustifyH justifyH)
        {
            throw new NotImplementedException();
        }

        public void SetJustifyV(JustifyV justifyV)
        {
            throw new NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b)
        {
            throw new NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b, double a)
        {
            throw new NotImplementedException();
        }

        public void SetScript(EditBoxHandler handler, Action<IUIObject> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(EditBoxHandler handler, Action<IUIObject, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(EditBoxHandler handler, Action<IUIObject, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(EditBoxHandler handler, Action<IUIObject, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public void SetScript(EditBoxHandler handler, Action<IUIObject, object, object, object, object> function)
        {
            this.scriptHandler.SetScript(handler, function);
        }

        public Action<IEditBox, object, object, object, object> GetScript(EditBoxHandler handler)
        {
            return this.scriptHandler.GetScript(handler);
        }

        public bool HasScript(EditBoxHandler handler)
        {
            return this.scriptHandler.HasScript(handler);
        }

        public void HookScript(EditBoxHandler handler, Action<IUIObject, object, object, object, object> function)
        {
            this.scriptHandler.HookScript(handler, function);
        }

        public void SetText(string text)
        {
            this.text = text;
            this.scriptHandler.ExecuteScript(EditBoxHandler.OnTextChanged, text, null, null, null);
        }

        public void AddHistoryLine(string text)
        {
            throw new NotImplementedException();
        }

        public void ClearFocus()
        {
            throw new NotImplementedException();
        }

        public string GetText()
        {
            return this.text;
        }

        public void Insert(string text)
        {
            throw new NotImplementedException();
        }

        public void SetFocus()
        {
            throw new NotImplementedException();
        }

        public void SetMultiLine(bool state)
        {
            throw new NotImplementedException();
        }

        public bool GetAltArrowKeyMode()
        {
            throw new NotImplementedException();
        }

        public object GetBlinkSpeed()
        {
            throw new NotImplementedException();
        }

        public int GetCursorPosition()
        {
            throw new NotImplementedException();
        }

        public int GetHistoryLines()
        {
            throw new NotImplementedException();
        }

        public bool GetHyperlinksEnabled()
        {
            throw new NotImplementedException();
        }

        public string GetInputLanguage()
        {
            throw new NotImplementedException();
        }

        public int GetMaxBytes()
        {
            throw new NotImplementedException();
        }

        public int GetMaxLetters()
        {
            throw new NotImplementedException();
        }

        public int GetNumLetters()
        {
            throw new NotImplementedException();
        }

        public double GetNumber()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double, double, double> GetTextInsets()
        {
            throw new NotImplementedException();
        }

        public void HighlightText()
        {
            throw new NotImplementedException();
        }

        public void HighlightText(double startPos, double endPos)
        {
            throw new NotImplementedException();
        }

        public bool IsAutoFocus()
        {
            throw new NotImplementedException();
        }

        public bool IsMultiLine()
        {
            throw new NotImplementedException();
        }

        public bool IsNumeric()
        {
            throw new NotImplementedException();
        }

        public bool IsPassword()
        {
            throw new NotImplementedException();
        }

        public void SetAltArrowKeyMode(bool enable)
        {
            throw new NotImplementedException();
        }

        public void SetAutoFocus(bool state)
        {
            throw new NotImplementedException();
        }

        public void SetBlinkSpeed(object speed)
        {
            throw new NotImplementedException();
        }

        public void SetCursorPosition(int position)
        {
            throw new NotImplementedException();
        }

        public bool SetHistoryLines()
        {
            throw new NotImplementedException();
        }

        public void SetHyperlinksEnabled(bool enableFlag)
        {
            throw new NotImplementedException();
        }

        public void SetMaxBytes(int maxBytes)
        {
            throw new NotImplementedException();
        }

        public void SetMaxLetters(int maxLetters)
        {
            throw new NotImplementedException();
        }

        public void SetNumber(double number)
        {
            throw new NotImplementedException();
        }

        public void SetNumeric(bool state)
        {
            throw new NotImplementedException();
        }

        public void SetPassword(bool state)
        {
            throw new NotImplementedException();
        }

        public void SetTextInsets(double l, double r, double t, double b)
        {
            throw new NotImplementedException();
        }

        public void ToggleInputLanguage()
        {
            throw new NotImplementedException();
        }
    }
}