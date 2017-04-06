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
            element.Prev = this;
            element.Next = this.Prev;
            element.Group = this.Group;
            this.Prev.Next = element;
            this.Prev = element;
            element.Group = this.Group;
        }

        public void InsertElementBefore(IElement element)
        {
            element.Next = this;
            element.Prev = this.Next;
            element.Group = this.Group;
            this.Next.Prev = element;
            this.Next = element;
            element.Group = this.Group;
        }

        public abstract double GetWidth();

        public abstract double GetHeight();

        public bool SizeChanged { get; set; }

        public abstract void SetPoint(double xOff, double yOff, IRegion parent);
    }
}