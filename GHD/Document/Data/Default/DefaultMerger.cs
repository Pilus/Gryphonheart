namespace GHD.Document.Data.Default
{
    using System.Collections.Generic;
    using System.Linq;

    public class DefaultMerger
    {
        public static List<IFlagData> RemoveDefaults(List<IFlagData> flags)
        {
            return
                flags.Where(
                    flag =>
                        !Defaults.DocumentWideFlags.Any(
                            defaultFlag => defaultFlag.FlagType == flag.FlagType && defaultFlag.Details == flag.Details))
                            .ToList();
        }

        public static List<IFlagData> AddDefaults(List<IFlagData> flags)
        {
            flags.AddRange(
                Defaults.DocumentWideFlags.Where(
                    defaultFlag => !flags.Any(flag => flag.FlagType == defaultFlag.FlagType)));
            return flags;
        }
    }
}
