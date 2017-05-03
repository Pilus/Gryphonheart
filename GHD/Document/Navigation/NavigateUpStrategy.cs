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
            var firstElement = cursor.CurrentElement.Group.FirstElement;
            return firstElement.Prev;
        }
    }
}