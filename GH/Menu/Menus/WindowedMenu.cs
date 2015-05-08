
namespace GH.Menu.Menus
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;

    public class WindowedMenu : BaseMenu
    {
        private readonly IGHM_Window window;

        public WindowedMenu(MenuProfile profile) : base(profile)
        {
            this.window = (IGHM_Window)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, null, Global.UIParent, "GHM_Window");
            
            this.window.settingUp = true;
            this.window.menu = this.Frame;


            this.window.SetWidth(this.Frame.GetWidth() + 4);
            
            this.window.SetHeight(this.Frame.GetHeight() + 25);

            this.window.SetDevMode(false);
            this.window.SetContent(this.Frame);
            this.window.SetTitle(profile.title);
            this.window.SetIcon(profile.icon);

            var texture = "Interface/DialogFrame/UI-DialogBox-Background";
            var getBackground = Global.GetGlobal("GHM_GetBackground") as Func<string>;
            if (!string.IsNullOrEmpty(profile.background))
            {
                texture = profile.background;
            }
            else if (getBackground() != null)
            {
                texture = getBackground();
            }

            SetBackdrop(this.window.BgFrame, texture, 4);
            SetBackdrop(this.window.BgFrame2, "Interface/AddOns/GHI/texture/white.tga", 4);
            SetBackdrop(this.window.TopBgFrame, "", 0);

            var getBackgroundColor = Global.GetGlobal("GHM_GetBackgroundColor") as Func<Tuple<double, double, double, double>>;
            var color = TypeConverter.EnsureTuple(getBackgroundColor()) as Tuple<double, double, double, double>;
            this.window.BgFrame2.SetBackdropColor(color.Item1, color.Item2, color.Item3, color.Item4);

            this.window.BgFrame.SetFrameLevel(this.window.BgFrame2.GetFrameLevel() + 1);
            this.window.TopBgFrame.SetFrameLevel(this.window.BgFrame.GetFrameLevel() + 1);
            this.window.TitleBar.SetFrameLevel(this.window.TopBgFrame.GetFrameLevel() + 1);

            var bg = this.window.TitleBar.CreateTexture();
            bg.SetAllPoints(this.window.TitleBar);
            var getTitleBarColor = Global.GetGlobal("GHM_GetTitleBarColor") as Func<string>;
            bg.SetTexture(getTitleBarColor());
            this.window.TopBgFrame.SetFrameLevel(this.window.BgFrame.GetFrameLevel()+1);
            this.window.SetFrameStrata(FrameStrata.MEDIUM);

            this.HookShowAndHide(profile);

            this.window.settingUp = false;
        }

        

        private void HookShowAndHide(MenuProfile profile)
        {
            var layerHandle = Global.GetGlobal("GHM_LayerHandle") as Action<IFrame>;
            var origShow = this.Frame.GetScript(FrameHandler.OnShow);
            this.Frame.SetScript(FrameHandler.OnShow, () =>
            {
                origShow();
                layerHandle(this.window.Frame.self);
                if (profile.onShow != null)
                {
                    profile.onShow();
                }
                else if (profile.OnShow != null)
                {
                    profile.OnShow();
                }
            });

            var origHide = this.Frame.GetScript(FrameHandler.OnHide);
            this.Frame.SetScript(FrameHandler.OnHide, () =>
                {
                    origHide();
                    layerHandle(this.window.Frame.self);
                    if (profile.onHide != null)
                    {
                        profile.onHide();
                    }
                });
        }

        public override void Show()
        {
            this.window.Show();
            this.window.ClearAllPoints();
            this.window.SetPoint(FramePoint.CENTER, 0, 0);
            base.Show();
        }

        public void SetTitle(object _, string title)
        {
            this.window.SetTitle(title);
        }

        public override void AnimatedShow()
        {
            this.Frame.Show();
            this.window.AnimatedShow();
        }

        private static void SetBackdrop(IFrame frame, string texture, double bottom)
        {
            var backdrop = new CsLuaDictionary<object, object>();
            backdrop["bgFile"] = texture;
            backdrop["edgeFile"] = "Interface/Tooltips/UI-Tooltip-Border";
            backdrop["tile"] = false;
            backdrop["tileSize"] = 16;
            backdrop["edgeSize"] = 16;
            var inserts = new CsLuaDictionary<object, object>();
            backdrop["left"] = 4;
            backdrop["right"] = 4;
            backdrop["top"] = 4;
            backdrop["bottom"] = bottom;
            backdrop["insets"] = inserts;
            frame.SetBackdrop(backdrop.ToNativeLuaTable());
        }
    }
}

