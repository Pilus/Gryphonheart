namespace GH.CommonModules.QuickButtonCluster
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation;
    using GH.Utils.AddOnIntegration;
    using Lua;

    public class ButtonCluster
    {
        public const string MainIconPath = "Interface/ICONS/ABILITY_MOUNT_GOLDENGRYPHON";
        private const double HideTimeSec = 1.0;

        private readonly IWrapper wrapper;
        private readonly IAddOnRegistry addOnRegistry;

        private RoundButton mainButton;
        private readonly List<RoundButton> buttons;
        private double lastActive;
        private bool buttonsShown;

        private IClusterButtonAnimationFactory animationFactory;
        private IClusterButtonAnimation showAnimation;
        private IClusterButtonAnimation hideAnimation;

        private QuickButtonSettings settings;
        private Action<QuickButtonSettings> saveSettings;

        public ButtonCluster(IClusterButtonAnimationFactory animationFactory, IWrapper wrapper, IAddOnRegistry addOnRegistry)
        {
            this.animationFactory = animationFactory;
            this.wrapper = wrapper;
            this.addOnRegistry = addOnRegistry;
            this.lastActive = 0;
            this.buttons = new List<RoundButton>();
            this.SetUpMainButton();
        }

        public void ApplySettings(QuickButtonSettings settings, Action<QuickButtonSettings> saveSettings)
        {
            this.settings = settings;
            this.saveSettings = saveSettings;
            this.mainButton.SetPosition(settings.XLocation, settings.YLocation);
            this.showAnimation = this.animationFactory.Create(settings.ShowAnimationType, 40);
            this.hideAnimation = this.animationFactory.Create(settings.HideAnimationType, 40);
            this.lastActive = 0;
            this.mainButton.Button.Show();
        }
        
        private void SetUpMainButton()
        {
            this.mainButton = new RoundButton(52);
            this.mainButton.SetIcon(MainIconPath);

            this.mainButton.EnterCallback = this.ShowQuickButtons;
            this.mainButton.PositionChangeCallback = this.MoveButtonCluster;
            this.mainButton.UpdateCallback = this.ButtonUpdate;
        }

        private void MoveButtonCluster(double x, double y)
        {
            this.settings.XLocation = x;
            this.settings.YLocation = y;
            this.saveSettings(this.settings);
        }

        private void ButtonUpdate()
        {
            if (!this.buttonsShown) return;

            var currentMouseFocus = Global.FrameProvider.GetMouseFocus();
            if (currentMouseFocus != null && (currentMouseFocus == this.mainButton.Button || this.buttons.Any(b => b.Button == currentMouseFocus)))
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
            this.buttonsShown = false;
            var activeButtons = this.buttons.Where(b => b.Button.IsShown()).Select(b => b.Button).ToList();
            this.hideAnimation.AnimateButtons(this.mainButton.Button, activeButtons, false);
        }

        /// <summary>
        /// Initialize and display the quick buttons around the main button.
        /// </summary>
        private void ShowQuickButtons()
        {
            var quickButtons = this.settings.QuickButtons
                .Where(qb => this.addOnRegistry.IsAddOnLoaded(qb.RequiredAddOn))
                .OrderBy(qb => qb.Order)
                .ToList();

            this.buttonsShown = true;
            var activeButtons = new List<IButton>();

            while (this.buttons.Count < quickButtons.Count)
            {
                this.buttons.Add(new RoundButton(32));
            }

            for (var i = 0; i < quickButtons.Count; i++)
            {
                this.SetUpButton(quickButtons[i], this.buttons[i], activeButtons);
            }

            this.showAnimation.AnimateButtons(this.mainButton.Button, activeButtons, true);
        }


        private void SetUpButton(IQuickButton quickButton, RoundButton button, List<IButton> activeButtons)
        {
            button.SetIcon(quickButton.Icon);
            button.EnterCallback = () =>
            {
                Global.Frames.GameTooltip.SetOwner(button.Button, BlizzardApi.WidgetEnums.TooltipAnchor.ANCHOR_TOPLEFT);
                Global.Frames.GameTooltip.AddLine(quickButton.Tooltip);
                Global.Frames.GameTooltip.Show();
            };

            button.LeaveCallback = () =>
            {
                var tooltipOwner = this.wrapper.Unwrap(Global.Frames.GameTooltip.GetOwner());
                if (tooltipOwner != null && tooltipOwner == this.wrapper.Unwrap(button.Button))
                {
                    Global.Frames.GameTooltip.Hide();
                }
            };

            button.HideCallback = () =>
            {
                var tooltipOwner = this.wrapper.Unwrap(Global.Frames.GameTooltip.GetOwner());
                if (tooltipOwner != null && tooltipOwner == this.wrapper.Unwrap(button.Button))
                {
                    Global.Frames.GameTooltip.Hide();
                }
            };
            button.ClickCallback = quickButton.Action; // TODO: Use execution strategy.


            activeButtons.Add(button.Button);
        }
    }
}