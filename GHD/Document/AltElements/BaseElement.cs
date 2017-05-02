namespace GHD.Document.AltElements
{
    using BlizzardApi.WidgetInterfaces;

    using GHD.Document.Flags;

    public abstract class BaseElement : IElement
    {
        public IElement Prev { get; set; }

        public IElement Next { get; set; }

        public IGroup Group { get; set; }

        public abstract IFlags Flags { get; }

        public void InsertElementAfter(IElement element)
        {
            element.Group = this.Group;

            var next = this.Next;

            element.Prev = this;
            element.Next = next;
            this.Next = element;
            if (next != null)
            {
                next.Prev = element;
            }
        }

        public void InsertElementBefore(IElement element)
        {
            element.Group = this.Group;

            var prev = this.Prev;

            element.Next = this;
            element.Prev = prev;
            this.Prev = element;
            if (prev != null)
            {
                prev.Next = element;
            }
        }

        public abstract double GetWidth();

        public abstract double GetHeight();

        public bool SizeChanged { get; set; }

        public abstract void SetPoint(double xOff, double yOff, IRegion parent);


        protected ICursor Cursor;
        public virtual void GainCursor(ICursor cursor)
        {
            this.Cursor = cursor;
        }

        public virtual ICursor LooseCursor()
        {
            var cursor = this.Cursor;
            this.Cursor = null;
            return cursor;
        }

        public virtual bool HasCursor()
        {
            return this.Cursor != null;
        }
    }
}