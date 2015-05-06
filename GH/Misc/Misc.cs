
namespace GH.Misc
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Events;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public static class Misc
    {
        private static long lastVersion;

        public static long GetTimeBasedVersion()
        {
            var ver = Core.time() - 1370000000;
            if (ver <= lastVersion)
            {
                ver = lastVersion + 1;
            }
            lastVersion = ver;
            return ver;
        }

        public static void RegisterEvent(SystemEvent eventName, Action func)
        {
            var frame = FrameUtil.FrameProvider.CreateFrame(FrameType.Frame) as IFrame;
            frame.RegisterEvent(eventName);
            frame.SetScript(FrameHandler.OnEvent, func);
        }
    }
}