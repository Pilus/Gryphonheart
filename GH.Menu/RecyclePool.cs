namespace GH.Menu
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    using CsLuaFramework.Wrapping;

    public class RecyclePool : IRecyclePool
    {
        private readonly List<IElement> list;

        private readonly IWrapper wrapper;

        public RecyclePool(IWrapper wrapper)
        {
            this.wrapper = wrapper;
            this.list = new List<IElement>();
        }

        public IElement Retrieve(Type type)
        {
            return this.list.FirstOrDefault(e => e.GetType() == type) ?? (IElement)Activator.CreateInstance(type, this.wrapper);
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