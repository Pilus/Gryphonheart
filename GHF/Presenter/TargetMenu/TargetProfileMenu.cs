namespace GHF.Presenter.TargetMenu
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Menu.Objects.Page;
    using GH.UIModules.TargetDetails;
    using GHF.View.TargetMenuProfile;
    using Model;

    public class TargetProfileMenu
    {
        private IModelProvider model;
        private TargetDetails targetDetails;
        public TargetProfileMenu(IModelProvider model, TargetDetails targetDetails)
        {
            this.model = model;
            this.targetDetails = targetDetails;
            this.targetDetails.AddPages(GenerateProfile(), this.ProfileEnabled);
            this.model.Msp.SubscribeForChanges(this.OnProfileChanged);
        }

        private static CsLuaList<PageProfile> GenerateProfile()
        {
            return new CsLuaList<PageProfile>() { TargetMenuProfileGenerator.GenerateProfile() };
        }

        private bool ProfileEnabled()
        {
            if (Global.Api.UnitIsFriend(UnitId.player, UnitId.target) && Global.Api.UnitIsPlayer(UnitId.target))
            {
                return this.model.Msp.HasOther(Global.Api.UnitName(UnitId.target));
            }
            return false;
        }

        private void OnProfileChanged(string name)
        {
            if (name.Equals(Global.Api.UnitName(UnitId.target)))
            {
                this.targetDetails.EvaluateVisibility();
            }
        }
    }
}