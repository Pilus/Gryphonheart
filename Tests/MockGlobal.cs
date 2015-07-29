
namespace Tests
{
    using Moq;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using System.Collections.Generic;

    public class MockGlobal
    {
        public MockGlobal()
        {
            var globalRegister = new Dictionary<string, object>();

            var apiMock = new Mock<IApi>();
            apiMock.Setup(api => api.GetGlobal(It.IsAny<string>()))
                .Returns((string name) => globalRegister.ContainsKey(name) ? globalRegister[name] : null);
            apiMock.Setup(api => api.SetGlobal(It.IsAny<string>(), It.IsAny<object>()))
                .Callback((string name, object obj) => globalRegister[name] = obj);

            Global.Api = apiMock.Object;

            Global.FrameProvider = new MockFrameProvider();
            var framesMock = new Mock<IFrames>();

            var uiParent = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, "UIParent");

            framesMock.Setup(frames => frames.UIParent).Returns(uiParent);

            Global.Frames = framesMock.Object;

            
        }
    }
}
