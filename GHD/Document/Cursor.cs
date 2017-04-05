
namespace GHD.Document
{
    using GHD.Document.AltElements;
    using GHD.Document.Flags;

    public class Cursor : ICursor
    {
        private IFlags currentFlags;

        public IElement CurrentElement { get; set; }

        public IFlags CurrentFlags
        {
            get { return this.currentFlags ?? this.CurrentElement.Flags; }
            set { this.currentFlags = value; }
        }
    }
}
