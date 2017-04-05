
namespace GHD.Document
{
    using GHD.Document.AltElements;
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public interface ICursor
    {
        IElement CurrentElement { get; set; }

        IFlags CurrentFlags { get; set; }

        void Navigate(NavigationType navigationType);
    }
}
