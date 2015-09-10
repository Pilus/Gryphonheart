namespace Tests
{
    using BlizzardApi.WidgetInterfaces;
    using System;
    using System.Linq;
    using WoWSimulator;
    using WoWSimulator.UISimulation;

    public class GHMenuTestable
    {
        ISession session;
        IFrame currentMenu;

        public GHMenuTestable(ISession session)
        {
            this.session = session;
        }

        public void SelectMenu(string name)
        {
            this.currentMenu = this.session.GetGlobal<IFrame>(name);
            if (this.currentMenu == null)
                throw new UiSimuationException(string.Format("No menu found with name {0}.", name));
        }

        private void VerifyCurrentMenu()
        {
            if (this.currentMenu == null)
                throw new UiSimuationException("Current menu not set.");
        }

        private bool IsRegionInMenu(IRegion region)
        {
            return region != null && (region == this.currentMenu || this.IsRegionInMenu(region.GetParent()));
        }

        public void VerifyLabelVisible(string labelText)
        {
            this.VerifyCurrentMenu();

            var visibleFrames = this.session.Util.GetVisibleFrames().ToList();

            var framesInMenu = visibleFrames.Where(this.IsRegionInMenu);

            if (framesInMenu.Count() == 0)
            {
                throw new UiSimuationException("No visible frames in menu.");
            }

            var label = framesInMenu.SelectMany(f => f.GetRegions()).FirstOrDefault(r =>
                (r is IFontString && (r as IFontString).GetText().Contains(labelText)));
            if (label == null)
            {
                throw new UiSimuationException(string.Format("No label found displaying the text '{0}' in the menu.", labelText));
            }


        }
    }
}
