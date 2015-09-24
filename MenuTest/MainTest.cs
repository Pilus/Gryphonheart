namespace MenuTest
{
    using System;
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Button;
    using GH.Menu.Objects.Dummy;
    using GH.Menu.Objects.Line;
    using GH.Menu.Objects.Page;
    using Lua;

    public class MainTest
    {
        public MainTest(IMenuHandler handler)
        {
            var menu = handler.CreateMenu(
                new MenuProfile("Main test", 400, () => { Core.print("OK"); }, true, () => Core.print("Show"), null, null)
                {
                    title = "Menu tests",
                    icon = "Interface\\Icons\\Ability_Creature_Cursed_04",
                    [0] = new PageProfile()
                    {
                        new LineProfile()
                        {
                            new ButtonProfile()
                            {
                                width = 80,
                                height = 20,
                                align = ObjectAlign.c,
                                text = "Buttons",
                                onClick = (() =>
                                {
                                    new ButtonsTest(handler);
                                })
                            }
                        },
                        new LineProfile()
                        {
                            new ButtonProfile()
                            {
                                width = 80,
                                height = 20,
                                align = ObjectAlign.c,
                                text = "EditBoxes",
                                onClick = (() =>
                                {
                                    new EditBoxesTest(handler);
                                })
                            }
                        },
                    }
                }
                );

            menu.AnimatedShow();
        }
    }
}