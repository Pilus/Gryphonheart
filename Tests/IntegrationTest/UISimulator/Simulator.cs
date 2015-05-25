
namespace Tests.IntegrationTest.UISimulator
{
    using Moq;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class Simulator
    {
        public Simulator()
        {
            FrameUtil.FrameProvider = new SimulatorFrameProvider();
            var framesMock = new Mock<IFrames>();

            var uiParent = (IFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, "UIParent");

            framesMock.Setup(frames => frames.UIParent).Returns(uiParent);

            Global.Frames = framesMock.Object;
        }
    }
}
