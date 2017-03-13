
namespace GHD.Document.Buffer
{
    using Containers;
    using Elements;
    using Flags;

    /// <summary>
    /// Interface for document buffer.
    /// </summary>
    public interface IDocumentBuffer
    {
        /// <summary>
        /// Appends a text with a given set of flags to the buffer. Intended for the remaining text in a text element when inserting inside a text element.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="flags"></param>
        void Append(string text, IFlags flags);

        /// <summary>
        /// Appends a whole element to the buffer.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="element"></param>
        void Append(string text, IElement element);  

        /// <summary>
        /// Gets the remaining text that fits the flag, until a limit by the maxLength.
        /// </summary>
        /// <param name="maxLength"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        string Take(IDimensionConstraint constraint, IFlags flags);

        /// <summary>
        /// Peeks the remaining text that fits the flag, until a limit by the maxLength.
        /// </summary>
        /// <param name="constraint"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        string Peek(IDimensionConstraint constraint, IFlags flags);

        /// <summary>
        /// Gets the next element if it fits within the maxLength.
        /// </summary>
        /// <param name="constraint"></param>
        /// <returns></returns>
        IElement Take(IDimensionConstraint constraint);

        /// <summary>
        /// Peek at the next element if it fits within the given w
        /// </summary>
        /// <param name="constraint"></param>
        /// <returns></returns>
        IElement Peek(IDimensionConstraint constraint);
        
        /// <summary>
        /// Returns weather the end of the buffer has been reached. 
        /// </summary>
        /// <returns></returns>
        bool EndOfBuffer();

        /// <summary>
        /// Gets the document deleter to allow undo.
        /// </summary>
        IDocumentDeleter Deleter { get; }

    }
}
