
namespace CsLuaTest.Wrap
{
    using CsLuaAttributes;

    [ProvideSelf]
    public interface ISetSelfInterface
    {
        string Method(string arg1);
    }
}
