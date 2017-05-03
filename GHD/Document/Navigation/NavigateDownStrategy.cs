namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;

    public class NavigateDownStrategy : NavigateVerticalArrowStrategyBase
    {
        public NavigateDownStrategy() : base(NavigationType.Down)
        {
        }

        protected override IElement GetElementInOtherGroup(ICursor cursor)
        {
            var lastElement = cursor.CurrentElement.Group.LastElement;
            return lastElement.Next;
        }
    }
}