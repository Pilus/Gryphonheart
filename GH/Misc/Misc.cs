
namespace GH.Misc
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;
    using BlizzardApi.Global;

    public static class Misc
    {
        private static double lastVersion;

        public static double GetTimeBasedVersion()
        {
            var ver = Core.time() - 1370000000;
            if (ver <= lastVersion)
            {
                ver = lastVersion + 1;
            }
            lastVersion = ver;
            return ver;
        }

        public static void RegisterEvent<T>(T eventName, Action<T, object> func)
        {
            var frame = Global.FrameProvider.CreateFrame(FrameType.Frame) as IFrame;
            frame.RegisterEvent(eventName.ToString());

            var wrapperFunc = new Action<IUIObject, object, object>((self, o, arg1) =>
            {
                func((T)Enum.Parse(typeof(T), (string)o), arg1);
            });

            frame.SetScript(FrameHandler.OnEvent, wrapperFunc);
        }


        public static string GetUniqueGlobalName(string prefix)
        {
            var i = 1;
            while (Global.Api.GetGlobal(prefix + i) != null)
            {
                i++;
            }

            return prefix + i;
        }
    }
}