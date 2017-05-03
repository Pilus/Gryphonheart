namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;

    public class NavigateRightStrategy : NavigateHorizontalArrowStrategyBase
    {
        public NavigateRightStrategy() : base(NavigationType.Right)
        {
        }

        protected override IElement TargetElement(ICursor cursor)
        {
            return cursor.CurrentElement.Next;
        }

        protected override bool TargetElementInsertPositionAtEnd => false;
    }
}