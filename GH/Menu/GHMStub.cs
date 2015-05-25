
namespace GH.Menu
{
    using BlizzardApi.Global;
    using System;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using Lua;
    using Menus;
    using Objects;
    using Objects.Line;
    using Objects.Page;

    public static class GHMStub
    {
        public static IMenu NewFrame(object owner, MenuProfile profile)
        {
            var menuAction = Global.Api.GetGlobal("GHM_NewFrame") as Func<object, MenuProfile, IMenu>;
            if (menuAction != null)
            {
                return menuAction(owner, profile);
            }
            else
            {
                throw new CsException("GHM_NewFrame could not be called.");
            }
        }

        public static IMenuObject NewObject(IObjectProfile profile, object parent, object settings)
        {
            var menuObjectFunc = Global.Api.GetGlobal("GHM_BaseObject") as Func<IObjectProfile, object, object, IMenuObject>;
            if (menuObjectFunc != null)
            {
                return menuObjectFunc(profile, parent, settings);
            }
            else
            {
                throw new CsException("GHM_BaseObject could not be called.");
            }
        }

        public static ILine NewLine(LineProfile profile, object parent, object settings)
        {
            var func = Global.Api.GetGlobal("GHM_Line") as Func<LineProfile, object, object, ILine>;
            if (func != null)
            {
                return func(profile, parent, settings);
            }
            else
            {
                throw new CsException("GHM_Line could not be called.");
            }
        }

        public static IPage NewPage(PageProfile profile, object parent, object settings)
        {
            var func = Global.Api.GetGlobal("GHM_Page") as Func<PageProfile, object, object, IPage>;
            if (func != null)
            {
                return func(profile, parent, settings);
            }
            else
            {
                throw new CsException("GHM_Page could not be called.");
            }
        }
    }
}
