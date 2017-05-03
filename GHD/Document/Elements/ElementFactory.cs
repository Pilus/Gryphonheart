namespace GHD.Document.Elements
{
    using GHD.Document;
    using GHD.Document.Data;
    using GHD.Document.Flags;

    internal class ElementFactory : IElementFactory
    {
        private readonly ITextScoper textScoper;

        private readonly IElementFrameFactory elementFrameFactory;

        private readonly IPageProperties pageProperties;

        public ElementFactory(ITextScoper textScoper, IElementFrameFactory elementFrameFactory, IPageProperties pageProperties)
        {
            this.textScoper = textScoper;
            this.elementFrameFactory = elementFrameFactory;
            this.pageProperties = pageProperties;
        }

        public IElement CreateText(IFlags flags, string text)
        {
            return new TextElement(this.textScoper, flags, text);
        }
    }
}