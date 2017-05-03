namespace GHD.Document.Navigation
{
    public interface INavigator
    {
        void Navigate(ICursor cursor, NavigationType navigationType);
    }
}