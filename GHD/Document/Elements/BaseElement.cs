namespace GHD.Document.Elements
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GHD.Document.Flags;
    using GHD.Document.Groups;

    public abstract class BaseElement : IElement
    {
        private IGroup group;
        public IElement Prev { get; set; }

        public IElement Next { get; set; }

        public IGroup Group
        {
            get { return this.group; }
            set
            {
                if (this.group == value)
                {
                    return;
                }

                if (this.group != null && this.group.FirstElement == this)
                {
                    // Find the new first.
                    this.group.FirstElement = this.Next?.Group == this.group ? this.Next : null;
                }

                if (this.group != null && this.group.LastElement == this)
                {
                    // Find the new last.
                    this.group.LastElement = this.Prev?.Group == this.group ? this.Prev : null;
                }

                this.group = value;

                if (this.group.FirstElement == null || this.group.FirstElement == this.Next)
                {
                    this.group.FirstElement = this;
                }

                if (this.group.LastElement == null || this.group.LastElement == this.Prev)
                {
                    this.group.LastElement = this;
                }
            }
        }

        public abstract IFlags Flags { get; }

        public void InsertElementAfter(IElement element)
        {
            var next = this.Next;

            element.Prev = this;
            element.Next = next;
            this.Next = element;
            if (next != null)
            {
                next.Prev = element;
            }

            element.Group = this.Group;
        }

        public void InsertElementBefore(IElement element)
        {
            var prev = this.Prev;

            element.Next = this;
            element.Prev = prev;
            this.Prev = element;
            if (prev != null)
            {
                prev.Next = element;
            }

            element.Group = this.Group;
        }

        public abstract double GetWidth();

        public abstract double GetHeight();

        public bool SizeChanged { get; set; }

        public abstract void SetPoint(double xOff, double yOff, IRegion parent);
    }
}