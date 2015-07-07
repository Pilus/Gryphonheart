namespace WoWSimulator
{
    using System;
    using Lua;

    public interface ISession
    {
        void RunStartup();
        void RunUpdate();
        void RunUpdateForDuration(TimeSpan time);
        void RunUpdateForDuration(TimeSpan time, int fps);
        void Click(string text);
        NativeLuaTable GetSavedVariables();
        void VerifyVisible(string text);
        void VerifyVisible(string text, bool exact);
        T GetGlobal<T>(string name);
    }
}