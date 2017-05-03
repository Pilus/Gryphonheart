namespace GHD.Document.Navigation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class Navigator : INavigator
    {
        private readonly IDictionary<NavigationType, INavigationStrategy> strategiesByType;

        public Navigator(INavigationStrategyFactory strategyFactory)
        {
            this.strategiesByType = strategyFactory.GetStrategies().ToDictionary(strategy => strategy.NavigationType, stategy => stategy);
        }

        public void Navigate(ICursor cursor, NavigationType navigationType)
        {
            if (!this.strategiesByType.ContainsKey(navigationType))
                throw new NotImplementedException("Cursor handling of " + navigationType);
            this.strategiesByType[navigationType].Navigate(cursor);
        }
    }
}