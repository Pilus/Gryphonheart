
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

        public static void RegisterEvent(SystemEvent eventName, Action<SystemEvent> func)
        {
            var frame = FrameUtil.FrameProvider.CreateFrame(FrameType.Frame) as IFrame;
            frame.RegisterEvent(eventName);

            var wrapperFunc = new Action<IFrame, object>((callingFrame, o) =>
            {
                func((SystemEvent)Enum.Parse(typeof(SystemEvent), (string)o));
            });

            frame.SetScript(FrameHandler.OnEvent, wrapperFunc);
        }
    }
}