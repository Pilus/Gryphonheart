

namespace GHD.View.DocumentMenu
{
    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects.Dummy;
    using GH.Menu.Objects.Toolbar;
    using ToolbarCatagories;

    public class DocumentMenuProfileGenerator : IMenuProfileGenerator
    {
        private int menuCount;
        private readonly MetaCatagoryProfileGenerator metaCatagory;

        public DocumentMenuProfileGenerator(MetaCatagoryProfileGenerator metaCatagory)
        {
            this.metaCatagory = metaCatagory;
        }


        public MenuProfile GenerateMenuProfile()
        {
            menuCount++;
            return new MenuProfile("GHD_DocumentMenu" + this.menuCount, 800, null, true, null, 10, 600)
            {
                new PageProfile()
                {
                    new LineProfile()
                    {
                        new MultiPageToolbarProfile()
                        {
                            new ToolbarPageProfile("Formatting")
                            {
                                this.metaCatagory.GenerateMenuProfile(),
                            }
                        },
                    },
                    new LineProfile()
                    {
                        new DummyProfile()
                        {
                            label = DocumentMenuLabels.DocumentArea,
                        }
                    }
                }
            };
        }
    }
}
