namespace Tests
{
    using BlizzardApi.Global;
    using GH.Presenter;
    using System;
    using WoWSimulator;
    using System.Linq;
    using BlizzardApi.WidgetInterfaces;

    public class GHAddOnTestable
    {
        ISession session;
        IFrame mainButton;

        public GHAddOnTestable(ISession session)
        {
            this.session = session;
            this.mainButton = this.GetUIParentChildWithTexture(ButtonCluster.MainIconPath);
        }

        public void MouseOverMainButton()
        {
            this.session.Actor.MouseOver(this.mainButton);

            this.session.RunUpdateForDuration(TimeSpan.FromSeconds(1));
        }

        public void ClickSubButton(string texturePath)
        {
            var button = this.GetUIParentChildWithTexture(texturePath) as IButton;

            this.session.Actor.Click(button);
        }

        private IFrame GetUIParentChildWithTexture(string texturePath)
        {
            return Global.Frames.UIParent.GetChildren()
                .Single(f => f.GetRegions()
                    .Any(r => r is ITexture && (r as ITexture).GetTexture().Equals(texturePath)));
        }
    }
}