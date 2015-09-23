

namespace GHF.Model
{
    using System;
    using BlizzardApi.EventEnums;
    using GH.Misc;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;

    public class PlayerActivityScanner
    {
        private Action<string, PlayerActivity> onActivity;

        public PlayerActivityScanner(Action<string, PlayerActivity> onActivity)
        {
            this.onActivity = onActivity;

            this.SetupTargetChangedScan();
        }

        private void SetupTargetChangedScan()
        {
            Misc.RegisterEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED, (e,o) =>
            {
                if (Global.Api.UnitIsPlayer(UnitId.target) && Global.Api.UnitIsFriend(UnitId.player, UnitId.target))
                {
                    this.onActivity(Global.Api.UnitName(UnitId.target), PlayerActivity.PlayerTargeted);
                }
            });
        }
    }
}
