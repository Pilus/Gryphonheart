namespace GH.Menu
{
    using CsLua.Collection;

    public interface IRecyclePool
    {
        IElement Retrieve(IElementProfile profile);
        void Store(IElement element);
    }
}
