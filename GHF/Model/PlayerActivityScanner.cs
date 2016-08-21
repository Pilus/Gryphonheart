

namespace GHF.Model
{
    using System;
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;

    using GH.Utils;

    public class PlayerActivityScanner
    {
        private Action<string, PlayerActivity> onActivity;

        public PlayerActivityScanner(Action<string, PlayerActivity> onActivity, GameEventListener eventListener)
        {
            this.onActivity = onActivity;

            this.SetupTargetChangedScan(eventListener);
        }

        private void SetupTargetChangedScan(GameEventListener eventListener)
        {
            eventListener.RegisterEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED, (e,o) =>
            {
                if (Global.Api.UnitIsPlayer(UnitId.target) && Global.Api.UnitIsFriend(UnitId.player, UnitId.target))
                {
                    this.onActivity(Global.Api.UnitName(UnitId.target), PlayerActivity.PlayerTargeted);
                }
            });
        }
    }
}
