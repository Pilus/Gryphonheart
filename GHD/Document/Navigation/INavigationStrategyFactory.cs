namespace GHD.Document.Navigation
{
    public interface INavigationStrategyFactory
    {
        INavigationStrategy[] GetStrategies();
    }
}