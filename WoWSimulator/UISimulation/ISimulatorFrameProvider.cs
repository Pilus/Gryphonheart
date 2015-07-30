namespace WoWSimulator.UISimulation
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;

    public interface ISimulatorFrameProvider : IFrameProvider
    {
        void TriggerEvent(object eventName, params object[] eventArgs);

        void TriggerHandler(object handler, params object[] args);

        void LoadXmlFile(string path);
    }
}