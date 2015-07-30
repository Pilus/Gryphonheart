
namespace Tests
{
    using Moq;
    using BlizzardApi.Global;
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
        }
    }
}
