
namespace GHD.Document.Buffer
{
    using Flags;

    /// <summary>
    /// Interface for the document deleter. User for undoing a change done by <see cref="IDocumentBuffer"/>.
    /// </summary>
    public interface IDocumentDeleter
    {
        /// <summary>
        /// ??? Returns the remaining text, which was not deleted. Internally adds the info to a buffer.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        string Delete(string text, IFlags flags); 



        /// <summary>
        /// // Gets the DocumentBuffer. Used for redo.
        /// </summary>
        IDocumentBuffer DocumentBuffer { get; } 
    }
}
