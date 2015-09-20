namespace GH.UIModules.EasyMenu
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Misc;

    public class EasyMenuHandler
    {
        private readonly IFrame menuFrame;

        public EasyMenuHandler()
        {
            this.menuFrame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, Misc.GetUniqueGlobalName("EasyDropDownMenu"), Global.Frames.UIParent, "UIDropDownMenuTemplate");
        }

        public void Show(IFrame anchor, EasyDropDownMenuList content)
        {
            Global.FrameProvider.EasyMenu(content.GenerateMenuTable(), this.menuFrame, anchor, 0, 0, "MENU");
        }
    }
}