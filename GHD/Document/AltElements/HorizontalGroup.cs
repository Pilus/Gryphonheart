namespace GHD.Document.AltElements
{
    using BlizzardApi.Global;

    public class HorizontalGroup : IGroup
    {
        private double widthConstraint;

        private double heightConstraint;

        public HorizontalGroup(double widthConstraint, double heightConstraint)
        {
            this.widthConstraint = widthConstraint;
            this.heightConstraint = heightConstraint;
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
                    element.SetPoint(widthConsumed, 0, Global.Frames.UIParent); // TODO: set to group parent. Change y offset to provided group offset.
                    widthConsumed += element.GetWidth();
                    element.SizeChanged = false;
                    element = element.Next;

                    if (element == null || element.Group != this)
                    {
                        // TODO: Find out how to know when to trigger update layout of group of last.next. Maybe just check if the first element would fit in.
                        return;
                    }
                }
            }

            if (element is ISplitableElement)
            {
                // Try and split the first element that is too wide
                var newElement = ((ISplitableElement) element).SplitFromFront(this.widthConstraint - widthConsumed);
                newElement.SetPoint(widthConsumed, 0, Global.Frames.UIParent); // TODO: set to group parent. Change y offset to provided group offset.
                newElement.SizeChanged = false;
            }
            
            // TODO: Place elements into next group.
            IGroup group;
            if (element.Next != null)
            {
                group = element.Group;
            }
            else
            {
                group = new HorizontalGroup(this.widthConstraint, this.heightConstraint); // TODO: do this in the vertical group
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

            while (element.Group == horizontalGroup && element.Next != null)
            {
                element = element.Next;
            }

            return element;
        }

        public static IElement GetFirstElementInSameGroup(IElement element)
        {
            var horizontalGroup = element.Group;

            while (element.Group == horizontalGroup && element.Prev != null)
            {
                element = element.Prev;
            }

            return element;
        }
    }
}