namespace GHC.Modules.AbilityActionBar
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GH.Misc;
    using System;
    using CsLua;

    public class ActionButtonProxy : IActionButtonProxy
    {
        private ICheckButton button;
        private Action<string, IGameTooltip> updateFunc;
        private ITexture iconTexture;
        private IFrame cooldownFrame;
        private IFontString hotKeyFont;
        private Func<ICooldownInfo> getCooldown;

        private static IActionButtonProxyMethods actionButtonProxyMethods;

        public string Id { get; set; }

        public ActionButtonProxy(IFrame parent)
        {
            if (actionButtonProxyMethods == null)
            {
                actionButtonProxyMethods = CsLuaStatic.Wrapper.WrapGlobalObject<IActionButtonProxyMethods>("_G");
            }

            this.button = Global.FrameProvider.CreateFrame(FrameType.CheckButton, Misc.GetUniqueGlobalName(parent.GetName() + "ActionButton"), parent, "ActionButtonTemplate") as ICheckButton;
            this.button.RegisterForClicks(ClickType.LeftButtonUp, ClickType.RightButtonUp);
            this.SetupHandlersForTooltips();
            this.IdentifyFrameElements();
        }

        public void SetOnClick(Action<string> func)
        {
            this.button.SetScript(ButtonHandler.OnClick, (INativeUIObject b) =>
            {
                this.button.SetChecked(false);
                func(this.Id);
            });
        }

        public void SetTooltipFunc(Action<string, IGameTooltip> updateFunc)
        {
            this.updateFunc = updateFunc;
        }

        public void SetIcon(string iconPath)
        {
            this.iconTexture.SetTexture(iconPath);
        }

        public void SetCount(int count)
        {
            //actionButtonProxyMethods.setItemButtonCount(this.button, count);
        }

        public void SetHotKey(string hotKeyText)
        {
            this.hotKeyFont.SetText(hotKeyText);
        }

        public void SetDimensions(double width, double height)
        {
            this.button.SetWidth(width);
            this.button.SetHeight(height);
        }

        public void SetPoint(FramePoint point, double xOffs, double yOffs)
        {
            this.button.ClearAllPoints();
            this.button.SetPoint(point, xOffs, yOffs);
        }

        public void SetGetCooldown(Func<ICooldownInfo> func)
        {
            this.getCooldown = func;
        }

        public void Hide()
        {
            this.button.Hide();
        }

        public void Show()
        {
            this.button.Show();
        }

        public bool IsShown()
        {
            return this.button.IsShown();
        }

        private void IdentifyFrameElements()
        {
            var buttonName = this.button.GetName();
            this.iconTexture = Global.Api.GetGlobal(buttonName + "Icon", typeof(ITexture)) as ITexture;
            this.cooldownFrame = Global.Api.GetGlobal(buttonName + "Cooldown", typeof(IFrame)) as IFrame;
            this.hotKeyFont = Global.Api.GetGlobal(buttonName + "HotKey", typeof(IFontString)) as IFontString;
        }

        private void SetupHandlersForTooltips()
        {
            this.button.SetScript(FrameHandler.OnEnter, f =>
            {
                Global.Frames.GameTooltip.Show();
                if (this.button.GetCenter().Value1 > Global.Frames.UIParent.GetWidth()/2)
                {
                    Global.Frames.GameTooltip.SetOwner(this.button, TooltipAnchor.ANCHOR_TOPLEFT);
                }
                else
                {
                    Global.Frames.GameTooltip.SetOwner(this.button, TooltipAnchor.ANCHOR_TOPRIGHT);
                }
            });

            this.button.SetScript(FrameHandler.OnLeave, f =>
            {
                Global.Frames.GameTooltip.Hide();
            });

            this.button.SetScript(FrameHandler.OnUpdate, this.OnUpdate);
        }

        private void OnUpdate(INativeUIObject _, object elapsed)
        {
            var cooldown = this.getCooldown();
            actionButtonProxyMethods.CooldownFrame_SetTimer(this.cooldownFrame, cooldown.StartTime ?? 0, cooldown.Duration, cooldown.Active ? 1 : 0);

            if (this.button.Equals(Global.Frames.GameTooltip.GetOwner()) && this.updateFunc != null)
            {
                var tooltip = Global.Frames.GameTooltip;
                tooltip.ClearLines();
                this.updateFunc(this.Id, tooltip);
                tooltip.Show();
            }
        }
    }
}