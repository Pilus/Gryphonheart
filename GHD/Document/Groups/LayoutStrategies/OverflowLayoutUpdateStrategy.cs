namespace GHD.Document.Groups.LayoutStrategies
{
    using BlizzardApi.Global;

    using GHD.Document.Elements;

    public class OverflowLayoutUpdateStrategy : ILayoutUpdateStrategy
    {
        public ILayoutUpdateStrategy StrategyExecutedOnNextGroup { get; set; }
        public void UpdateLayout(IGroup group)
        {
            var firstElementOverflowing = this.GetFirstOverflowingElement(group);

            if (firstElementOverflowing == null)
            {
                return;
            }

            if (firstElementOverflowing is ISplitableElement)
            {
                var widthConsumed = this.GetWidthConsumedBeforeElement(group, firstElementOverflowing);
                // Try and split the first element that is too wide
                var mergeSuccessful = ((ISplitableElement)firstElementOverflowing).TryMergeSpilloverIntoNext(group.WidthConstraint - widthConsumed);
                if (mergeSuccessful)
                {
                    this.StrategyExecutedOnNextGroup.UpdateLayout(firstElementOverflowing.Next.Group);
                    return;
                }

                var newElement =
                    ((ISplitableElement)firstElementOverflowing).SplitFromFront(group.WidthConstraint - widthConsumed);
                newElement.SetPoint(widthConsumed, group.Offset, Global.Frames.UIParent);
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
                nextGroup = new HorizontalGroup(group.WidthConstraint, group.HeightConstraint, group.Offset + 15);
            }
            firstElementOverflowing.Group = nextGroup;
            firstElementOverflowing.SizeChanged = false;
            this.StrategyExecutedOnNextGroup.UpdateLayout(nextGroup);
        }

        private IElement GetFirstOverflowingElement(IGroup group)
        {
            double widthConsumed = 0;
            var element = group.FirstElement;
            while (element != null && widthConsumed + element.GetWidth() <= group.WidthConstraint)
            {
                widthConsumed += element.GetWidth();
                element = element.Next;
            }

            return element;
        }

        private double GetWidthConsumedBeforeElement(IGroup group, IElement element)
        {
            double widthConsumed = 0;
            var currentElement = group.FirstElement;
            while (currentElement != element)
            {
                widthConsumed += element.GetWidth();
                currentElement = currentElement.Next;
            }
            return widthConsumed;
        }
    }
}