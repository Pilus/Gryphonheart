namespace CsLuaTest.Wrap
{
    using CsLua;
    using CsLua.Wrapping;

    public interface IInterfaceWithMultipleReturnValues<T>
    {
        IMultipleValues<string, int, T> Method();
    }
}