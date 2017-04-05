
namespace GHD.Document
{
    using GHD.Document.AltElements;
    using GHD.Document.Flags;

    public interface ICursor
    {
        IElement CurrentElement { get; set; }

        IFlags CurrentFlags { get; set; }
    }
}
