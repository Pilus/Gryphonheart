
namespace GHD.Document.Data
{
    using System.Collections.Generic;

    public interface IDocumentData
    {
        string Title { get; set; }

        List<string> TextPieces { get; set; }

        List<IRangedFlagData> Flags { get; set; }

        List<IElementData> Elements { get; set; }

        List<IFlagData> DocumentWideFlags { get; set; }
    }
}
