
namespace Tests.IntegrationTest.UISimulator
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class Simulator
    {
        public Simulator()
        {
            FrameUtil.FrameProvider = new SimulatorFrameProvider();
            Global.UIParent = (IFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, "UIParent");
        }
    }
}
