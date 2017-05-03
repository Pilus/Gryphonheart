﻿namespace GHD.Document.Elements
{
    using BlizzardApi.WidgetInterfaces;
    using GHD.Document.Flags;
    using GHD.Document.Groups;

    public interface IElement
    {
        IElement Prev { get; set; }

        IElement Next { get; set; }

        IGroup Group { get; set; }

        IFlags Flags { get; }

        double GetWidth();

        double GetHeight();

        void InsertElementAfter(IElement element);

        void InsertElementBefore(IElement element);

        bool SizeChanged { get; set; }

        void SetPoint(double xOff, double yOff, IRegion parent);

        void GainCursor(ICursor cursor);

        ICursor LooseCursor();

        bool HasCursor();
    }
}