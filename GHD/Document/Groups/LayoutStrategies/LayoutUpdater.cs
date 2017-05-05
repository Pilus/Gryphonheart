namespace GHD.Document.Groups.LayoutStrategies
{
    public class LayoutUpdater : ILayoutUpdateStrategy
    {
        private readonly ForwardLayoutUpdateStrategy forwardStrategy;

        private readonly BackflowLayoutUpdateStrategy backflowStrategy;

        private readonly OverflowLayoutUpdateStrategy overflowStrategy;

        public LayoutUpdater()
        {
            this.forwardStrategy = new ForwardLayoutUpdateStrategy();
            this.backflowStrategy = new BackflowLayoutUpdateStrategy();
            this.overflowStrategy = new OverflowLayoutUpdateStrategy();

            this.forwardStrategy.StrategyExecutedAfterUpdate = this.overflowStrategy;
            this.backflowStrategy.StrategyExecutedOnPreviousGroup = this;
            this.overflowStrategy.StrategyExecutedOnNextGroup = this.forwardStrategy;
        }

        public void UpdateLayout(IGroup group)
        {
            this.backflowStrategy.UpdateLayout(group);

            if (group.FirstElement == null)
            {
                // The group is now empty
                return;
            }

            this.forwardStrategy.UpdateLayout(group);
        }
    }
}