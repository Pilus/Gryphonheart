namespace GHD.Document.Groups.LayoutStrategies
{
    public class BackflowLayoutUpdateStrategy : ILayoutUpdateStrategy
    {
        public ILayoutUpdateStrategy StrategyExecutedOnPreviousGroup { get; set; }
        public void UpdateLayout(IGroup group)
        {
            var first = group.FirstElement;
            if (first.Prev != null && first.Prev.SizeChanged)
            {
                this.StrategyExecutedOnPreviousGroup.UpdateLayout(first.Prev.Group);
            }
        }
    }
}