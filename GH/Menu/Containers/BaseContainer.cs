namespace GH.Menu.Containers
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using CsLua.Collection;
    using Objects.Page;

    public abstract class BaseContainer<T, TProfile> : BaseElement, IContainer<T> where T : IMenuRegion
    {
        protected CsLuaList<T> Content;

        public BaseContainer(string typeName) : base(typeName)
        {
            this.Content = new CsLuaList<T>();
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
            this.Content = new CsLuaList<T>();

            var containerProfile = (IContainerProfile<TProfile>)profile;
            containerProfile.Foreach(p =>
            {
                var regionProfile = (IMenuRegionProfile)p;
                var region = (T)handler.CreateRegion(regionProfile);
                this.Content.Add(region);
            });
            
        }

        public override void Recycle()
        {
            this.Content.Foreach(o => o.Recycle());
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
            this.Content.Foreach(c => c.ApplyTheme(theme));
        }

        public override void Clear()
        {
            this.Content.Foreach(c => c.Clear());
        }
    }
}
