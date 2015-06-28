
namespace BlizzardApi.Global
{
    using System;

    partial interface IApi
    {
        object GetGlobal(string index);

        void SetGlobal(string index, object value);
    }
}
