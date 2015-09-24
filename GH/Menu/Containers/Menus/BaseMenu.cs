
namespace GH.Menu.Menus
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Objects;
    using Objects.Page;
    using Theme;
    using GH.Menu.Containers;

    public class BaseMenu : BaseContainer<IPage>, IMenu
    {

        public Inserts Inserts;

        private double? menuWidth;
        private double? menuHeight;

        public BaseMenu() : base("Menu")
        {
            this.Frame.SetParent(Global.Frames.UIParent);
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var menuProfile = (MenuProfile)profile;

            this.HandleOnShow(menuProfile);
            this.HandleOnHide(menuProfile);

            this.Inserts = new Inserts();
            this.menuWidth = menuProfile.width;
            this.menuHeight = menuProfile.height;
        }


        private void HandleOnShow(MenuProfile profile)
        {
            this.Frame.SetScript(FrameHandler.OnShow, (self) =>
                {
                    // TODO: Do Layer handling
                    if (profile.onShow != null)
                    {
                        profile.onShow();
                    }
                });
        }

        private void HandleOnHide(MenuProfile profile)
        {
            this.Frame.SetScript(FrameHandler.OnHide, (self) =>
            {
                // TODO: Do Layer handling
                if (profile.onHide != null)
                {
                    profile.onHide();
                }
            });
        }
        
        public void UpdatePosition()
        {
            var pageWidth = this.content.Max(page => page.GetPreferredWidth() ?? -1);
            var pageHeight = this.content.Max(page => page.GetPreferredHeight() ?? -1);

            var widthAvailableToPages = pageWidth;
            if (this.menuWidth != null)
            {
                widthAvailableToPages = (double)this.menuWidth - this.Inserts.Left - this.Inserts.Right;
                this.Frame.SetWidth((double)this.menuWidth);
            }
            else if (pageWidth >= 0)
            {
                this.Frame.SetWidth(pageWidth + this.Inserts.Left + this.Inserts.Right);
            }
            else
            {
                throw new MenuConfigurationException("The menu must either define a width or have a page with no objects with flexible width");
            }

            var heightAvailableToPages = pageHeight;
            if (this.menuHeight != null)
            {
                heightAvailableToPages = (double) this.menuHeight - this.Inserts.Top - this.Inserts.Bottom;
                this.Frame.SetHeight((double)this.menuHeight);
            }
            else if (pageHeight >= 0)
            {
                this.Frame.SetHeight(pageHeight + this.Inserts.Top + this.Inserts.Bottom);
            }
            else
            {
                throw new MenuConfigurationException("The menu must either define a height or have a page with no objects with flexible height");
            }

            this.content.Foreach(page => page.SetPosition(this.Frame, this.Inserts.Left, this.Inserts.Top, widthAvailableToPages, heightAvailableToPages));
        }

        public virtual void AnimatedShow()
        {
            this.Frame.Show();
        }

        public virtual void Show()
        {
            this.Frame.Show();
        }

        public virtual void Hide()
        {
            this.Frame.Hide();
        }
    }
}
