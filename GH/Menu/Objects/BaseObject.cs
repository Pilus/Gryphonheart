
namespace GH.Menu.Objects
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
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
                var obj = Global.GetGlobal(n);
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
                return MenuInitializationMapping[profile.type](profile, parent, layoutSettings);
            }
            //return GHMStub.NewObject(profile, parent.Frame.self, layoutSettings);
            throw new CsException("Unknown object profile: " + profile.type);
        }

        protected void SetUpTabbableObject(ITabableObject obj)
        {
            obj.Previous = this.settings.PreviousTabableBox;
            if (obj.Previous != null)
            {
                obj.Previous.Next = obj;
            }

            obj.SetScript(EditBoxHandler.OnTabPressed, () =>
            {
                if (Global.IsShiftKeyDown())
                {
                    if (obj.Previous != null)
                    {
                        obj.Previous.SetFocus();
                    }
                }
                else
                {
                    if (obj.Next != null)
                    {
                        obj.Next.SetFocus();
                    }
                }
            });
        }

        public virtual ObjectAlign GetAlignment()
        {
            return this.profile.align;
        }

        public virtual string GetLabel()
        {
            return this.profile.label;
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

        public abstract void Force(object value);


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
