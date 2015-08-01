namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using ApiMocks;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaAttributes;
    using Lua;
    using Moq;
    using SavedData;
    using UISimulation;

    public class SessionBuilder
    {
        private readonly Mock<IApi> apiMock;
        private readonly List<AddOn> addOns;
        private readonly List<Func<UiInitUtil, IFrame>> frameCreationMethod = new List<Func<UiInitUtil, IFrame>>();
        private readonly SimulatorFrameProvider frameProvider;
        private readonly UiInitUtil util;
        private readonly FrameActor actor;
        private float fps = 30;
        private NativeLuaTable savedVariables;

        public SessionBuilder()
        {
            this.apiMock = new Mock<IApi>();
            this.addOns = new List<AddOn>();
            this.util = new UiInitUtil();
            this.actor = new FrameActor(this.util);
            this.frameProvider = new SimulatorFrameProvider(this.util, this.actor);
            this.WithApiMock(new GlobalTable(this.util));
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
            globalFrames.UIParent = (IFrame)this.frameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.Frame, "UIParent");

            globalFrames.GameTooltip = (IGameTooltip)this.frameProvider.CreateFrame(BlizzardApi.WidgetEnums.FrameType.GameTooltip, "UIParent");

            var savedVariables = new List<string>();
            this.addOns.ForEach(a =>
            {
                if (a.SavedVariables.Length > 0) savedVariables.AddRange(a.SavedVariables);
                if (a.SavedVariablesPerCharacter.Length > 0) savedVariables.AddRange(a.SavedVariablesPerCharacter);
            });

            var savedDataHandler = new SavedDataHandler(this.apiMock, savedVariables);
            if (this.savedVariables != null) savedDataHandler.Load(this.savedVariables);

            var wrapper = new MockObjectWrapper(this.apiMock.Object);

            return new Session(this.apiMock, globalFrames, this.util, this.actor, this.frameProvider, addOnLoadActions, this.fps, savedDataHandler, wrapper);
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
            this.util.AddWrapper(frameOrTemplateName, wrapperInit);
            return this;
        }

        public SessionBuilder WithIgnoredXmlTemplate(string templateName)
        {
            this.util.AddIgnoredTemplate(templateName);
            return this;
        }

        public SessionBuilder WithFps(float fps)
        {
            this.fps = fps;
            return this;
        }

        public SessionBuilder WithSavedVariables(NativeLuaTable savedVariables)
        {
            this.savedVariables = savedVariables;
            return this;
        }

        public SessionBuilder WithPlayerName(string name)
        {
            this.apiMock.Setup(api => api.UnitName(UnitId.player)).Returns(name);
            return this;
        }
    }
}