using BlizzardApi.WidgetInterfaces;
using GHD.Document.Buffer;

namespace GHD.Document.Containers
{
    public interface IPageCollection : IContainer
    {
        IRegion Region { get; }

        void Delete(IDocumentDeleter documentDeleter);
        double GetHeight();
        double GetWidth();
    }
}