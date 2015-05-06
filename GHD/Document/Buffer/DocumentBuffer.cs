
namespace GHD.Document.Buffer
{
    using System.Reflection.Emit;
    using Containers;
    using CsLua;
    using CsLua.Collection;
    using GHD.Document.Data;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using Lua;

    public class DocumentBuffer : IDocumentBuffer
    {
        private CsLuaList<BufferElement> elements;

        public DocumentBuffer()
        {
            // TODO: Init the document deleter
            this.Deleter = null;
            this.elements = new CsLuaList<BufferElement>();
        }

        public DocumentBuffer(IDocumentData data)
        {
        }

        /// <summary>
        /// Appends a text with a given set of flags to the buffer. Intended for the remaining text in a text element when inserting inside a text element.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="flags"></param>
        public void Append(string text, IFlags flags)
        {
            if (this.elements.Any())
            {
                var last = this.elements[this.elements.Count - 1];
                if (last.Flags != null && last.Flags.Equals(flags))
                {
                    last.Text += text;
                    this.elements[this.elements.Count - 1] = last;
                    return;
                }
            }

            this.elements.Add(new BufferElement()
            {
                Text = text,
                Flags = flags,
            });
        }

        /// <summary>
        /// Appends a whole element to the buffer.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="element"></param>
        public void Append(string text, IElement element)
        {
            this.elements.Add(new BufferElement()
            {
                Text = text,
                Element = element,
            });
        }

        /// <summary>
        /// Gets the remaining text that fits the flag, until a limit by the maxLength.
        /// </summary>
        /// <returns></returns>
        public string Get(IDimensionConstraint constraint, IFlags flags)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new CsException("A max width must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags == null || (flags != null && !first.Flags.Equals(flags)))
            {
                return "";
            }

            var text = TextScoper.GetFittingText(first.Flags.Font, first.Flags.FontSize, first.Text, (double)constraint.MaxWidth);
            if (text == first.Text)
            {
                this.elements.RemoveAt(0);
            }
            else if (text != "")
            {
                this.elements[0] = new BufferElement()
                {
                    Text = Strings.strsubutf8(first.Text, Strings.strlenutf8(text)),
                    Flags = first.Flags,
                };
            }
            return text;
        }

        /// <summary>
        /// Peeks the remaining text that fits the flag, until a limit by the maxLength.
        /// </summary>
        /// <param name="flags"></param>
        /// <returns></returns>
        public string Peek(IDimensionConstraint constraint, IFlags flags)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new CsException("A max width must be provided in the constraint.");
            }


            var first = this.elements.First();
            if (first.Flags == null || (flags != null && !first.Flags.Equals(flags)))
            {
                return "";
            }

            return TextScoper.GetFittingText(first.Flags.Font, first.Flags.FontSize, first.Text, (double)constraint.MaxWidth);
        }

        /// <summary>
        /// Gets the next element if it fits within the maxLength.
        /// </summary>
        /// <returns></returns>
        public IElement Get(IDimensionConstraint constraint)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new CsException("A max width must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags != null)
            {
                var text = this.Get(constraint, first.Flags);
                if (text == "")
                {
                    return null;
                }

                var formattedText = new FormattedText(first.Flags);
                formattedText.SetText(text);
                return formattedText;
            }

            if (first.Element == null || first.Element.GetWidth() > constraint.MaxWidth)
            {
                return null;
            }

            this.elements.RemoveAt(0);
            return first.Element;
        }

        public IElement Peek(IDimensionConstraint constraint)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new CsException("A max width must be provided in the constraint.");
            }

            if (constraint.MaxHeight == null)
            {
                throw new CsException("A max height must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags != null)
            {
                var text = this.Peek(constraint, first.Flags);
                if (text == "")
                {
                    return null;
                }

                var formattedText = new FormattedText(first.Flags);
                formattedText.SetText(text);
                return formattedText;
            }

            if (first.Element == null || first.Element.GetWidth() > constraint.MaxWidth || first.Element.GetHeight() > constraint.MaxHeight)
            {
                return null;
            }

            return first.Element;
        }

        /// <summary>
        /// Returns weather the end of the buffer has been reached. 
        /// </summary>
        /// <returns></returns>
        public bool EndOfBuffer()
        {
            return this.elements.Count == 0;
        }

        /// <summary>
        /// Gets the document deleter to allow undo.
        /// </summary>
        public IDocumentDeleter Deleter { get; private set; }

        private void ThrowIfBufferIsEmpty()
        {
            if (this.EndOfBuffer())
            {
                throw new CsException("Buffer is empty.");
            }
        }
    }
}
