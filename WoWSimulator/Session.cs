namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using Moq;
    using UISimulation;

    public class Session : ISession
    {
        private Dictionary<string, Action> addOns;
        private float fps;

        public Session(Mock<IApi> apiMock, IFrames globalFrames, ISimulatorFrameProvider frameProvider, Dictionary<string, Action> addOns, float fps)
        {
            this.ApiMock = apiMock;
            this.Frames = globalFrames;
            this.FrameProvider = frameProvider;
            this.addOns = addOns;
            this.fps = fps;
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
            this.FrameProvider.Util.UpdateTick(1/this.fps);
        }

        public void RunUpdateForDuration(TimeSpan time)
        {
            this.SetSessionToGlobal();
            var updates = time.TotalSeconds*this.fps;

            var c = 0;
            while (c < updates)
            {
                this.FrameProvider.Util.UpdateTick(1 / this.fps);
            }
        }

        public void RunUpdateForDuration(TimeSpan time, int fps)
        {
            this.SetSessionToGlobal();
            throw new NotImplementedException();
        }

        public Mock<IApi> ApiMock { get; private set; }

        public IFrames Frames { get; private set; }

        public ISimulatorFrameProvider FrameProvider { get; private set; }
    }
}