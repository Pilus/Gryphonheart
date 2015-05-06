
namespace GHD.Document.Buffer
{
    using GHD.Document.Elements;
    using GHD.Document.Flags;

    public struct BufferElement
    {
        public string Text;
        public IFlags Flags;
        public IElement Element;
    }
}
