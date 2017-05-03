namespace GHD.Document.Elements
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GHD.Document.Flags;
    using GHD.Document.Navigation;
    using Lua;

    public class TextElement : BaseElement, INavigableElement, ISplitableElement
    {
        private readonly ITextScoper textScoper;

        private readonly IFlags flags;
        private string text;
        private int insertPosition;
        private FormattedTextFrame frame;

        private double width;
        private double height;

        public TextElement(ITextScoper textScoper, IFlags flags, string text, int insertPosition = 0)
        {
            this.textScoper = textScoper;
            this.flags = flags;
            this.height = flags.FontSize;
            this.text = text;
            this.insertPosition = insertPosition;
            this.frame = new FormattedTextFrame(flags);
            this.TextChanged();
            this.frame.Region.Show();
        }

        public void Insert(IFlags newFlags, string newText)
        {
            if (!this.flags.Equals(newFlags))
            {
                this.InsertNewTextElement(newFlags, newText);
            }
            else
            {
                this.InsertTextAtInsertPosition(newText);
            }
        }

        public void ResetInsertPosition(bool inEnd = false)
        {
            this.insertPosition = !inEnd ? 0 : Strings.strlenutf8(this.text);
        }

        public void SetInsertPosition(double xOffset, double yOffset)
        {
            this.insertPosition =
                Strings.strlenutf8(this.textScoper.GetFittingText(this.flags.Font, this.flags.FontSize, this.text,
                    xOffset));
        }

        public double GetInsertXOffset()
        {
            return this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize,
                Strings.strsubutf8(this.text, 0, this.insertPosition));
        }

        public bool Navigate(NavigationType navigationType)
        {
            if (navigationType == NavigationType.Right)
            {
                if (this.insertPosition < Strings.strlenutf8(this.text))
                {
                    this.insertPosition++;
                    return true;
                }
            }
            else if (navigationType == NavigationType.Left)
            {
                if (this.insertPosition > 0)
                {
                    this.insertPosition--;
                    return true;
                }
            }

            return false;
        }

        private void InsertTextAtInsertPosition(string newText)
        {
            this.text = this.text.Substring(0, this.insertPosition) + newText + this.text.Substring(this.insertPosition);
            this.TextChanged();
            this.insertPosition += Strings.strlenutf8(newText);
        }

        private void InsertNewTextElement(IFlags newFlags, string newText)
        {
            if (this.insertPosition == 0)
            {
                this.InsertElementBefore(new TextElement(this.textScoper, newFlags, newText));
            }
            else if (this.insertPosition == Strings.strlenutf8(this.text))
            {
                this.InsertElementAfter(new TextElement(this.textScoper, newFlags, newText));
            }
            else
            {
                this.InsertNewTextElementAtInsertPosition(newFlags, newText);
            }
        }

        private void InsertNewTextElementAtInsertPosition(IFlags newFlags, string newText)
        {
            var textBeforeInsertPosition = this.text.Substring(0, this.insertPosition);
            var textAfterInsertPosition = this.text.Substring(this.insertPosition);
            this.text = textBeforeInsertPosition;
            this.InsertElementAfter(new TextElement(this.textScoper, this.flags, textAfterInsertPosition));
            this.InsertElementAfter(new TextElement(this.textScoper, newFlags, newText));
            this.TextChanged();
        }

        private void TextChanged()
        {
            this.width = this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize, this.text);
            this.frame.SetText(this.text, this.width);
        }

        public override IFlags Flags => this.flags;

        public override double GetWidth()
        {
            return this.width;
        }

        public override double GetHeight()
        {
            return this.height;
        }

        public override void SetPoint(double xOff, double yOff, IRegion parent)
        {
            this.frame.Region.SetPoint(FramePoint.BOTTOMLEFT, parent, FramePoint.BOTTOMLEFT, xOff, yOff);
        }

        public ISplitableElement SplitFromFront(double width)
        {
            if (this.GetWidth() <= width)
            {
                return this;
            }

            var newText = this.textScoper.GetFittingText(this.flags.Font, this.flags.FontSize, this.text, width);
            if (newText == String.Empty)
            {
                return null;
            }

            var newPosition = 0;
            if (this.insertPosition < newText.Length)
            {
                newPosition = this.insertPosition;
                this.insertPosition = 0;
            }
            else
            {
                this.insertPosition = this.insertPosition - newText.Length;
            }

            var newElement = new TextElement(this.textScoper, this.flags, newText, newPosition);
            this.InsertElementBefore(newElement);

            

            this.text = this.text.Substring(newText.Length);
            if (this.text.StartsWith(" "))
            {
                this.text = this.text.Substring(1);
                this.insertPosition--;
            }

            this.TextChanged();

            return newElement;
        }

        public ISplitableElement SplitFromEnd(double width)
        {
            throw new NotImplementedException();
        }

        public bool TryMergeIntoFront()
        {
            if (this.Next == null || !(this.Next is TextElement))
            {
                return false;
            }

            var nextElement = this.Next as TextElement;
            if (nextElement.Flags.Equals(this.flags))
            {
                
            }

            return true;
        }
    }
}