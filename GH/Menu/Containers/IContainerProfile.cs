namespace GH.Menu.Containers
{
    using CsLua.Collection;

    public interface IContainerProfile<T> : ICsLuaList<T>, IElementProfile
    {
    }
}
