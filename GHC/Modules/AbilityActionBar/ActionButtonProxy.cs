namespace GHC.Modules.AbilityActionBar
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GH.Misc;
    using System;

    public class ActionButtonProxy : IActionButtonProxy
    {
        private ICheckButton button;
        private Action<string, IGameTooltip> updateFunc;
        private ITexture iconTexture;
        private IFrame cooldownFrame;

        private static Action<ICheckButton, int> setItemButtonCount;
        private static Action<IFrame, double, int, int> cooldownFrameSetTimer;

        public string Id { get; set; }

        public ActionButtonProxy(IFrame parent)
        {
            this.button = Global.FrameProvider.CreateFrame(FrameType.CheckButton, Misc.GetUniqueGlobalName(parent.GetName() + "ActionButton"), parent, "ActionButtonTemplate") as ICheckButton;
            this.button.RegisterForClicks(ClickType.LeftButtonUp, ClickType.RightButtonUp);
            this.SetupHandlersForTooltips();
            this.IdentifyIconAndCooldownElements();
        }

        public void SetOnClick(Action<string> func)
        {
            this.button.SetScript(ButtonHandler.OnClick, (INativeUIObject b) => { func(this.Id); });
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
            if (setItemButtonCount == null)
            {
                setItemButtonCount = Global.Api.GetGlobal("SetItemButtonCount") as Action<ICheckButton, int>;
            }

            setItemButtonCount(this.button, count);
        }

        public void SetCooldown(double startTime, int duration)
        {
            if (cooldownFrameSetTimer == null)
            {
                cooldownFrameSetTimer = Global.Api.GetGlobal("CooldownFrame_SetTimer") as Action<IFrame, double, int, int>;
            }

            cooldownFrameSetTimer(this.cooldownFrame, startTime, duration, 1);
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

        private void IdentifyIconAndCooldownElements()
        {
            var buttonName = this.button.GetName();
            this.iconTexture = Global.Api.GetGlobal(buttonName + "Icon", typeof(ITexture)) as ITexture;
            this.cooldownFrame = Global.Api.GetGlobal(buttonName + "Cooldown", typeof(IFrame)) as IFrame;
        }

        private void SetupHandlersForTooltips()
        {
            this.button.SetScript(FrameHandler.OnEnter, f =>
            {
                if (this.button.GetCenter() > Global.Frames.UIParent.GetWidth()/2)
                {
                    Global.Frames.GameTooltip.SetOwner(this.button, TooltipAnchor.ANCHOR_BOTTOMLEFT);
                }
                else
                {
                    Global.Frames.GameTooltip.SetOwner(this.button, TooltipAnchor.ANCHOR_BOTTOMRIGHT);
                }                
            });

            this.button.SetScript(FrameHandler.OnLeave, f =>
            {
                Global.Frames.GameTooltip.Hide();
            });

            this.button.SetScript(FrameHandler.OnUpdate, f => {
                if (Global.Frames.GameTooltip.GetOwner() == this.button && this.updateFunc != null)
                {
                    this.updateFunc(this.Id, Global.Frames.GameTooltip);
                }
            });
        }
    }
}