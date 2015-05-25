
namespace GHD.Document.KeyboardInput
{
    using System;
    using BlizzardApi.Global;
    using CsLua;
    using Lua;

    public class TextBoxInputInterpreter : IKeyboardInputProvider
    {
        private const string TestText = "xxxxyyyy";
        private const int TestTextHalfLen = 4;

        private readonly TextBoxWithHighlightedText textBox;
        private Action<EditInputType, string> callback;

        public TextBoxInputInterpreter()
        {
            this.textBox = new TextBoxWithHighlightedText
            {
                OnArrowPressed = this.OnArrowPressed,
                OnTextChanged = this.OnTextChanged,
                OnCursorChanged = this.OnCursorChanged,
                OnEnterPressed = this.InvokeEvent(EditInputType.Enter),
                OnTabPressed = this.InvokeEvent(EditInputType.Tab),
                OnEscapePressed = this.InvokeEvent(EditInputType.Escape),
                OnMarkAll = this.OnMarkAll,
            };
        }

        public void RegisterCallback(Action<EditInputType, string> callback)
        {
            this.callback = callback;
        }

        public void Start()
        {
            if (this.callback == null)
            {
                throw new CsException("Callback not set.");
            }
            this.textBox.Show();
            this.ResetText();
        }

        public void Stop()
        {
            this.textBox.Hide();
        }

        public void SetHightlightedText(string text)
        {
            this.textBox.SetHightlightedText(text);
        }

        private void OnCursorChanged()
        {
            var pos = this.textBox.GetCursorPosition();
            if (pos == 0)
            {
                if (Global.Api.IsShiftKeyDown())
                {
                    this.callback(EditInputType.MarkHome, null);
                }
                else
                {
                    this.callback(EditInputType.Home, null);
                }
            }
            else if (pos == TestTextHalfLen * 2)
            {
                if (Global.Api.IsShiftKeyDown())
                {
                    this.callback(EditInputType.MarkEnd, null);
                }
                else
                {
                    this.callback(EditInputType.End, null);
                }
            }
            this.ResetCursor();
        }

        private void OnTextChanged()
        {
            var text = this.textBox.GetText();
            var len = Strings.strlen(text);
            if (text == "xxxyyyy")
            {
                this.callback(EditInputType.Backspace, null);
            }
            else if (text == "xxxxyyy")
            {
                this.callback(EditInputType.Delete, null);
            }
            else if (len > (TestTextHalfLen * 2) && Strings.strsub(text, 0, TestTextHalfLen) == "xxxx" && Strings.strsub(text, len - (TestTextHalfLen - 1)) == "yyyy")
            {
                var input = Strings.strsub(text, TestTextHalfLen + 1, len - TestTextHalfLen);
                this.callback(EditInputType.Input, input);
            }
            this.ResetText();
        }

        private void OnArrowPressed(string key)
        {
            switch (key)
            {
                case "UP":
                    this.callback(Global.Api.IsShiftKeyDown() ? EditInputType.MarkUp : EditInputType.Up, null);
                    break;
                case "DOWN":
                    this.callback(Global.Api.IsShiftKeyDown() ? EditInputType.MarkDown : EditInputType.Down, null);
                    break;
                case "LEFT":
                    this.callback(Global.Api.IsShiftKeyDown() ? EditInputType.MarkLeft : EditInputType.Left, null);
                    break;
                case "RIGHT":
                    this.callback(Global.Api.IsShiftKeyDown() ? EditInputType.MarkRight : EditInputType.Right, null);
                    break;
                default:
                    throw new CsException("Unknown key " + key);
            }
        }

        private void OnMarkAll()
        {
            this.ResetCursor();
            this.callback(EditInputType.MarkAll, null);
        }

        private void ResetText()
        {
            this.textBox.SetText(TestText);
            this.ResetCursor();
        }

        private void ResetCursor()
        {
            this.textBox.SetCursorPosition(TestTextHalfLen);
            this.textBox.HighlightText(0, 0);
        }

        private Action InvokeEvent(EditInputType type)
        {
            return delegate
            {
                this.callback(type, null);
            };
        }
    }
}
