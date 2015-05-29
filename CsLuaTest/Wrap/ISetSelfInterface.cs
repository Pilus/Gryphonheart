


namespace CsLuaTest.Wrap
{
    using CsLua.Attributes;

    [ProvideSelf]
    public interface ISetSelfInterface
    {
        string Method(string arg1);
    }
}
