﻿
namespace GHD.Document.Flags
{
    using System;
    using System.Collections.Generic;
    using GH;
    using GH.Menu;

    using GHD.Document.Data;

    public static class FlagsManager
    {
        public static IFlags LoadFlags(List<IFlagData> flagData)
        {
            var flags = new Flags();
            foreach (var data in flagData)
            {
                ChangeFlag(flags, data.FlagType, data.Details);
            }
            return flags;
        }

        public static void ChangeFlag(IFlags flags, FlagType type, object details)
        {
            switch (type)
            {
                case FlagType.Alignment:
                    flags.Alignment = (Alignment) Enum.Parse(typeof(Alignment), (string)details);
                    break;
                case FlagType.BackgroundColor:
                    if (details == null)
                    {
                        flags.BackgroundColor = null;
                        return;
                    }
                    if (!(details is Color))
                    {
                        throw new Exception("Expected Color as BackgroundColor");
                    }
                    flags.BackgroundColor = (Color)details;
                    break;
                case FlagType.Bold:
                    flags.Bold = (bool)details;
                    break;
                case FlagType.Color:
                    if (!(details is Color))
                    {
                        throw new Exception("Expected Color as Color");
                    }
                    flags.Color = (Color)details;
                    break;
                case FlagType.Font:
                    flags.Font = (string)details;
                    break;
                case FlagType.FontSize:
                    flags.FontSize = (int)details;
                    break;
                case FlagType.Strikethrough:
                    flags.Strikethrough = (bool) details;
                    break;
                case FlagType.UnderLine:
                    flags.UnderLine = (bool) details;
                    break;
                default:
                    throw new Exception("Unknown flag type: " + type);
            }
        }
    }
}
