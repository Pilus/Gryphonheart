namespace WoWSimulator
{
    using System;
    using BlizzardApi.Global;
    using Moq;
    using UISimulation;

    public interface ISession
    {
        void RunStartup();
        void RunUpdate();
        void RunUpdateForDuration(TimeSpan time);
        void RunUpdateForDuration(TimeSpan time, int fps);
        Mock<IApi> ApiMock { get; }
        IFrames Frames { get; }
        ISimulatorFrameProvider FrameProvider { get; }
    }
}