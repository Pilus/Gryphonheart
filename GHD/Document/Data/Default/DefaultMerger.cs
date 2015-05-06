namespace GHD.Document.Data.Default
{
    using CsLua.Collection;

    public class DefaultMerger
    {
        public static CsLuaList<IFlagData> RemoveDefaults(CsLuaList<IFlagData> flags)
        {
            return
                flags.Where(
                    flag =>
                        !Defaults.DocumentWideFlags.Any(
                            defaultFlag => defaultFlag.FlagType == flag.FlagType && defaultFlag.Details == flag.Details));
        }

        public static CsLuaList<IFlagData> AddDefaults(CsLuaList<IFlagData> flags)
        {
            return
                flags.AddRange(
                    Defaults.DocumentWideFlags.Where(
                        defaultFlag => !flags.Any(flag => flag.FlagType == defaultFlag.FlagType)));
        }
    }
}
