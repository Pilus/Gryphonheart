
namespace GH.Menu.Objects
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public abstract class BaseObjectWithInnerObject : IMenuObject
    {
        private IMenuObject innerObject;

        public BaseObjectWithInnerObject(IMenuObject innerObject)
        {
            this.innerObject = innerObject;
        }

        public virtual ObjectAlign GetAlignment()
        {
            return this.innerObject.GetAlignment();
        }

        public virtual string GetLabel()
        {
            return this.innerObject.GetLabel();
        }

        public virtual double GetPreferredCenterX()
        {
            return this.innerObject.GetPreferredCenterX();
        }

        public virtual double GetPreferredCenterY()
        {
            return this.innerObject.GetPreferredCenterY();
        }

        public virtual object GetValue()
        {
            return this.innerObject.GetValue();
        }

        public virtual void Force(object value)
        {
            this.innerObject.Force(value);
        }

        public virtual void Clear()
        {
            this.innerObject.Clear();
        }

        public virtual void SetPosition(double xOff, double yOff, double width, double height)
        {
            this.innerObject.SetPosition(xOff, yOff, width, height);
        }

        public virtual double? GetPreferredWidth()
        {
            return this.innerObject.GetPreferredWidth();
        }

        public virtual double? GetPreferredHeight()
        {
            return this.innerObject.GetPreferredHeight();
        }

        public IFrame Frame { get; protected set; }
    }
}
