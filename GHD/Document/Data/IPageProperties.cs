
namespace GHD.Document.Data
{
    public interface IPageProperties
    {
        double Width { get; set; }
        double Height { get; set; }
        double EdgeTop { get; set; }
        double EdgeBottom { get; set; }
        double EdgeLeft { get; set; }
        double EdgeRight { get; set; }
    }
}
