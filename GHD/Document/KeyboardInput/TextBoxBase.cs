

namespace GHD.Document.KeyboardInput
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using BlizzardApi.Global;

    public class TextBoxBase
    {
        private readonly IEditBox editBox;
        public TextBoxBase()
        {
            this.editBox = Global.FrameProvider.CreateFrame(FrameType.EditBox) as IEditBox;
            this.editBox.SetScript(FrameHandler.OnUpdate, this.OnUpdateHandler);
            this.editBox.SetScript(EditBoxHandler.OnTextChanged, this.OnTextChangedHandler);
            this.editBox.SetScript(EditBoxHandler.OnArrowPressed, this.OnArrowPressedHandler);
            this.editBox.SetScript(EditBoxHandler.OnEnterPressed, this.OnEnterPressedHandler);
            this.editBox.SetScript(EditBoxHandler.OnTabPressed, this.OnTabPressedHandler);
            this.editBox.SetScript(EditBoxHandler.OnEscapePressed, this.OnEscapePressedHandler);
            this.editBox.SetScript(EditBoxHandler.OnCursorChanged, this.OnCursorChangedHandler);
        }

        public void Show()
        {
            this.editBox.Show();
            this.editBox.SetFocus();
        }

        public void Hide()
        {
            this.editBox.Hide();
        }

        public virtual void SetText(string text)
        {
            this.editBox.SetText(text);
        }

        public virtual string GetText()
        {
            return this.editBox.GetText();
        }

        public virtual void Insert(string text)
        {
            this.editBox.Insert(text);
        }

        public virtual void HighlightText(int startPos, int endPos)
        {
            this.editBox.HighlightText(startPos, endPos);
        }

        public virtual void SetCursorPosition(int position)
        {
            this.editBox.SetCursorPosition(position);
        }

        public virtual int GetCursorPosition()
        {
            return this.editBox.GetCursorPosition();
        }

        public Action OnTextChanged { get; set; }
        public Action<string> OnArrowPressed { get; set; }
        public Action OnMarkAll { get; set; }
        public Action OnEnterPressed { get; set; }
        public Action OnTabPressed { get; set; }
        public Action OnEscapePressed { get; set; }
        public Action OnCursorChanged { get; set; }
        public Action OnUpdate { get; set; }

        private void OnUpdateHandler(IUIObject self)
        {
            if (this.OnUpdate != null)
            {
                this.OnUpdate();
            }
        }
        private void OnTextChangedHandler(IUIObject self)
        {
            if (this.OnTextChanged != null)
            {
                this.OnTextChanged();
            }
        }

        private void OnCursorChangedHandler(IUIObject self)
        {
            if (this.OnCursorChanged != null)
            {
                this.OnCursorChanged();
            }
        }

        private void OnEscapePressedHandler(IUIObject self)
        {
            if (this.OnEscapePressed != null)
            {
                this.OnEscapePressed();
            }
        }
        private void OnTabPressedHandler(IUIObject self)
        {
            if (this.OnTabPressed != null)
            {
                this.OnTabPressed();
            }
        }
        private void OnEnterPressedHandler(IUIObject self)
        {
            if (this.OnEnterPressed != null)
            {
                this.OnEnterPressed();
            }
        }

        private void OnArrowPressedHandler(IUIObject self, object key)
        {
            if (this.OnArrowPressed != null)
            {
                this.OnArrowPressed(key as string);
            }
        }        
    }
}
