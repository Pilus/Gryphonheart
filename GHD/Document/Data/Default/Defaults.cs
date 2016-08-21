

namespace GHD.Document.Data.Default
{
    using System.Collections.Generic;
    using GH.Menu;

    public static class Defaults
    {
        public static List<IFlagData> DocumentWideFlags = new List<IFlagData>()
        {
            new DefaultFlag(FlagType.Alignment, "Left"),
            new DefaultFlag(FlagType.BackgroundColor, null),
            new DefaultFlag(FlagType.Bold, false),
            new DefaultFlag(FlagType.Color, new Color(0.18, 0.12, 0.06)),
            new DefaultFlag(FlagType.Font, "Fonts\\MORPHEUS.TTF"),
            new DefaultFlag(FlagType.FontSize, 14),
            new DefaultFlag(FlagType.Strikethrough, false),
            new DefaultFlag(FlagType.UnderLine, false),
        };

        public static IPageProperties PageProperties
        {
            get
            {
                return new PageProperties()
                {
                    EdgeTop = 10,
                    EdgeBottom = 10,
                    EdgeLeft = 10,
                    EdgeRight = 10,
                    Height = 200,
                    Width = 100,
                };
            }
        }

    
    }
}
