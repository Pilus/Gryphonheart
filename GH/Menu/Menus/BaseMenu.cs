
namespace GH.Menu.Menus
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using Objects;
    using Objects.Page;

    public class BaseMenu :  CsLuaDictionary<object, object>, IMenu
    {

        public readonly CsLuaList<IPage> Pages;

        public readonly Inserts Inserts;

        private readonly double? menuWidth;
        private readonly double? menuHeight;

        public BaseMenu(MenuProfile profile)
        {
            this.Pages = new CsLuaList<IPage>();
            this.Frame = (IFrame) FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, profile.name, Global.Frames.UIParent);

            this.LoadPagesFromProfile(profile);
            this.HandleOnShow(profile);

            this.Inserts = new Inserts();
            this.menuWidth = profile.width;
            this.menuHeight = profile.height;

            this.UpdatePosition();
            var firstPage = this.Pages.FirstOrDefault();
            if (firstPage != null)
            {
                firstPage.Show();
                //UiDebugTools.FrameBg(firstPage.Frame);
            }
            
        }

        public static IMenu CreateMenu(MenuProfile profile)
        {
            switch (profile.theme)
            {
                case MenuTheme.StdTheme:
                    return new WindowedMenu(profile);
                case MenuTheme.BlankTheme:
                    if (profile.useWindow)
                    {
                        return new WindowedMenu(profile);
                    }
                    return new BaseMenu(profile);
                case MenuTheme.TabTheme:
                    return new TabMenu(profile);
                case MenuTheme.BlankWizardTheme:
                    throw new NotImplementedException();
                default:
                    throw new CsException("Unknown theme: " + profile.theme);
            }
        }

        private void HandleOnShow(MenuProfile profile)
        {
            var layerHandle = Global.Api.GetGlobal("GHM_LayerHandle") as Action<INativeUIObject>;
            this.Frame.SetScript(FrameHandler.OnShow, (self) =>
                {
                    layerHandle(this.Frame.self);
                    if (profile.onShow != null)
                    {
                        profile.onShow();
                    }
                });

            this.Frame.SetScript(FrameHandler.OnShow, (self) => layerHandle(this.Frame.self));
        }

        private void LoadPagesFromProfile(MenuProfile profile)
        {
            var layoutSettings = new LayoutSettings()
            {
                lineSpacing = profile.lineSpacing ?? 5,
                objectSpacing = 5,
            };

            profile.Foreach(pageProfile =>
                {
                    this.Pages.Add(new Page(pageProfile, this.Frame, layoutSettings, this.Pages.Count + 1));
                });
        }

        public virtual void AddElement(int pageIndex, int lineIndex, IObjectProfile profile)
        {
            throw new CsException("AddElement method is not supported by this menu type.");
        }

        public IMenuObject GetFrameById(string id)
        {
            foreach (var page in this.Pages)
            {
                var labelFrame = page.GetFrameById(id);
                if (labelFrame != null)
                {
                    return labelFrame;
                }
            }
            throw new CsException("Frame with id '" + id + "' not found.");
        }

        public void SetValue(string id, object value)
        {
            var frame = this.GetFrameById(id);
            frame.SetValue(value);
        }

        public object GetValue(string id)
        {
            var frame = this.GetFrameById(id);
            return frame.GetValue();
        }

        public void UpdatePosition()
        {
            var pageWidth = this.Pages.Max(page => page.GetPreferredWidth() ?? -1);
            var pageHeight = this.Pages.Max(page => page.GetPreferredHeight() ?? -1);

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

            this.Pages.Foreach(page => page.SetPosition(this.Inserts.Left, this.Inserts.Top, widthAvailableToPages, heightAvailableToPages));
        }

        public virtual void AnimatedShow()
        {
            this.Frame.Show();
        }

        public virtual void Show()
        {
            this.Frame.Show();
        }

        public void RemoveElement(string label)
        {
            throw new CsException("RemoveElement is not supported on a frame level");
        }

        public IFrame Frame { get; private set; }

        
    }
}
