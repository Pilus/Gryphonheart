namespace GHD.Document.Navigation
{
    public class NavigationStrategyFactory : INavigationStrategyFactory
    {
        public INavigationStrategy[] GetStrategies()
        {
            return new INavigationStrategy[]
            {
                new NavigateLeftStrategy(),
                new NavigateRightStrategy(), 
                new NavigateUpStrategy(), 
                new NavigateDownStrategy(),
                new NavigateEndStrategy(),
                new NavigateHomeStrategy(),
            };
        }
    }
}