
namespace GHD.Document.Data
{
    using CsLua.Collection;

    public interface IDocumentData
    {
        string Title { get; set; }

        CsLuaList<string> TextPieces { get; set; }

        CsLuaList<IRangedFlagData> Flags { get; set; }

        CsLuaList<IElementData> Elements { get; set; }

        CsLuaList<IFlagData> DocumentWideFlags { get; set; }
    }
}
