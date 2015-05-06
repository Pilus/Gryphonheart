
namespace GHD.Document.Data.Default
{
    public class DefaultFlag : IFlagData
    {
        public DefaultFlag(FlagType type, object details)
        {
            this.FlagType = type;
            this.Details = details;
        }

        public FlagType FlagType { get; set; }

        public object Details { get; set; }
    }
}
