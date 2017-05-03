namespace GHD.Document.Navigation
{
    public abstract class NavigateStrategyBase : INavigationStrategy
    {
        protected NavigateStrategyBase(NavigationType navigationType)
        {
            this.NavigationType = navigationType;
        }

        public abstract void Navigate(ICursor cursor);

        public NavigationType NavigationType { get; }
    }
}