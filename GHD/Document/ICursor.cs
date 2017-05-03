
namespace GHD.Document
{
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using GHD.Document.Navigation;

    public interface ICursor
    {
        IElement CurrentElement { get; set; }

        IFlags CurrentFlags { get; set; }

        void Navigate(NavigationType navigationType);

        void Insert(IFlags flags, string text);
    }
}
