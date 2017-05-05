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
        public void UpdateLayout()
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

                element.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent);
                widthConsumed += element.GetWidth();
                element.SizeChanged = false;
                element = element.Next;

                if (element == null || element.Group != this)
                {
                    // TODO: Find out how to know when to trigger update layout of the group of last.next. Maybe just check if the first element would fit in.
                    return;
                }
            }

            this.UpdateOverflow(element, widthConsumed);
        }

        private void UpdateOverflow(IElement firstElementOverflowing, double widthConsumed)
        {
            if (firstElementOverflowing is ISplitableElement)
            {
                // Try and split the first element that is too wide
                var mergeSuccessful = ((ISplitableElement)firstElementOverflowing).TryMergeSpilloverIntoNext(this.widthConstraint - widthConsumed);
                if (mergeSuccessful)
                {
                    (firstElementOverflowing.Next.Group as HorizontalGroup).UpdateLayoutForwardOnly();
                    return;
                }

                var newElement =
                    ((ISplitableElement) firstElementOverflowing).SplitFromFront(this.widthConstraint - widthConsumed);
                newElement.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent);
                newElement.SizeChanged = false;
            }

            // Place elements into next group.
            IGroup nextGroup;
            if (firstElementOverflowing.Next != null)
            {
                nextGroup = firstElementOverflowing.Next.Group;
            }
            else
            {
                nextGroup = new HorizontalGroup(this.widthConstraint, this.heightConstraint, this.offset + 15);
            }
            firstElementOverflowing.Group = nextGroup;
            firstElementOverflowing.SizeChanged = false;
            (nextGroup as HorizontalGroup)?.UpdateLayoutForwardOnly();
        }

        private void UpdatePrevGroupIfRelevant()
        {
            var first = this.FirstElement;
            if (first.Prev != null && first.Prev.SizeChanged)
            {
                first.Prev.Group.UpdateLayout();
            }
        }
    }
}