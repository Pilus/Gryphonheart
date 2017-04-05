namespace GHD.Document.Elements
{
    using GHD.Document;
    using GHD.Document.Containers;
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

        public IElement Create(IFlags flags)
        {
            return new FormattedText(flags, this.elementFrameFactory, this.textScoper);
        }

        public ILine CreateLine(IFlags flags)
        {
            return new Line(flags, this);
        }

        public IPage CreatePage(IFlags flags)
        {
            return new Page(flags, this.pageProperties, this);
        }

        public IPageCollection CreatePageCollection(IFlags flags)
        {
            return new PageCollection(flags, this);
        }
    }
}