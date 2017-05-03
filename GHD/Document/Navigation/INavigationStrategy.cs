namespace GHD.Document.Navigation
{
    public interface INavigationStrategy
    {
        void Navigate(ICursor cursor);
        NavigationType NavigationType { get; }
    }
}