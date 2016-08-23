namespace Tests
{
    using BlizzardApi.Global;
    using System;
    using WoWSimulator;
    using System.Linq;
    using BlizzardApi.WidgetInterfaces;

    using GH.CommonModules.QuickButtonCluster;

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

        public void StartDragMainButton()
        {
            this.session.Actor.StartDrag((IButton)this.mainButton);
        }

        public void StopDragMainButton()
        {
            this.session.Actor.StopDrag((IButton)this.mainButton);
        }

        public Tuple<double, double> GetMainButtonLocation()
        {
            var point = this.mainButton.GetPoint(1);
            return new Tuple<double, double>(point.Value4 ?? 0, point.Value5 ?? 0);
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