
namespace BlizzardApi.Global
{
    using CsLua.Wrapping;
    using MiscEnums;

    public partial interface IApi
    {
        string UnitName(UnitId index);
        IMultipleValues<string, string, int> UnitClass(UnitId index); 
    }
}
