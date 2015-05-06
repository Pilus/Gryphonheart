namespace GH.Presenter
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Integration;
    using Lua;
    using Model;

    public class ButtonCluster
    {
        private const double HideTimeSec = 1.0;

        private readonly IModelProvider model;
        private RoundButton mainButton;
        private readonly CsLuaList<RoundButton> buttons;
        private double lastActive;

        private IClusterButtonAnimationFactory animationFactory;
        private IClusterButtonAnimation showAnimation;
        private IClusterButtonAnimation hideAnimation;

        public ButtonCluster(IModelProvider model, IClusterButtonAnimationFactory animationFactory)
        {
            this.model = model;
            this.animationFactory = animationFactory;
            this.lastActive = 0;
            this.buttons = new CsLuaList<RoundButton>();
            this.UpdateClusterButtonAnimations();
            this.SetUpMainButton();
        }

        private void UpdateClusterButtonAnimations()
        {
            this.showAnimation = this.GetClusterButtonAnimationFromSetting(SettingIds.QuickButtonShowAnimation);
            this.hideAnimation = this.GetClusterButtonAnimationFromSetting(SettingIds.QuickButtonHideAnimation);
        }

        private IClusterButtonAnimation GetClusterButtonAnimationFromSetting(SettingIds settingId)
        {
            var animationSetting = this.model.Settings.Get(settingId);
            var animationType = (ClusterButtonAnimationType) animationSetting.Value;
            return this.animationFactory.Create(animationType, 40);
        }

        private void SetUpMainButton()
        {
            this.mainButton = new RoundButton(52);
            this.mainButton.SetIcon("Interface/ICONS/ABILITY_MOUNT_GOLDENGRYPHON");

            var buttonPosition = this.model.Settings.Get(SettingIds.ButtonPosition).Value as double [];
            this.mainButton.SetPosition(buttonPosition[0], buttonPosition[1]);
            this.mainButton.EnterCallback = this.ShowQuickButtons;
            this.mainButton.PositionChangeCallback = this.MoveButtonCluster;
            this.mainButton.UpdateCallback = this.ButtonUpdate;
        }

        private void MoveButtonCluster(double x, double y)
        {
            var positionSetting = new Setting(SettingIds.ButtonPosition, new[] { x, y });
            this.model.Settings.Set(SettingIds.ButtonPosition, positionSetting);
        }

        private void ButtonUpdate()
        {
            var currentMouseFocus = FrameUtil.FrameProvider.GetMouseFocus();
            if (currentMouseFocus != null && (currentMouseFocus.self == this.mainButton.Button.self || this.buttons.Any(b => b.Button.self == currentMouseFocus.self)))
            {
                this.lastActive = Core.time();
            }
            else if (Core.time() - HideTimeSec > this.lastActive)
            {
                this.HideQuickButtons();
            }
        }        

        private void HideQuickButtons()
        {
            var activeButtons = this.buttons.Where(b => b.Button.IsShown()).Select(b => b.Button).ToList();
            this.hideAnimation.AnimateButtons(this.mainButton.Button, activeButtons, false);
        }

        /// <summary>
        /// Initialize and display the quick buttons around the main button.
        /// </summary>
        private void ShowQuickButtons()
        {
            var quickButtons = this.model.ButtonList.GetAll()
                .Where(qb => AddOnRegister.AddOnLoaded(qb.RequiredAddOn))
                .OrderBy(qb => qb.Order).ToList();

            var activeButtons = new CsLuaList<IButton>();
            for (var i = 0; i < quickButtons.Count; i++)
            {
                var quickButton = quickButtons[i];
                if (this.buttons[i] == null)
                {
                    this.buttons[i] = new RoundButton(32);
                }
                var button = this.buttons[i];
                button.SetIcon(quickButton.Icon);
                button.EnterCallback = () =>
                {
                    Global.GameTooltip.SetOwner(button.Button, BlizzardApi.WidgetEnums.TooltipAnchor.ANCHOR_TOPLEFT);
                    Global.GameTooltip.AddLine(quickButton.Tooltip);
                    Global.GameTooltip.Show();
                };

                button.LeaveCallback = () =>
                {
                    var tooltipOwner = Global.GameTooltip.GetOwner();
                    if (tooltipOwner != null && tooltipOwner.self == button.Button.self)
                    {
                        Global.GameTooltip.Hide();
                    }
                };

                button.HideCallback = () =>
                {
                    var tooltipOwner = Global.GameTooltip.GetOwner();
                    if (tooltipOwner != null && tooltipOwner.self == button.Button.self)
                    {
                        Global.GameTooltip.Hide();
                    }
                };
                button.ClickCallback = quickButton.Action;


                activeButtons.Add(button.Button);
            }

            this.showAnimation.AnimateButtons(this.mainButton.Button, activeButtons, true);
            
        }
    }
}