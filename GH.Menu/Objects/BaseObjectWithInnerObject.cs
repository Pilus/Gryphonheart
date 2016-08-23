
namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers;
    using GH.Menu.Theme;

    public abstract class BaseObjectWithInnerObject : BaseElement, IMenuObject, IContainer<IMenuObject>
    {
        protected IMenuObject Inner;

        public BaseObjectWithInnerObject(IWrapper wrapper) : base("Wrapper", wrapper)
        {
            
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.Inner = (IMenuObject)handler.CreateRegion((IObjectProfile)profile, true);
            this.Inner.Prepare(profile, handler);
        }

        public virtual void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);
            this.Inner.SetPosition(this.Frame, 0, 0, width, height);
        }

        public virtual double? GetPreferredWidth()
        {
            return this.Inner.GetPreferredWidth();
        }

        public virtual double? GetPreferredHeight()
        {
            return this.Inner.GetPreferredHeight();
        }

        public ObjectAlign GetAlignment()
        {
            return this.Inner.GetAlignment();
        }

        public string GetId()
        {
            return this.Inner.GetId();
        }

        public virtual double GetPreferredOffsetX()
        {
            return this.Inner.GetPreferredOffsetX();
        }

        public virtual double GetPreferredOffsetY()
        {
            return this.Inner.GetPreferredOffsetY();
        }

        public override void Clear()
        {
            this.Inner.Clear();
        }

        public override void ApplyTheme(IMenuTheme theme)
        {
            this.Inner.ApplyTheme(theme);
        }

        private static MenuException Unsupported()
        {
            return new MenuException("BaseObjectWithInnerObject does not support element changes");
        }

        public void AddElement(IMenuObject element)
        {
            throw Unsupported();
        }

        public void AddElement(IMenuObject element, int index)
        {
            throw Unsupported();
        }

        public void RemoveElement(int index)
        {
            throw Unsupported();
        }

        public int GetNumElements()
        {
            throw Unsupported();
        }

        public IMenuObject GetElement(int index)
        {
            throw Unsupported();
        }

        public void SetValue(string id, object value)
        {
            throw Unsupported();
        }

        public object GetValue(string id)
        {
            throw Unsupported();
        }

        public IMenuObject GetFrameById(string id)
        {
            if (this.Inner is IContainer)
            {
                var res = ((IContainer)this.Inner).GetFrameById(id);
                if (res != null)
                {
                    return res;
                }
            }

            if (id.Equals(this.Inner.GetId()))
            {
                return this.Inner;
            }

            return null;
        }
    }
}
