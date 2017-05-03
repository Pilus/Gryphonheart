namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;

    public class NavigateUpStrategy : NavigateVerticalArrowStrategyBase
    {
        public NavigateUpStrategy() : base(NavigationType.Up)
        {
        }

        protected override IElement GetElementInOtherGroup(ICursor cursor)
        {
            var firstElement = HorizontalGroup.GetFirstElementInSameGroup(cursor.CurrentElement);
            return firstElement.Prev;
        }
    }
}