namespace CsLuaTest.Wrap
{
    public interface IInterfaceWithGenerics<T>
    {
        string Method(T value);

        T Property { get; set; }
    }
}