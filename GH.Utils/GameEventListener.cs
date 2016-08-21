
namespace GH.Utils
{
    using System;
    using System.Collections.Generic;

    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using GH.Utils.Modules;

    public class GameEventListener : SingletonModule
    {
        private readonly IFrame eventFrame;
        private readonly Dictionary<string, List<Action<object>>> listeners;

        public GameEventListener()
        {
            this.eventFrame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame);
            this.listeners = new Dictionary<string, List<Action<object>>>();
            this.eventFrame.SetScript(FrameHandler.OnEvent, (self, eventName, arg1) =>
            {
                this.TriggerEvent((string)eventName, arg1);
            });
        }

        public void RegisterEvent<T>(T eventName, Action<T, object> func)
        {
            var eventNameStr = eventName.ToString();
            if (!this.listeners.ContainsKey(eventNameStr))
            {
                this.eventFrame.RegisterEvent(eventNameStr);
                this.listeners[eventNameStr] = new List<Action<object>>();
            }

            this.listeners[eventNameStr].Add((arg1) =>
            {
                func((T)Enum.Parse(typeof(T), eventNameStr), arg1);
            });
        }

        private void TriggerEvent(string eventName, object arg1)
        {
            if (!this.listeners.ContainsKey(eventName)) return;

            foreach (var listener in this.listeners[eventName])
            {
                // TODO: Use execution strategy and error handling.
                listener(arg1);
            }
        }
    }
}