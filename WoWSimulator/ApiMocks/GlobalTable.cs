namespace WoWSimulator.ApiMocks
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.Global;
    using Moq;
    using UISimulation;

    public class GlobalTable : IApiMock
    {
        private UiInitUtil util;
        private readonly Dictionary<string, object> globalObjects;
 
        public GlobalTable(UiInitUtil util)
        {
            this.util = util;
            this.globalObjects = new Dictionary<string, object>();
        }

        public void Mock(Mock<IApi> apiMock)
        {
            apiMock.Setup(api => api.SetGlobal(It.IsAny<string>(), It.IsAny<object>()))
                .Callback((string key, object obj) => { this.globalObjects[key] = obj; });
            apiMock.Setup(api => api.GetGlobal(It.IsAny<string>()))
                .Returns((string key) => this.globalObjects.ContainsKey(key) ? this.globalObjects[key] : this.util.GetObjectByName(key));
        }
    }
}