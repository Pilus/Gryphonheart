namespace WoWSimulator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.CompilerServices;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLuaAttributes;
    using Moq;
    using UISimulation;

    public class SessionBuilder
    {
        private readonly Mock<IApi> apiMock;
        private readonly List<AddOn> addOns;

        public SessionBuilder()
        {
            this.apiMock = new Mock<IApi>();
            this.addOns = new List<AddOn>();
        }

        public ISession Build()
        {
            var frameProvider = new SimulatorFrameProvider();

            var addOnLoadActions = new Dictionary<string, Action>();
            foreach (var addon in this.addOns)
            {
                addOnLoadActions[addon.Name] = addon.Execute;
            }

            return new Session(this.apiMock, null, frameProvider, addOnLoadActions);
        }

        public SessionBuilder WithAddOn(ICsLuaAddOn addOn)
        {
            this.addOns.Add(new AddOn(addOn));
            return this;
        }

        public SessionBuilder WithPlayerName(string name)
        {
            this.apiMock.Setup(api => api.UnitName(UnitId.player)).Returns(name);
            return this;
        }
    }
}