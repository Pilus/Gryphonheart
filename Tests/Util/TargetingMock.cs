namespace Tests.Util
{
    using System;
    using BlizzardApi.Global;
    using Moq;
    using WoWSimulator.ApiMocks;
    using BlizzardApi.MiscEnums;
    using WoWSimulator;
    using BlizzardApi.EventEnums;

    public class TargetingMock : IApiMock
    {
        private string targetName = null;

        public void TargetPlayer(string name, ISession session)
        {
            this.targetName = name;
            session.Util.TriggerEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED);
        }

        public void ClearTarget(ISession session)
        {
            this.targetName = null;
            session.Util.TriggerEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED);
        }

        public void Mock(Mock<IApi> apiMock)
        {
            apiMock.Setup(api => api.UnitName(UnitId.target)).Returns(() => targetName);
            apiMock.Setup(api => api.UnitIsPlayer(UnitId.target)).Returns(() => targetName != null);
            apiMock.Setup(api => api.UnitIsFriend(UnitId.target, UnitId.player)).Returns(() => targetName != null);
            apiMock.Setup(api => api.UnitIsFriend(UnitId.player, UnitId.target)).Returns(() => targetName != null);
            apiMock.Setup(api => api.UnitExists(UnitId.target)).Returns(() => targetName != null);
        }
    }
}
