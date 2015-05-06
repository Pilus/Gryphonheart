
namespace GHD.Document.Data
{
    public interface IElementData : IRangedData
    {
        ElementType ElementType { get; set; }

        object Details { get; set; }
    }
}
