namespace GHD.Document.Groups
{
    using BlizzardApi.Global;
    using GHD.Document.Elements;

    public class HorizontalGroup : IGroup
    {
        private readonly double widthConstraint;

        private readonly double heightConstraint;

        private readonly double offset;

        public HorizontalGroup(double widthConstraint, double heightConstraint, double offset)
        {
            this.widthConstraint = widthConstraint;
            this.heightConstraint = heightConstraint;
            this.offset = offset;
        }

        public VerticalGroup Group { get; set; }
        public void UpdateLayout(IElement elementInGroup)
        {
            this.UpdatePrevGroupIfRelevant();

            if (this.FirstElement == null)
            {
                // The group is now empty
                return;
            }

            this.UpdateLayoutForwardOnly();
        }

        public IElement FirstElement { get; set; }
        public IElement LastElement { get; set; }

        public void UpdateLayoutForwardOnly()
        {
            var element = this.FirstElement;
            double widthConsumed = 0;

            while (true)
            {
                if (widthConsumed + element.GetWidth() > this.widthConstraint || element.GetHeight() > this.heightConstraint)
                {
                    break;
                }
                else
                {
                    element.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent);
                        // TODO: set to group parent. Change y offset to provided group offset.
                    widthConsumed += element.GetWidth();
                    element.SizeChanged = false;
                    element = element.Next;

                    if (element == null || element.Group != this)
                    {
                        // TODO: Find out how to know when to trigger update layout of the group of last.next. Maybe just check if the first element would fit in.
                        return;
                    }
                }
            }

            if (element is ISplitableElement)
            {
                // Try and split the first element that is too wide
                var newElement = ((ISplitableElement) element).SplitFromFront(this.widthConstraint - widthConsumed);
                newElement.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent);
                    // TODO: set to group parent. Change y offset to provided group offset.
                newElement.SizeChanged = false;
            }

            // TODO: Place elements into next group.
            IGroup group;
            if (element.Next != null)
            {
                group = element.Next.Group;
            }
            else
            {
                group = new HorizontalGroup(this.widthConstraint, this.heightConstraint, this.offset + 15);
                    // TODO: do this in the vertical group
            }
            element.Group = group;
            element.SizeChanged = false;
            (group as HorizontalGroup)?.UpdateLayoutForwardOnly();
        }

        private void UpdatePrevGroupIfRelevant()
        {
            var first = this.FirstElement;
            if (first.Prev != null && first.Prev.SizeChanged)
            {
                first.Prev.Group.UpdateLayout(first.Prev);
            }
        }
    }
}