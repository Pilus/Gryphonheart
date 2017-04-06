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

            if (first.Prev != null && first.Prev.SizeChanged)
            {
                first.Prev.Group.UpdateLayout(first.Prev);

                if (last.Group != this)
                {
                    // All elements of this group have been moved into the previous group
                    return;
                }

                first = GetFirstElementInSameGroup(elementInGroup);
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
                    element.SetPoint(widthConsumed, 0, Global.Frames.UIParent); // TODO: set to group parent. Change offset to provided group offset.
                    widthConsumed += element.GetWidth();
                    element = element.Next;

                    if (element == null || element.Group != this)
                    {
                        // TODO: Find out how to know when to trigger update layout of group of last.next. Maybe just check if the first element would fit in.
                        return;
                    }
                }
            }

            // TODO: Try and split the first element that is too wide
            // TODO: Place elements into next group.
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