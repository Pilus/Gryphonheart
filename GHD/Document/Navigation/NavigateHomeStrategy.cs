namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;

    public class NavigateHomeStrategy : NavigateStrategyBase
    {
        public NavigateHomeStrategy() : base(NavigationType.Home)
        {
        }

        public override void Navigate(ICursor cursor)
        {
            cursor.CurrentElement = HorizontalGroup.GetFirstElementInSameGroup(cursor.CurrentElement);
            (cursor.CurrentElement as INavigableElement)?.ResetInsertPosition(false);
        }
    }
}