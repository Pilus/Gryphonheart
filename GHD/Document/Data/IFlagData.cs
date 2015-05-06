
namespace GHD.Document.Data
{
    public interface IFlagData
    {
        FlagType FlagType { get; set; }

        object Details { get; set; }
    }
}
