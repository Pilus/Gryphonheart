namespace GHD.Document.Groups.LayoutStrategies
{
    using BlizzardApi.Global;

    public class ForwardLayoutUpdateStrategy : ILayoutUpdateStrategy
    {
        public ILayoutUpdateStrategy StrategyExecutedAfterUpdate { get; set; }
        public void UpdateLayout(IGroup group)
        {
            var element = group.FirstElement;
            double widthConsumed = 0;

            while (true)
            {
                if (widthConsumed + element.GetWidth() > group.WidthConstraint || element.GetHeight() > group.HeightConstraint)
                {
                    break;
                }

                element.SetPoint(widthConsumed, group.Offset, Global.Frames.UIParent);
                widthConsumed += element.GetWidth();
                element.SizeChanged = false;
                element = element.Next;

                if (element == null || element.Group != group)
                {
                    // TODO: Find out how to know when to trigger update layout of the group of last.next. Maybe just check if the first element would fit in.
                    return;
                }
            }

            this.StrategyExecutedAfterUpdate.UpdateLayout(group);
        }
    }
}