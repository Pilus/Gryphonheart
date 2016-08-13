namespace GH.Menu
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class RecyclePool : IRecyclePool
    {
        private List<IElement> list = new List<IElement>();

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