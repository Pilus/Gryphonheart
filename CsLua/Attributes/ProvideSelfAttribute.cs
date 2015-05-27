
namespace CsLua.Attributes
{
    using System;

    [AttributeUsage(AttributeTargets.Interface, Inherited = true, AllowMultiple = false)]
    public sealed class ProvideSelfAttribute : Attribute
    {
    }
}
