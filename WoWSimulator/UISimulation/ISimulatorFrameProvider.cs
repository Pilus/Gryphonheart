namespace WoWSimulator.UISimulation
{
    using BlizzardApi.Global;

    public interface ISimulatorFrameProvider : IFrameProvider
    {
        void TriggerHandler(object handler, params object[] args);

        void LoadXmlFile(string path);
    }
}