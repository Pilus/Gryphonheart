namespace MenuTest
{
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Button;
    using GH.Menu.Objects.EditBox;
    using GH.Menu.Objects.Line;
    using GH.Menu.Objects.Page;
    using Lua;

    public class EditBoxesTest
    {
        public EditBoxesTest(IMenuHandler handler)
        {
            var menu = handler.CreateMenu(
                new MenuProfile("edit box test", 400, () => { Core.print("OK"); }, true, () => Core.print("Show"), null, null)
                {
                    title = "Edit box tests",
                    icon = "Interface\\Icons\\Ability_Creature_Cursed_04",
                    [0] = new PageProfile()
                    {
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.l,
                                text = "Default:",
                                tooltip = "Default edit box"
                            },
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.c,
                                text = "With width:",
                                width = 40,
                            },
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.r,
                                text = "Numbers",
                                numbersOnly = true,
                            },
                        },
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.l,
                                text = "Vars only:",
                                variablesOnly = true,
                            },
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.c,
                                text = "On text changed:",
                                OnTextChanged = s => { Core.print(s);},
                            },
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.r,
                                text = "Size 3",
                                size = 3,
                            },
                        },
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.l,
                                text = "On enter:",
                                OnEnterPressed = () => { Core.print("Enter"); },
                            },
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.c,
                                text = "Start text:",
                                startText = "the text",
                            },
                        }
                    }
                }
                );

            menu.AnimatedShow();
        } 
    }
}