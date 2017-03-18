
namespace GHD.Document.Buffer
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Containers;
    using GHD.Document.Data;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using Lua;

    /// <summary>
    /// Document buffer is a queue for text and element, including functionality to append and get objects fitting a given dimension.
    /// </summary>
    public class DocumentBuffer : IDocumentBuffer
    {
        private List<BufferElement> elements;
        private IElementFactory elementFactory;
        private ITextScoper textScoper;

        /// <summary>
        /// Initializes a new instance of the <see cref="DocumentBuffer"/> class.
        /// </summary>
        /// <param name="elementFactory"></param>
        /// <param name="data"></param>
        public DocumentBuffer(IElementFactory elementFactory, ITextScoper textScoper, IDocumentData data = null)
        {
            // TODO: Init the document deleter
            this.Deleter = null;
            this.elements = new List<BufferElement>();
            this.elementFactory = elementFactory;
            this.textScoper = textScoper;
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
        public void Append(IElement element)
        {
            this.elements.Add(new BufferElement()
            {
                Element = element,
            });
        }

        /// <summary>
        /// Takes the remaining text that fits the flag, until a limit by the maxLength, removing that text from the buffer.
        /// </summary>
        /// <returns></returns>
        public string Take(IDimensionConstraint constraint, IFlags flags)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new Exception("A max width must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags == null || (flags != null && !first.Flags.Equals(flags)))
            {
                return null;
            }

            var text = this.textScoper.GetFittingText(first.Flags.Font, first.Flags.FontSize, first.Text, (double)constraint.MaxWidth);
            if (text == first.Text)
            {
                this.elements.RemoveAt(0);
            }
            else if (text != String.Empty)
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
        /// Takes the next element if it fits within the given constraint, removing it from the buffer.
        /// </summary>
        /// <param name="constraint">The constraint the resulting element should fit in.</param>
        /// <returns>The resulting element.</returns>
        public IElement Take(IDimensionConstraint constraint)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new Exception("A max width must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags != null)
            {
                var text = this.Take(constraint, first.Flags);
                if (text == String.Empty)
                {
                    return null;
                }

                var formattedText = (IFormattedText)elementFactory.Create(first.Flags);
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

        /// <summary>
        /// Gets the next element if it fits within the given constraint without removing it from the buffer.
        /// </summary>
        /// <param name="constraint">The constraint the resulting element should fit in.</param>
        /// <returns>The resulting element.</returns>
        public IElement Peek(IDimensionConstraint constraint)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new Exception("A max width must be provided in the constraint.");
            }

            if (constraint.MaxHeight == null)
            {
                throw new Exception("A max height must be provided in the constraint.");
            }

            var first = this.elements.First();
            if (first.Flags != null)
            {
                var text = this.Peek(constraint, first.Flags);
                if (text == String.Empty)
                {
                    return null;
                }

                var formattedText = (IFormattedText)elementFactory.Create(first.Flags);
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
        /// Peeks the remaining text that fits the flag, until a limit by the maxLength.
        /// </summary>
        /// <param name="constraint">The constraints the text must fit.</param>
        /// <param name="flags">The flags the text must fit.</param>
        /// <returns>The peeked text.</returns>
        public string Peek(IDimensionConstraint constraint, IFlags flags)
        {
            this.ThrowIfBufferIsEmpty();

            if (constraint.MaxWidth == null)
            {
                throw new Exception("A max width must be provided in the constraint.");
            }


            var first = this.elements.First();
            if (first.Flags == null || (flags != null && !first.Flags.Equals(flags)))
            {
                return null;
            }

            return this.textScoper.GetFittingText(first.Flags.Font, first.Flags.FontSize, first.Text, (double)constraint.MaxWidth);
        }

        /// <summary>
        /// Returns whether the end of the buffer has been reached. 
        /// </summary>
        /// <returns>A flag indicating if the buffer is empty.</returns>
        public bool EndOfBuffer()
        {
            return this.elements.Count == 0;
        }

        /// <summary>
        /// Gets the document deleter to allow undo.
        /// </summary>
        public IDocumentDeleter Deleter { get; private set; }

        /// <summary>
        /// Throw an exception if the buffer is empty.
        /// </summary>
        private void ThrowIfBufferIsEmpty()
        {
            if (this.EndOfBuffer())
            {
                throw new Exception("Buffer is empty.");
            }
        }
    }
}
