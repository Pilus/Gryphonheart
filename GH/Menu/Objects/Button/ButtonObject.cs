namespace GH.Menu.Objects.Button
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Menus;
    using Theme;

    public class ButtonObject : BaseObject, IMenuObject
    {
        private const string ButtonTemplate = "GH_Button_Template";
        private const double CompactBorder = 8;

        public static string Type = "Button";

        private readonly IButtonTemplate button;
        private readonly TooltipHandler tooltipHandler;
        private bool ignoreTheme;
        private Action clickAction;

        public ButtonObject() : base(Type, FrameType.Button, ButtonTemplate)
        {
            this.button = (IButtonTemplate) this.Frame;
            this.tooltipHandler = new TooltipHandler(this.Frame);
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.SetupFrame((ButtonProfile)profile);
        }

        private void SetupFrame(ButtonProfile profile)
        {
            this.button.SetText(profile.text);
            if (profile.compact == true)
            {
                this.button.SetHeight(this.button.Text.GetHeight() + CompactBorder);
                this.button.SetWidth(this.button.Text.GetWidth() + CompactBorder);
            }
            else
            {
                if (profile.width != null)
                {
                    this.button.SetWidth((double)profile.width);
                }
                else
                {
                    var origWidth = this.button.GetWidth();
                    this.button.SetWidth(200);
                    if (this.button.Text.GetWidth() > (origWidth - 10))
                    {
                        this.button.SetWidth(this.button.Text.GetWidth() + 10);
                    }
                    else
                    {
                        this.button.SetWidth(origWidth);
                    }
                }

                if (profile.height != null)
                {
                    this.button.SetHeight((double) profile.height);
                }
            }
            this.tooltipHandler.SetTooltip(profile.tooltip);
            this.ignoreTheme = profile.ignoreTheme ?? false;
            this.clickAction = profile.onClick;

            this.button.RegisterForClicks(ClickType.LeftButtonUp);
            this.button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.button.Show();
        }

        private void OnClick(INativeUIObject obj, object arg1, object arg2)
        {
            if (this.clickAction != null)
            {
                this.clickAction();
            }
        }

        public override void ApplyTheme(IMenuTheme theme)
        {
            if (this.ignoreTheme)
            {
                return;
            }
            theme.ButtonColor.Apply(this.button.GetNormalTexture().SetVertexColor);
            theme.ButtonColor.Apply(this.button.GetPushedTexture().SetVertexColor);
        }
    }
}