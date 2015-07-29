namespace Tests
{
    using BlizzardApi.Global;
    using GH.Presenter;
    using System;
    using WoWSimulator;
    using System.Linq;

    public class GHAddOnTestable
    {
        ISession session;

        public GHAddOnTestable(ISession session)
        {
            this.session = session;
        }

        public void MouseOver()
        {
            var mainButton = Global.Frames.UIParent.GetChildren()
                .Single(f => f.GetName() == "test");
            //var path = ButtonCluster.MainIconPath;
        }
    }
}