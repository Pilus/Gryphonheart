
namespace GH.Menu.Objects
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using DropDown.CustomDropDown;
    using Dummy;
    using EditBox;
    using Line;
    using Lua;
    using Panel;
    using Text;

    public abstract class BaseObject : IMenuObject
    {
        private readonly IObjectProfile profile;
        private readonly IMenuContainer parent;
        private readonly LayoutSettings settings;

        public IFrame Frame { get; protected set; }

        protected BaseObject(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            this.profile = profile;
            this.parent = parent;
            this.settings = settings;
        }

        public static string UniqueName(string type)
        {
            var c = 1;
            while (true)
            {
                var n = type + Strings.tostring(c);
                var obj = Global.Api.GetGlobal(n);
                if (obj == null)
                {
                    return n;
                }
                c++;
            }
        }

        private static readonly CsLuaDictionary<string, Func<IObjectProfile, IMenuContainer, LayoutSettings, IMenuObject>>
            MenuInitializationMapping = new CsLuaDictionary<string, Func<IObjectProfile, IMenuContainer, LayoutSettings, IMenuObject>>()
            {
                { PanelObject.Type, PanelObject.Initialize },
                { TextObject.Type, TextObject.Initialize },
                { CustomDropDownObject.Type, CustomDropDownObject.Initialize },
                { DummyObject.Type, DummyObject.Initialize },
                { EditBoxObject.Type, EditBoxObject.Initialize },
                { "EditField", DummyObject.Initialize },
                { "Button", DummyObject.Initialize },
                { "ButtonWithDropDown", DummyObject.Initialize },
            };

        public static IMenuObject CreateMenuObject(IObjectProfile profile, IMenuContainer parent, LayoutSettings layoutSettings)
        {
            if (MenuInitializationMapping.ContainsKey(profile.type))
            {
                var obj = MenuInitializationMapping[profile.type](profile, parent, layoutSettings);
                if (profile is IObjectProfileWithText)
                {
                    obj = new BaseObjectWithTextLabel((IObjectProfileWithText)profile, parent, layoutSettings, obj);
                }

                return obj;
            }
            //return GHMStub.NewObject(profile, parent.Frame.self, layoutSettings);
            throw new CsException("Unknown object profile: " + profile.type);
        }

        protected void SetUpTabbableObject(ITabableObject obj)
        {
            if (this.settings.TabOrder == null)
            {
                this.settings.TabOrder = new TabOrder();
            }
            this.settings.TabOrder.AddObject(obj);

            obj.SetScript(EditBoxHandler.OnTabPressed, () =>
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
        }

        public virtual ObjectAlign GetAlignment()
        {
            return this.profile.align;
        }

        public virtual IMenuObject GetFrameById(string id)
        {
            return this.profile.label == id ? this : null;
        }

        public virtual void Clear()
        {
        }

        public virtual void SetPosition(double xOff, double yOff, double width, double height)
        {
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, this.parent.Frame, FramePoint.TOPLEFT, xOff, -yOff);
        }

        public virtual double? GetPreferredWidth()
        {
            return this.Frame.GetWidth();
        }

        public virtual double? GetPreferredHeight()
        {
            return this.Frame.GetHeight();
        }

        public abstract object GetValue();

        public abstract void SetValue(object value);


        public virtual double GetPreferredCenterX()
        {
            return 0;
        }

        public virtual double GetPreferredCenterY()
        {
            return 0;
        }
    }
}
