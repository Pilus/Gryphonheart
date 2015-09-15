
namespace BlizzardApi.Global
{
    using CsLua.Wrapping;
    using MiscEnums;

    public partial interface IApi
    {
        string UnitName(UnitId index);
        IMultipleValues<string, string, int> UnitClass(UnitId index);
        /// <summary>
        /// Returns the GUID as a string for the specified unit matching the GUIDs used by the new combat logs
        /// </summary>
        /// <param name="unit"></param>
        /// <returns></returns>
        string UnitGUID(UnitId unit);
        /// <summary>
        /// Returns the race (Tauren, Orc, etc) of the specified unit. 
        /// </summary>
        /// <param name="unit"></param>
        /// <returns>1: The localized race of the specified unit as a string. e.g. Tauren, Orc etc. 
        /// 2: The race in english as a string. e.g Tauren, Orc etc. </returns>
        IMultipleValues<string, string> UnitRace(UnitId unit);
        /// <summary>
        /// Returns the gender of the specified unit. 
        /// </summary>
        /// <param name="unit"></param>
        /// <returns>Number: ◾ 1 = Neutrum / Unknown, 2 = Male, 3 = Female</returns>
        int UnitSex(UnitId unit);
    }
}
