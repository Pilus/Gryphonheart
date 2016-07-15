

namespace GHD.View.DocumentMenu.ToolbarCatagories
{
    using System;
    using GH.Menu.Objects.StandardButtonWithTexture;
    using GH.Menu.Objects.Toolbar;

    public class MetaCatagoryProfileGenerator : ICatagoryProfileGenerator
    {
        private readonly Action undo;
        private readonly Action redo;
        private readonly Action revert;
        private readonly Action save;

        public MetaCatagoryProfileGenerator(Action undo, Action redo, Action revert, Action save)
        {
            this.undo = undo;
            this.redo = redo;
            this.revert = revert;
            this.save = save;
        }

        public ToolbarCatagoryProfile GenerateMenuProfile()
        {
            return new ToolbarCatagoryProfile("Meta")
            {
                new ToolbarLineProfile()
                {
                    new StandardButtonWithTextureProfile()
                    {
                        tooltip = "Undo",
                        texture = "Interface\\AddOns\\GHD\\Textures\\ButtonIcons",
                        texCoord = ButtonTexCoordProvider.GetTexCoord(2, 2),
                        onClick = this.undo,
                    },
                    new StandardButtonWithTextureProfile()
                    {
                        tooltip = "Redo",
                        texture = "Interface\\AddOns\\GHD\\Textures\\ButtonIcons",
                        texCoord = ButtonTexCoordProvider.GetTexCoord(3, 2),
                        onClick = this.redo,
                    },
                },
                new ToolbarLineProfile()
                {
                    new StandardButtonWithTextureProfile()
                    {
                        tooltip = "Revert",
                        texture = "Interface\\AddOns\\GHD\\Textures\\ButtonIcons",
                        texCoord = ButtonTexCoordProvider.GetTexCoord(4, 2),
                        onClick = this.revert,
                    },
                    new StandardButtonWithTextureProfile()
                    {
                        tooltip = "Save",
                        texture = "Interface\\AddOns\\GHD\\Textures\\ButtonIcons",
                        texCoord = ButtonTexCoordProvider.GetTexCoord(4, 1),
                        onClick = this.save,
                    },
                },
            };
        }
    }
}
