

namespace GHF.View.CharacterMenuProfile.CharacterList
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using BlizzardApi.Global;
    using GH.Menu.Objects;

    public class CharacterListToggleObject
    {
        public static double Height = 32;
        public static double Width = 120;

        private const string UntoggledTooltip = "Show your other characters";
        private const string ToggledTooltip = "Hide character list";

        private const string UntoggledTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up";
        private const string ToggledTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down";

        private bool toggled = false;
        private readonly IButton button;
        private readonly ITextLabelWithTooltip labelFrame;
        private readonly TooltipHandler tooltipHandler;

        public CharacterListToggleObject(IFrame parent, IFrame anchor, Action toggle)
        {
            var frame = (IFrame) Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "CharacterListToggleFrame", parent);
            frame.SetAllPoints(anchor);
            
            this.button = (IButton) Global.FrameProvider.CreateFrame(FrameType.Button, frame.GetName() + "Button", frame);
            this.button.SetHeight(Height);
            this.button.SetWidth(Height);
            this.button.SetNormalTexture(UntoggledTexture);
            this.button.SetPushedTexture(ToggledTexture);
            this.button.SetPoint(FramePoint.LEFT);
            this.button.SetScript(ButtonHandler.OnClick, this.Toggle);

            this.tooltipHandler = new TooltipHandler(this.button);
            this.tooltipHandler.SetTooltip(UntoggledTooltip);

            this.labelFrame = (ITextLabelWithTooltip) Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "Text", frame, "GH_TextLabel_Template");
            this.labelFrame.SetPoint(FramePoint.LEFT, Height + 2, 0);
            this.labelFrame.Label.SetText("My Characters");
            this.labelFrame.Tooltip = UntoggledTooltip;
        }

        private void Toggle(IUIObject _, object arg1, object arg2)
        {
            this.toggled = !this.toggled;
            if (this.toggled)
            {
                this.button.SetNormalTexture(ToggledTexture);
                this.labelFrame.Tooltip = ToggledTooltip;
                this.tooltipHandler.SetTooltip(ToggledTooltip);
            }
            else
            {
                this.button.SetNormalTexture(UntoggledTexture);
                this.labelFrame.Tooltip = UntoggledTooltip;
                this.tooltipHandler.SetTooltip(UntoggledTooltip);
            }
        }

        
    }
}
