
namespace GH.Menu.Objects
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Button;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using DropDown.ButtonWithDropDown;
    using DropDown.CustomDropDown;
    using Dummy;
    using EditBox;
    using EditField;
    using GH.Menu.Theme;
    using Line;
    using Lua;
    using Menus;
    using Panel;
    using Text;

    public abstract class BaseObject : BaseElement, IMenuObject
    {
        private string id;
        private ObjectAlign alignment;

        public BaseObject(string typeName) : base(typeName)
        {
            
        }

        public BaseObject(string typeName, FrameType frameType, string inherits) : base(typeName, frameType, inherits)
        {

        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var objProfile = (IObjectProfile)profile;
            this.id = objProfile.label;
            this.alignment = objProfile.align;
        }

        /* TODO: Find a good way to do tab order pr. menu
        protected void SetUpTabbableObject(ITabableObject obj)
        {
            if (this.settings.TabOrder == null)
            {
                this.settings.TabOrder = new TabOrder();
            }
            this.settings.TabOrder.AddObject(obj);

            obj.SetTabAction(() =>
            {
                if (Global.Api.IsShiftKeyDown())
                {
                    var previous = this.settings.TabOrder.GetHigherObject(obj);
                    if (previous != null)
                    {
                        previous.SetFocus();
                    }
                }
                else
                {
                    var next = this.settings.TabOrder.GetLowerObject(obj);
                    if (next != null)
                    {
                        next.SetFocus();
                    }
                }
            });
        } */

        public virtual ObjectAlign GetAlignment()
        {
            return this.alignment;
        }

        public override void Clear()
        {
        }

        public override void ApplyTheme(IMenuTheme theme)
        {
            
        }

        public virtual void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);
        }

        public virtual double? GetPreferredWidth()
        {
            return this.Frame.GetWidth();
        }

        public virtual double? GetPreferredHeight()
        {
            return this.Frame.GetHeight();
        }

        public virtual double GetPreferredCenterX()
        {
            return 0;
        }

        public virtual double GetPreferredCenterY()
        {
            return 0;
        }

        public string GetId()
        {
            return this.id;
        }
    }
}
