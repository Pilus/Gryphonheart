﻿
namespace GH.Menu.Menus
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using Objects.Page;

    public class TabMenu : WindowedMenu
    {
        private CsLuaDictionary<int, IButton> tabButtons;

        private IPage currentPage;

        public TabMenu(MenuProfile profile) : base(profile)
        {
            this.UpdatePosition();
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
                throw new CsException("No tab found for index " + tabIndex);
            }
            InvokeClick(this.tabButtons[tabIndex]);
        }

        private IButton CreateButtonFrame(int index)
        {
            var button = (IButton)FrameUtil.FrameProvider.CreateFrame(FrameType.Button, this.Frame.GetName() + "Tab" + (index + 1),
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
                throw new CsException("There is no previous button to anchor button " + (index) + " to.");
            }

            this.tabButtons[index] = button;
            return button;
        }

        private void CreateTabButtons()
        {
            this.tabButtons = new CsLuaDictionary<int, IButton>();
            var setTabFunc = (Action<INativeUIObject, int>)Global.GetGlobal("PanelTemplates_SetTab");

            for (var i = 0; i < this.Pages.Count; i++)
            {
                var page = this.Pages[i];
                page.Hide();
                var button = this.CreateButtonFrame(i);
                button.SetText(page.Name);

                button.SetScript(ButtonHandler.OnClick, () =>
                {
                    setTabFunc(this.Frame.self, button.GetID());
                    if (this.currentPage != null)
                    {
                        this.currentPage.Hide();
                    }

                    this.currentPage = page;
                    page.Show();
                });
            }
            ((Action<INativeUIObject, int>)Global.GetGlobal("PanelTemplates_SetNumTabs"))(this.Frame.self, this.Pages.Count);
        }

        private static void InvokeClick(IButton button)
        {
            var onClick = button.GetScript(ButtonHandler.OnClick);
            if (onClick != null)
            {
                onClick();
            }
        }
    }
}
