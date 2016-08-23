namespace WoWSimulator.UISimulation
{
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public interface IFrameActor
    {
        void Click(string text);
        void Click(IButton frame);
        IUIObject GetMouseFocus();
        void MouseOver(IFrame frame);
        void ShowEasyMenu(NativeLuaTable menu);
        void VerifyVisible(string text);
        void VerifyVisible(string text, bool exact);
        bool IsVisible(string text);

        void StartDrag(IButton frame);

        void StopDrag(IButton frame);
    }
}