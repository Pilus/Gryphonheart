
namespace GH.Menu.Containers.Menus
{
    using System;
    using System.Collections.Generic;

    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers.Page;

    using Lua;

    public class TabMenu : WindowedMenu
    {

        private Dictionary<int, IButton> tabButtons;

        private IPage currentPage;

        public TabMenu(IWrapper wrapper) : base(wrapper)
        {
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.DisplayTab(0);
        }

        public void DisplayTab(int tabIndex)
        {
            if (this.tabButtons == null)
            {
                this.CreateTabButtons();
            }

            if (!this.tabButtons.ContainsKey(tabIndex))
            {
                throw new Exception("No tab found for index " + tabIndex);
            }
            InvokeClick(this.tabButtons[tabIndex]);
        }

        private IButton CreateButtonFrame(int index)
        {
            var button = (IButton)Global.FrameProvider.CreateFrame(FrameType.Button, this.Frame.GetName() + "Tab" + (index + 1),
                this.Frame, "CharacterFrameTabButtonTemplate");
            button.SetID(index + 1);

            if (index == 0)
            {
                button.SetPoint(FramePoint.TOPLEFT, this.Frame, FramePoint.BOTTOMLEFT, 20, 0);
            }
            else if (this.tabButtons.ContainsKey(index - 1))
            {
                var prevButton = this.tabButtons[index - 1];
                button.SetPoint(FramePoint.TOPLEFT, prevButton, FramePoint.TOPRIGHT, 0, 0);
            }
            else
            {
                throw new Exception("There is no previous button to anchor button " + (index) + " to.");
            }

            this.tabButtons[index] = button;
            return button;
        }

        private void CreateTabButtons()
        {
            this.tabButtons = new Dictionary<int, IButton>();
            var setTabFunc = (Action<IFrame, int>)Global.Api.GetGlobal("PanelTemplates_SetTab");

            for (var i = 0; i < this.Content.Count; i++)
            {
                var page = this.Content[i];
                page.Hide();
                var button = this.CreateButtonFrame(i);
                button.SetText(page.Name);

                button.SetScript(ButtonHandler.OnClick, (self) =>
                {
                    setTabFunc(this.Frame, button.GetID());
                    if (this.currentPage != null)
                    {
                        this.currentPage.Hide();
                    }

                    this.currentPage = page;
                    page.Show();
                });
            }
            ((Action<IFrame, int>)Global.Api.GetGlobal("PanelTemplates_SetNumTabs"))(this.Frame, this.Content.Count);
        }

        private static void InvokeClick(IButton button)
        {
            var onClick = button.GetScript(ButtonHandler.OnClick);
            if (onClick != null)
            {
                onClick(null, null, null, null, null);
            }
        }
    }
}
