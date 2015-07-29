namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using Lua;
    using Moq;
    using SavedData;
    using UISimulation;

    public class Session : ISession
    {
        private UiInitUtil util;
        private FrameActor actor;
        private Dictionary<string, Action> addOns;
        private float fps;
        private SavedDataHandler savedDataHandler;

        public Session(Mock<IApi> apiMock, IFrames globalFrames, UiInitUtil util, FrameActor actor, ISimulatorFrameProvider frameProvider, Dictionary<string, Action> addOns, float fps, SavedDataHandler savedDataHandler)
        {
            this.ApiMock = apiMock;
            this.Frames = globalFrames;
            this.FrameProvider = frameProvider;
            this.addOns = addOns;
            this.fps = fps;
            this.savedDataHandler = savedDataHandler;
            this.util = util;
            this.actor = actor;
        }

        private void SetSessionToGlobal()
        {
            Global.Api = this.ApiMock.Object;
            Global.FrameProvider = this.FrameProvider;
            Global.Frames = this.Frames;
        }

        public void RunStartup()
        {
            this.SetSessionToGlobal();
            foreach (var addon in this.addOns)
            {
                addon.Value();
                this.FrameProvider.TriggerEvent(SystemEvent.ADDON_LOADED, addon.Key);
            }
        }

        public void RunUpdate()
        {
            this.SetSessionToGlobal();

            this.util.UpdateTick(1/this.fps);
            Core.mockTime = Core.time() + 1 / this.fps;
        }

        public void RunUpdateForDuration(TimeSpan time)
        {
            this.SetSessionToGlobal();
            var updates = time.TotalSeconds*this.fps;

            var c = 0;
            while (c < updates)
            {
                this.util.UpdateTick(1 / this.fps);
                Core.mockTime = Core.time() + 1/this.fps;
                c++;
            }
        }

        public void RunUpdateForDuration(TimeSpan time, int fps)
        {
            this.SetSessionToGlobal();
            throw new NotImplementedException();
        }

        private Mock<IApi> ApiMock { get; set; }

        private IFrames Frames { get; set; }

        public ISimulatorFrameProvider FrameProvider { get; private set; }


        public NativeLuaTable GetSavedVariables()
        {
            return this.savedDataHandler.GetSavedVariables();
        }

        public void Click(string text)
        {
            this.actor.Click(text);
        }

        public void VerifyVisible(string text)
        {
            this.actor.VerifyVisible(text, false);
        }

        public void VerifyVisible(string text, bool exact)
        {
            this.actor.VerifyVisible(text, exact);
        }

        public T GetGlobal<T>(string name)
        {
            return (T) this.ApiMock.Object.GetGlobal(name);
        }
    }
}