namespace GH.Menu.Containers
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects;
    using GH.Menu.Theme;
    using CsLua.Collection;

    public abstract class BaseContainer<T> : BaseElement, IContainer<T> where T : IMenuRegion
    {
        protected CsLuaList<T> content;

        public BaseContainer(string typeName) : base(typeName)
        {

        }

        public virtual void AddElement(T element)
        {
            this.content.Add(element);
        }

        public virtual void AddElement(T element, int index)
        {
            this.content.Insert(index, element);
        }

        public virtual T GetElement(int index)
        {
            return this.content[index];
        }

        public IMenuObject GetFrameById(string id)
        {
            foreach (var obj in this.content)
            {
                if (obj is IMenuObject)
                {
                    var menuObject = (IMenuObject) obj;
                    if (id.Equals(menuObject.GetId()))
                    {
                        return menuObject;
                    }
                }
                else if (obj is IContainer)
                {
                    var res = ((IContainer)obj).GetFrameById(id);
                    if (res != null)
                    {
                        return res;
                    }
                }
            }
            return null;
        }

        public virtual int GetNumElements(int index)
        {
            return this.content.Count;
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
            this.content = new CsLuaList<T>();

            var containerProfile = (IContainerProfile<T>)profile;
            containerProfile.Foreach(p =>
            {
                var regionProfile = (IMenuRegionProfile)p;
                var region = (T)handler.CreateRegion(regionProfile);
                this.content.Add(region);
                region.Prepare(regionProfile, handler);
            });
            
        }

        public override void Recycle()
        {
            this.content.Foreach(o => o.Recycle());
            base.Recycle();
        }

        public virtual void RemoveElement(int index)
        {
            this.content.RemoveAt(index);
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
            this.content.Foreach(c => c.ApplyTheme(theme));
        }

        public override void Clear()
        {
            this.content.Foreach(c => c.Clear());
        }
    }
}
