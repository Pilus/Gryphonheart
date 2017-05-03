namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;

    public abstract class NavigateHorizontalArrowStrategyBase : NavigateStrategyBase
    {
        protected NavigateHorizontalArrowStrategyBase(NavigationType navigationType) : base(navigationType)
        {
        }

        public override void Navigate(ICursor cursor)
        {
            bool internalNavigationSuccessful = (cursor.CurrentElement as INavigableElement)?.Navigate(this.NavigationType) ??
                                                false;

            if (!internalNavigationSuccessful && this.TargetElement(cursor) != null)
            {
                cursor.CurrentElement = this.TargetElement(cursor);
                (cursor.CurrentElement as INavigableElement)?.ResetInsertPosition(this.TargetElementInsertPositionAtEnd);
            }
        }

        protected abstract IElement TargetElement(ICursor cursor);

        protected abstract bool TargetElementInsertPositionAtEnd { get; }
    }
}