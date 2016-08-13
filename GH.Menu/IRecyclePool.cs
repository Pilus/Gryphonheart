namespace GH.Menu
{
    using System;

    public interface IRecyclePool
    {
        IElement Retrieve(Type type);
        void Store(IElement element);
    }
}
