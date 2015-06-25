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

        public Session(Mock<IApi> apiMock, IFrames globalFrames, ISimulatorFrameProvider frameProvider, Dictionary<string, Action> addOns)
        {
            this.ApiMock = apiMock;
            this.Frames = globalFrames;
            this.FrameProvider = frameProvider;
            this.addOns = addOns;
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
            throw new NotImplementedException();
        }

        public void RunUpdateForDuration(TimeSpan time)
        {
            this.SetSessionToGlobal();
            throw new NotImplementedException();
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