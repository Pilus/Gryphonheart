namespace GHC.Modules.AbilityActionBar
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using System;

    public class ActionButtonProxy
    {
        private ICheckButton button;
        private Action<IGameTooltip> updateFunc;

        public ActionButtonProxy(IFrame parent)
        {
            this.button = Global.FrameProvider.CreateFrame(FrameType.CheckButton, GetNextName(parent.GetName()), parent, "ActionButtonTemplate") as ICheckButton;
            this.button.RegisterForClicks(ClickType.LeftButtonUp, ClickType.RightButtonUp);
            this.SetupHandlersForTooltips();
        }

        public void SetOnClick(Action func)
        {
            this.button.SetScript(ButtonHandler.OnClick, (IButton b) => { func(); });
        }

        public void SetTooltipFunc(Action<IGameTooltip> updateFunc)
        {
            this.updateFunc = updateFunc;
        }

        private void SetupHandlersForTooltips()
        {
            this.button.SetScript(FrameHandler.OnEnter, (IFrame f) =>
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

            this.button.SetScript(FrameHandler.OnLeave, (IFrame f) =>
            {
                Global.Frames.GameTooltip.Hide();
            });

            this.button.SetScript(FrameHandler.OnUpdate, (IFrame f) => {
                if (Global.Frames.GameTooltip.GetOwner() == this.button)
                {
                    this.updateFunc(Global.Frames.GameTooltip);
                }
            });
        }

        private static string GetNextName(string parentName)
        {
            var i = 1;
            while (Global.Api.GetGlobal(parentName + "ActionButton" + i) != null)
            {
                i++;
            }

            return parentName + "ActionButton" + i;
        }
    }
}