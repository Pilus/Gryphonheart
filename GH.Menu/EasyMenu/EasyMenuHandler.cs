namespace GH.Menu.EasyMenu
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using GH.UIModules.EasyMenu;
    using GH.Utils.Modules;

    public class EasyMenuHandler : SingletonModule
    {
        private readonly IFrame menuFrame;

        public EasyMenuHandler()
        {
            this.menuFrame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, "GH_EasyDropDownMenu", Global.Frames.UIParent, "UIDropDownMenuTemplate");
        }

        public void Show(IFrame anchor, EasyDropDownMenuList content)
        {
            Global.FrameProvider.EasyMenu(content.GenerateMenuTable(), this.menuFrame, anchor, 0, 0, "MENU");
        }
    }
}