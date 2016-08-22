namespace GH.Menu.Containers
{
    using System.Collections.Generic;
    using System.Linq;
    using CsLuaFramework.Wrapping;
    using GH.Menu.Objects;
    using GH.Menu.Theme;

    public abstract class BaseContainer<T, TProfile> : BaseElement, IContainer<T> where T : IMenuRegion
    {
        private LayoutSettings layout;

        protected LayoutSettings Layout
        {
            get
            {
                if (!this.IsPrepared)
                {
                    throw new MenuException("Cannot get layout when container object is not prepared.");
                }
                return this.layout;
            }
            
        }
        protected List<T> Content;

        public BaseContainer(string typeName, IWrapper wrapper) : base(typeName, wrapper)
        {
            this.Content = new List<T>();
        }

        public virtual void AddElement(T element)
        {
            this.Content.Add(element);
        }

        public virtual void AddElement(T element, int index)
        {
            this.Content.Insert(index, element);
        }

        public virtual T GetElement(int index)
        {
            return this.Content[index];
        }

        public IMenuObject GetFrameById(string id)
        {
            foreach (var obj in this.Content)
            {
                if (obj is IContainer)
                {
                    var res = ((IContainer)obj).GetFrameById(id);
                    if (res != null)
                    {
                        return res;
                    }
                }

                if (obj is IMenuObject)
                {
                    var menuObject = (IMenuObject)obj;
                    if (id.Equals(menuObject.GetId()))
                    {
                        return menuObject;
                    }
                }
            }
            return null;
        }

        public virtual int GetNumElements()
        {
            return this.Content.Count;
        }

        public virtual object GetValue(string id)
        {
            var obj = this.GetFrameById(id);
            if (obj != null && obj is IMenuObjectWithValue)
            {
                return ((IMenuObjectWithValue)obj).GetValue();
            }
            return null;
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.Content = new List<T>();
            this.layout = handler.Layout;

            var containerProfile = profile as IContainerProfile<TProfile>;
            if (containerProfile == null)
            {
                return;
            }

            containerProfile.ToList().ForEach(p =>
            {
                var regionProfile = (IMenuRegionProfile)p;
                var region = (T)handler.CreateRegion(regionProfile);
                this.Content.Add(region);
                region.Prepare(regionProfile, handler);
            });
            
        }

        public override void Recycle()
        {
            this.Content.ForEach(o => o.Recycle());
            base.Recycle();
        }

        public virtual void RemoveElement(int index)
        {
            this.Content.RemoveAt(index);
        }

        public virtual void SetValue(string id, object value)
        {
            var obj = this.GetFrameById(id);
            if (obj != null && obj is IMenuObjectWithValue)
            {
                ((IMenuObjectWithValue)obj).SetValue(value);
            }
        }

        public override void ApplyTheme(IMenuTheme theme)
        {
            this.Content.ForEach(c => c.ApplyTheme(theme));
        }

        public override void Clear()
        {
            this.Content.ForEach(c => c.Clear());
        }
    }
}
