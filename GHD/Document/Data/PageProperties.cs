

namespace GHD.Document.Data
{
    public struct PageProperties : IPageProperties
    {
        public double Width { get; set; }
        public double Height { get; set; }
        public double EdgeTop { get; set; }
        public double EdgeBottom { get; set; }
        public double EdgeLeft { get; set; }
        public double EdgeRight { get; set; }
    }
}
