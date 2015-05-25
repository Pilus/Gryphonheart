

namespace GHD.Document.KeyboardInput
{
    using System;
    using BlizzardApi.Global;
    using Lua;

    internal enum State
    {
        Ready,
        Detecting,
        Reverting,
    }

    public class TextBoxWithMarkAllDetection : TextBoxFeedbackFilter
    {
        private const double MinimumSampleTime = 0.4;
        private const string SampleText = "zINSERTz";

        
        private double lastDetectionTime = 0;
        private string originalText;
        private string newText = null;
        private int? newPosition = null;
        private int originalPosition;
        private State state;
        private int hlStart;
        private int hlEnd;

        public TextBoxWithMarkAllDetection()
        {
            base.OnTextChanged = this.OnTextChangedHandler;
            base.OnUpdate = this.OnUpdateHandler;
            base.OnCursorChanged = this.OnCursorChangedHandler;
            this.state = State.Ready;
        }        

        public override void SetText(string text)
        {
            if (this.state == State.Ready)
            {
                base.SetText(text);
                return;
            }
            this.newText = text;
        }

        public override string GetText()
        {
            return this.state == State.Ready ? base.GetText() : this.originalText;
        }


        public override int GetCursorPosition()
        {
            if (this.state == State.Ready)
            {
                return base.GetCursorPosition();
            }
            return base.GetCursorPosition() - Strings.strlen(SampleText);
        }

        public override void SetCursorPosition(int position)
        {
            if (this.state == State.Ready)
            {
                base.SetCursorPosition(position);
                return;
            }
            this.newPosition = position;
        }

        public override void HighlightText(int startPos, int endPos)
        {
            this.hlStart = startPos;
            this.hlEnd = endPos;
            base.HighlightText(startPos, endPos);
        }

        new public Action OnCursorChanged { get; set; }

        private void OnCursorChangedHandler()
        {
            if (this.state == State.Ready && this.OnCursorChanged != null)
            {
                this.OnCursorChanged();
            }
        }

        new public Action OnUpdate { get; set; }
        private void OnUpdateHandler()
        {
            var t = Global.Api.GetTime();
            if (t - this.lastDetectionTime > MinimumSampleTime && this.state == State.Ready && Strings.strlen(base.GetText()) > 0)
            {
                this.lastDetectionTime = t;
                this.state = State.Detecting;
                this.originalText = base.GetText();
                this.originalPosition = base.GetCursorPosition();
                base.Insert(SampleText);
            }
        }

        new public Action OnTextChanged { get; set; }
        private void OnTextChangedHandler()
        {
            var text = base.GetText();

            switch (this.state)
            {
                case State.Detecting:

                    if (this.newText != null)
                    {
                        base.SetText(this.newText);
                        this.newText = null;
                    }
                    else
                    {
                        base.SetText(this.originalText);
                    }

                    if (this.newPosition != null)
                    {
                        base.SetCursorPosition((int)this.newPosition);
                        this.newPosition = null;
                    }
                    else
                    {
                        base.SetCursorPosition(this.originalPosition);
                    }
                    base.HighlightText(this.hlStart, this.hlEnd);

                    this.state = State.Ready;
                    if (text == SampleText && this.OnMarkAll != null)
                    {
                        this.OnMarkAll();
                    }                    
                    return;
                case State.Ready:
                    if (this.OnTextChanged != null)
                    {
                        this.OnTextChanged();
                    }
                    return;
                default:
                    return;
            }
        }
    }
}
