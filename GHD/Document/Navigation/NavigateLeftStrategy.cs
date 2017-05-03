namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;

    public class NavigateLeftStrategy : NavigateHorizontalArrowStrategyBase
    {
        public NavigateLeftStrategy() : base(NavigationType.Left)
        {
        }

        protected override IElement TargetElement(ICursor cursor)
        {
            return cursor.CurrentElement.Prev;
        }

        protected override bool TargetElementInsertPositionAtEnd => true;
    }
}