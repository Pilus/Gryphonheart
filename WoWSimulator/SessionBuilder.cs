namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ApiMocks;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework;
    using Lua;
    using Moq;
    using SavedData;
    using TestUtils;
    using UISimulation;
    using UISimulation.XMLHandler;
    using FrameType = BlizzardApi.WidgetEnums.FrameType;

    public class SessionBuilder
    {
        private readonly Mock<IApi> apiMock;
        private readonly List<AddOn> addOns;
        private readonly SimulatorFrameProvider frameProvider;
        private readonly UiInitUtil util;
        private readonly FrameActor actor;
        private readonly List<Action<ISession>> postBuildActions = new List<Action<ISession>>();
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
            globalFrames.UIParent = (IFrame)this.frameProvider.CreateFrame(FrameType.Frame, "UIParent");

            globalFrames.GameTooltip = (IGameTooltip)this.frameProvider.CreateFrame(FrameType.GameTooltip, "UIParent");

            var savedVariables = new List<string>();
            this.addOns.ForEach(a =>
            {
                if (a.SavedVariables.Length > 0) savedVariables.AddRange(a.SavedVariables);
                if (a.SavedVariablesPerCharacter.Length > 0) savedVariables.AddRange(a.SavedVariablesPerCharacter);
            });

            var savedDataHandler = new SavedDataHandler(this.apiMock, savedVariables);
            if (this.savedVariables != null) savedDataHandler.Load(this.savedVariables);

            var wrapper = new MockObjectWrapper(this.apiMock.Object);
            this.MockAddOnApi(this.apiMock);
            var session = new Session(this.apiMock, globalFrames, this.util, this.actor, this.frameProvider, addOnLoadActions, this.fps, savedDataHandler, wrapper);

            this.postBuildActions.ForEach(action => action(session));

            return session;
        }

        private void MockAddOnApi(Mock<IApi> mock)
        {
            mock.Setup(api => api.GetAddOnMetadata(It.IsAny<string>(), It.IsAny<string>())).Returns(
            (string addOnName, string variableName) =>
            {
                var addOn = this.addOns.FirstOrDefault(a => a.Name.Equals(addOnName));
                if (addOn != null && addOn.TocValues.ContainsKey(variableName))
                {
                    return addOn.TocValues[variableName];
                }
                return null;
            });
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

        public SessionBuilder WithPostBuildAction(Action<ISession> action)
        {
            this.postBuildActions.Add(action);
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

        public SessionBuilder WithPlayerClass(string className)
        {
            var classNumber = new List<string>() {"None", "Warrior", "Paladin", "Hunter", "Rogue", "Priest", "DeathKnight", "Shaman", "Mage", "Warlock", "Monk", "Druid" };
            var returnValue = TestUtil.StructureMultipleValues(className, className.ToUpper(), classNumber.IndexOf(className));
            this.apiMock.Setup(api => api.UnitClass(UnitId.player)).Returns(returnValue);
            return this;
        }

        public SessionBuilder WithPlayerRace(string race)
        {
            var returnValue = TestUtil.StructureMultipleValues(race+"Loc", race);
            this.apiMock.Setup(api => api.UnitRace(UnitId.player)).Returns(returnValue);
            return this;
        }

        public SessionBuilder WithPlayerGuid(string guid)
        {
            this.apiMock.Setup(api => api.UnitGUID(UnitId.player)).Returns(guid);
            return this;
        }

        public SessionBuilder WithPlayerSex(int sex)
        {
            this.apiMock.Setup(api => api.UnitSex(UnitId.player)).Returns(sex);
            return this;
        }
    }
}