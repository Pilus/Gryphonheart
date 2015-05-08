﻿namespace GH.View
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Menu;
    using Menu.Menus;
    using Menu.Objects;
    using Menu.Objects.DropDown;
    using Menu.Objects.DropDown.CustomDropDown;
    using Menu.Objects.Line;
    using Menu.Objects.Page;
    using Menu.Objects.Text;

    public class ButtonOptionsMenuProfileGenerator : IMenuProfileGenerator
    {
        private readonly Action onShow;
        public ButtonOptionsMenuProfileGenerator(Action onShow)
        {
            this.onShow = onShow;
        }

        public MenuProfile GenerateMenuProfile()
        {
            var optionsFrame = (IFrame) FrameUtil.FrameProvider.GetFrameByGlobalName("InterfaceOptionsFramePanelContainer");
            var optionsMenuWidth = optionsFrame.GetWidth() - 20;
            var optionsMenuHeight = optionsFrame.GetHeight() - 20;

            return new MenuProfile("GHButtonOptionsMenu", optionsMenuWidth, null, false, this.onShow, 10, optionsMenuHeight)
            {
                new PageProfile()
                {
                    new LineProfile()
                    {
                        new TextProfile()
                        {
                            align = ObjectAlign.c,
                            color = TextColor.yellow,
                            fontSize = 14,
                            text = "Gryphonheart AddOns"
                        }
                     },
                     new LineProfile()
                    {
                        new TextProfile()
                        {
                            align = ObjectAlign.c,
                            color = TextColor.white,
                            fontSize = 11,
                            text = "By The Gryphonheart Team.\nhttp://www.pilus.info"
                        }
                     },
                     new LineProfile()
                     {
                        new CustomDropDownProfile()
                        {
                            align = ObjectAlign.l,
                            dataFunc = this.GetDropDownData,                           
                            text = "Test:",
                            label = "test",
                            width = 130,
                            returnIndex = false,
                        }
                    }
                }
            };
        }

        private IEnumerable<DropDownData> GetDropDownData()
        {
            var list = new CsLuaList<DropDownData>();

            list.Add(new DropDownData() { text = "Choice A", value = "a"});
            list.Add(new DropDownData() { text = "Choice B", value = "b" });

            return list;
        }
    }
}