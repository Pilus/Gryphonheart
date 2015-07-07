
namespace BlizzardApi.Global
{
    using System;

    partial interface IApi
    {
        object GetGlobal(string index);

        object GetGlobal(string index, Type type);

        void SetGlobal(string index, object value);
    }
}
