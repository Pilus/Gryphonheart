
namespace GHD.Document.Elements
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GHD.Document.Buffer;
    using GHD.Document.Containers;
    using GHD.Document.Flags;
    using Lua;

    public class FormattedText : LinkedElement<IContainer>, IElement, IFormattedText
    {
        private readonly IElementFrame frame;
        private readonly IFlags flags;
        private readonly ITextScoper textScoper;
        private ICursor cursor;
        private int cursorPos;

        private string text;

        public FormattedText(IFlags flags, IElementFrameFactory frameFactory, ITextScoper textScoper)
        {
            this.text = string.Empty;
            this.flags = flags;
            this.frame = frameFactory.Create(flags);
            this.textScoper = textScoper;
        }

        public IRegion Region
        {
            get { return this.frame.Region; }
        }

        public void SetText(string newText)
        {
            if (newText == null)
            {
                throw new Exception("Can not set text to null.");
            }

            this.text = newText;
            this.TextChanged();
        }

        public bool AllowZeroPosition { get; set; }

        /// <summary>
        /// Provides the cursor to the element.
        /// </summary>
        /// <param name="cursor">The cursor object</param>
        public void SetCursor(bool inEnd, ICursor cursor)
        {
            this.cursor = cursor;
            this.cursorPos = inEnd ? this.GetLength() : (this.AllowZeroPosition ? 0 : 1);
            this.CursorChanged();
        }

        /// <summary>
        /// Clears the cursor from the container.
        /// </summary>
        /// <returns>The cursor object.</returns>
        public void ClearCursor()
        {
            if (this.cursor == null)
            {
                throw new CursorException("Cursor have already been cleared or not been set");
            }
            this.cursor = null;
            this.cursorPos = 0;
            this.CursorChanged();
        }

        /// <summary>
        /// Navigates the cursor on the container.
        /// </summary>
        /// <param name="type">The type of navigation</param>
        /// <returns>Weather the navigation was successful</returns>
        public bool NavigateCursor(NavigationType type)
        {
            if (this.cursor == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            switch (type)
            {
                case NavigationType.Left:
                    if (this.cursorPos > (this.AllowZeroPosition ? 0 : 1))
                    {
                        this.cursorPos--;
                        this.CursorChanged();
                        return true;
                    }
                    return false;
                case NavigationType.Right:
                    if (this.cursorPos >= this.GetLength())
                    {
                        return false;
                    }
                    this.cursorPos++;
                    this.CursorChanged();
                    return true;
            }
            throw new Exception("Unhandled navigation type " + type);
        }

        /// <summary>
        /// Gets the length of the contained elements. Could be a value calculated every time insert or delete is called.
        /// </summary>
        /// <returns></returns>
        public int GetLength()
        {
            return Strings.strlenutf8(this.text);
        }

        public double GetWidth()
        {
            return this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize, this.text);
        }

        public double GetHeight()
        {
            return this.flags.FontSize;
        }

        /// <summary>
        /// Activate the highlight within a given interval.
        /// </summary>
        /// <param name="hightLightStart">The local start interval for the highlight.</param>
        /// <param name="highLightEnd">The local end interval for the highlight.</param>
        public void SetHightLight(int hightLightStart, int highLightEnd)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Clear all highlights.
        /// </summary>
        public void ClearHightLight()
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Get the <see cref="IFlags"/> applied at the cursor position.
        /// </summary>
        /// <returns></returns>
        public IFlags GetCurrentFlags()
        {
            return this.flags;
        }

        /// <summary>
        /// Gets the <see cref="IElement"/> currently at the cursor position.
        /// </summary>
        /// <returns>The element.</returns>
        public IElement GetCurrentElement()
        {
            if (this.cursor == null)
            {
                throw new CursorException("The element does not have the cursor and have no knowledge about the current element.");
            }
            return this;
        }

        /// <summary>
        /// Insers the content of the document buffer into itself and sub containers.
        /// </summary>
        /// <param name="documentBuffer">The document buffer.</param>
        /// <param name="dimensionConstraint">The constraining dimensions.</param>
        public void Insert(IDocumentBuffer documentBuffer, IDimensionConstraint dimensionConstraint)
        {
            if (this.cursor == null)
            {
                throw new CursorException("The element does not have the cursor.");
            }

            if (dimensionConstraint.MaxWidth == null)
            {
                throw new Exception("The formatted text object must be given a width constraint on insert.");
            }

            var textBeforeCursor = Strings.strsubutf8(this.text, 0, this.cursorPos);
            var xBeforeCursor = this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize, textBeforeCursor);
            var availableDimension = new DimensionConstraint()
            {
                MaxWidth = (double) dimensionConstraint.MaxWidth - xBeforeCursor,
                MaxHeight = dimensionConstraint.MaxHeight,
            };

            var addedText = documentBuffer.Take(availableDimension, this.GetCurrentFlags());
            if (addedText == String.Empty)
            {
                return;
            }

            var addedTextSize = Strings.strlenutf8(addedText);

            if (this.cursorPos < this.GetLength()) // The cursor is not and the end. The inserted text is thus put in at the cursor position
            {
                var textAfterCursor = Strings.strsubutf8(this.text, this.cursorPos);
                this.text = Strings.strsubutf8(this.text, 0, this.cursorPos);

                var bufferEmpty = documentBuffer.EndOfBuffer();

                documentBuffer.Append(textAfterCursor, this.GetCurrentFlags());

                if (bufferEmpty)
                {
                    availableDimension = new DimensionConstraint()
                    {
                        MaxWidth = (double)dimensionConstraint.MaxWidth - this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize, this.text + addedText),
                        MaxHeight = dimensionConstraint.MaxHeight,
                    };

                    addedText += documentBuffer.Take(availableDimension, this.GetCurrentFlags());
                }
            }

            if (this.cursor != null)
            {
                this.cursorPos += addedTextSize;
                this.CursorChanged();
            }

            this.text += addedText;
            this.TextChanged();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="documentDeleter"></param>
        public void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Goes to the <see cref="IElement"/> that starts at the given position. Recalculate its size and moves all elements after it, using the document buffer. This is relevant after an element changes size.
        /// </summary>
        /// <param name="position"></param>
        /// <param name="documentBuffer"></param>
        public void UpdateLayout(int position, IDocumentBuffer documentBuffer)
        {
            throw new System.NotImplementedException();
        }

        private void TextChanged()
        {
            this.frame.SetText(this.text, this.GetWidth());
        }

        private void CursorChanged()
        {
            
        }

        public Position GetCursorPosition()
        {
            var textBeforeCursor = Strings.strsubutf8(this.text, 0, this.cursorPos);
            var x = this.textScoper.GetWidth(this.flags.Font, this.flags.FontSize, textBeforeCursor);
            return new Position(x, 0);
        }

        public void SetCursorPosition(ICursor cursor, Position position)
        {
            this.cursor = cursor;
            var textBeforePosition = this.textScoper.GetFittingText(this.flags.Font, this.flags.FontSize, this.text, position.X);
            this.cursorPos = Strings.strlenutf8(textBeforePosition);
            this.CursorChanged();
        }
    }
}
