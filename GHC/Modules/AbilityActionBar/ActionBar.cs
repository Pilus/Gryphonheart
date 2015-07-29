namespace GHC.Modules.AbilityActionBar
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using GH.Misc;
    using GH.Presenter;
    using System;

    public class ActionBar : DragableButton, IActionBar
    {
        private const double ButtonSize = 64;
        private const double ContainerEdge = 10;
        private const string NamePrefix = "GH_ActionBar";

        private Func<IFrame, IActionButtonProxy> buttonFactory;
        private CsLuaList<IActionButtonProxy> actionButtons;
        private CsLuaList<IActionButtonProxy> unusedActionButtons;

        public ActionBar(Func<IFrame, IActionButtonProxy> buttonFactory) : base(ButtonSize + ContainerEdge * 2, Misc.GetUniqueGlobalName(NamePrefix))
        {
            this.buttonFactory = buttonFactory;
            this.SetUpContainer();
            this.actionButtons = new CsLuaList<IActionButtonProxy>();
            this.unusedActionButtons = new CsLuaList<IActionButtonProxy>();
        }

        public void AddButton(string id, string iconPath, Action<string> clickFunc, Action<string, IGameTooltip> tooltipFunc)
        {
            var button = this.GetFreeActionButton();
            button.Id = id;
            button.SetIcon(iconPath);
            button.SetOnClick(clickFunc);
            button.SetTooltipFunc(tooltipFunc);
            button.Show();
        }

        public void SetCount(string id, int count)
        {
            var button = this.GetActionButton(id);
            button.SetCount(count);
        }

        public void SetCooldown(string id, double startTime, int duration)
        {
            var button = this.GetActionButton(id);
            button.SetCooldown(startTime, duration);
        }

        public void RemoveButton(string id)
        {
            var button = this.GetActionButton(id);
            button.Hide();
            this.actionButtons.Remove(button);
            this.unusedActionButtons.Add(button);
            this.ReachorActionButtons();
        }

        private IActionButtonProxy GetFreeActionButton()
        {
            var button = this.unusedActionButtons.FirstOrDefault();
            if (button != null)
            {
                this.unusedActionButtons.Remove(button);
            }
            else
            {
                button = this.buttonFactory(this.Button);
                button.SetDimensions(ButtonSize, ButtonSize);
            }

            this.actionButtons.Add(button);
            this.ReachorActionButtons();
            return button;
        }

        private IFrame containerFrame {
            get {
                return this.Button;
            }
        }

        private void ReachorActionButtons()
        {
            this.containerFrame.SetWidth(this.actionButtons.Count * ButtonSize + ContainerEdge * 2);
            for (var i = 0; i < this.actionButtons.Count; i++)
            {
                var button = this.actionButtons[i];
                button.SetPoint(FramePoint.BOTTOMLEFT, i * ButtonSize, 0);
            }
        }

        private void SetUpContainer()
        {
            this.containerFrame.SetPoint(FramePoint.BOTTOM, Global.Frames.UIParent, FramePoint.BOTTOM, 0, 150);
            var backdrop = new CsLuaDictionary<object, object>();
            backdrop["bgFile"] = "x";
            backdrop["edgeFile"] = "Interface/Tooltips/UI-Tooltip-Border";
            backdrop["tile"] = false;
            backdrop["tileSize"] = 16;
            backdrop["edgeSize"] = 16;
            var inserts = new CsLuaDictionary<object, object>();
            backdrop["left"] = 4;
            backdrop["right"] = 4;
            backdrop["top"] = 4;
            backdrop["bottom"] = 4;
            backdrop["insets"] = inserts;
            this.containerFrame.SetBackdrop(backdrop.ToNativeLuaTable());
        }

        private IActionButtonProxy GetActionButton(string id)
        {
            var button = this.actionButtons.FirstOrDefault(ab => ab.Id.Equals(id));
            if (button == null)
            {
                throw new ActionBarException(string.Format("Cannot find action button with id '{0}'.", id));
            }

            return button;
        }
    }
}
