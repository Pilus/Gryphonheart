namespace GH.CommonModules.QuickButtonCluster
{
    using System;
    using System.Collections.Generic;

    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects;
    using GH.Menu.Objects.DropDown;
    using GH.Menu.Objects.DropDown.CustomDropDown;
    using GH.Menu.Objects.Text;

    public class ButtonOptionsMenuProfileGenerator : IMenuProfileGenerator
    {
        private readonly Action onShow;
        private readonly IWrapper wrapper;

        public ButtonOptionsMenuProfileGenerator(Action onShow, IWrapper wrapper)
        {
            this.onShow = onShow;
            this.wrapper = wrapper;
        }

        public MenuProfile GenerateMenuProfile()
        {
            var optionsFrame = this.wrapper.Wrap<IFrame>("InterfaceOptionsFramePanelContainer");
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

        private List<DropDownData> GetDropDownData()
        {
            var list = new List<DropDownData>();

            list.Add(new DropDownData() { text = "Choice A", value = "a"});
            list.Add(new DropDownData() { text = "Choice B", value = "b" });

            return list;
        }
    }
}