
namespace BlizzardApi.Global
{
    partial interface IApi
    {
        object GetGlobal(string index);

        void SetGlobal(string index, object value);
    }
}
