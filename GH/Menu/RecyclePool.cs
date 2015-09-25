using System;

namespace GH.Menu
{
    using CsLua.Collection;

    public class RecyclePool : IRecyclePool
    {
        private CsLuaList<IElement> list = new CsLuaList<IElement>();

        public IElement Retrieve(Type type)
        {
            return this.list.FirstOrDefault(e => e.GetType() == type) ?? (IElement)Activator.CreateInstance(type);
        }

        public void Store(IElement element)
        {
            if (!this.list.Contains(element))
            {
                this.list.Add(element);
            }
        }
    }
}