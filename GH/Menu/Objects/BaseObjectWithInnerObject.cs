
namespace GH.Menu.Objects
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;
    using GH.Menu.Containers;

    public abstract class BaseObjectWithInnerObject : BaseContainer<IMenuObject, IObjectProfile>, IMenuRegion
    {
        public BaseObjectWithInnerObject() : base("Wrapper")
        {
            
        }

        private IMenuObject GetInner()
        {
            return this.Content.First();
        }

        public abstract void SetPosition(IFrame parent, double xOff, double yOff, double width, double height);

        public virtual double? GetPreferredWidth()
        {
            return this.GetInner().GetPreferredWidth();
        }

        public virtual double? GetPreferredHeight()
        {
            return this.GetInner().GetPreferredHeight();
        }

        public override void AddElement(IMenuObject element)
        {
            this.Content.Clear();
            base.AddElement(element);
        }

        public override void AddElement(IMenuObject element, int index)
        {
            this.Content.Clear();
            base.AddElement(element, index);
        }
    }
}
