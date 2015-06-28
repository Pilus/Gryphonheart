namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.CompilerServices;
    using ApiMocks;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaAttributes;
    using Moq;
    using UISimulation;

    public class SessionBuilder
    {
        private readonly Mock<IApi> apiMock;
        private readonly List<AddOn> addOns;
        private readonly SimulatorFrameProvider frameProvider;
        private float fps = 30;

        public SessionBuilder()
        {
            this.apiMock = new Mock<IApi>();
            this.addOns = new List<AddOn>();
            this.frameProvider = new SimulatorFrameProvider();
            this.WithApiMock(new GlobalTable(this.frameProvider.Util));
        }

        public ISession Build()
        {
            this.frameProvider.LoadXmlFiles();

            var addOnLoadActions = new Dictionary<string, Action>();
            foreach (var addon in this.addOns)
            {
                addOnLoadActions[addon.Name] = addon.Execute;
            }

            var globalFrames = new GlobalFrames();
            globalFrames.UIParent = (IFrame)this.frameProvider.CreateFrame(FrameType.Frame, "UIParent");

            return new Session(this.apiMock, globalFrames, this.frameProvider, addOnLoadActions, this.fps);
        }

        public SessionBuilder WithApiMock(IApiMock mock)
        {
            mock.Mock(this.apiMock);
            return this;
        }

        public SessionBuilder WithAddOn(ICsLuaAddOn addOn)
        {
            this.addOns.Add(new AddOn(addOn));
            return this;
        }

        public SessionBuilder WithXmlFile(string path)
        {
            this.frameProvider.LoadXmlFile(path);
            return this;
        }

        public SessionBuilder WithFrameWrapper(string frameOrTemplateName, Func<UiInitUtil, LayoutFrameType, IRegion, IUIObject> wrapperInit)
        {
            this.frameProvider.Util.AddWrapper(frameOrTemplateName, wrapperInit);
            return this;
        }

        public SessionBuilder WithFps(float fps)
        {
            this.fps = fps;
            return this;
        }

        public SessionBuilder WithPlayerName(string name)
        {
            this.apiMock.Setup(api => api.UnitName(UnitId.player)).Returns(name);
            return this;
        }
    }
}