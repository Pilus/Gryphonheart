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
            var first = GetFirstElementInSameGroup(elementInGroup);
            var last = GetLastElementInSameGroup(elementInGroup);

            first = this.UpdatePrevGroupIfRelevantAndGetNewFirst(elementInGroup, last, first);

            if (first == null)
            {
                // The group is now empty
                return;
            }

            double widthConsumed = 0;

            var element = first;

            while (true)
            {
                if (widthConsumed + element.GetWidth() > this.widthConstraint || element.GetHeight() > this.heightConstraint)
                {
                    break;
                }
                else
                {
                    element.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent); // TODO: set to group parent. Change y offset to provided group offset.
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
                newElement.SetPoint(widthConsumed, this.offset, Global.Frames.UIParent); // TODO: set to group parent. Change y offset to provided group offset.
                newElement.SizeChanged = false;

                if (element == elementInGroup)
                {
                    // The element might be the current cursor element
                }
            }
            
            // TODO: Place elements into next group.
            IGroup group;
            if (element.Next != null)
            {
                group = element.Next.Group;
            }
            else
            {
                group = new HorizontalGroup(this.widthConstraint, this.heightConstraint, this.offset + 15); // TODO: do this in the vertical group
            }
            element.Group = group;
            element.SizeChanged = false;
            group.UpdateLayout(element);
        }

        private IElement UpdatePrevGroupIfRelevantAndGetNewFirst(IElement elementInGroup, IElement last, IElement first)
        {
            if (first.Prev != null && first.Prev.SizeChanged)
            {
                first.Prev.Group.UpdateLayout(first.Prev);

                if (last.Group != this)
                {
                    // All elements of this group have been moved into the previous group
                    return null;
                }

                first = GetFirstElementInSameGroup(elementInGroup);
            }
            return first;
        }

        public static IElement GetLastElementInSameGroup(IElement element)
        {
            var horizontalGroup = element.Group;

            while (element.Next != null && element.Next.Group == horizontalGroup)
            {
                element = element.Next;
            }

            return element;
        }

        public static IElement GetFirstElementInSameGroup(IElement element)
        {
            var horizontalGroup = element.Group;

            while (element.Prev != null && element.Prev.Group == horizontalGroup)
            {
                element = element.Prev;
            }

            return element;
        }
    }
}