﻿namespace GHD.Document.Elements
{
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public interface IElementFactory
    {
        IElement Create(IFlags flags);

        ILine CreateLine(IFlags flags);

        IPage CreatePage(IFlags flags);

        IPageCollection CreatePageCollection(IFlags flags);
    }
}