
namespace BlizzardApi.Global
{
    using System;

    partial interface IApi
    {
        object GetGlobal(string index);

        object GetGlobal(string index, Type type);

        object GetGlobal(string index, Type type, bool skipValidation);

        void SetGlobal(string index, object value);
    }
}
