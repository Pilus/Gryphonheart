namespace WoWSimulator
{
    using System;
    using Lua;
    using UISimulation;

    public interface ISession
    {
        void RunStartup();
        void RunUpdate();
        void RunUpdateForDuration(TimeSpan time);
        void RunUpdateForDuration(TimeSpan time, int fps);
        NativeLuaTable GetSavedVariables();
        T GetGlobal<T>(string name);
        ISimulatorFrameProvider FrameProvider { get; }
        IFrameActor Actor { get; }
    }
}