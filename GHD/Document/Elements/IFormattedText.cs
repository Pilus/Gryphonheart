using BlizzardApi.WidgetInterfaces;
using GHD.Document.Buffer;
using GHD.Document.Containers;
using GHD.Document.Flags;

namespace GHD.Document.Elements
{
    public interface IFormattedText : ILinkedElement<IContainer>, IElement
    {
        bool AllowZeroPosition { get; set; }
        void SetText(string newText);
    }
}