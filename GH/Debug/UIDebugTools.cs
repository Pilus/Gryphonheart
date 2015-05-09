namespace GH.Debug
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Lua;

    public static class UiDebugTools
    {
        public static void FrameBg(IFrame frame)
        {
            var bgFrame = (IFrame) FrameUtil.FrameProvider.CreateFrame(FrameType.Frame);
            bgFrame.SetAllPoints(frame);
            bgFrame.SetFrameLevel(100);
            bgFrame.SetFrameStrata(FrameStrata.HIGH);
            var backdrop = new CsLuaDictionary<object, object>();
            backdrop["bgFile"] = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background";
            backdrop["tile"] = false;
            backdrop["tileSize"] = 0;
            backdrop["edgeSize"] = 16;
            var inserts = new CsLuaDictionary<object, object>();
            backdrop["left"] = 4;
            backdrop["right"] = 4;
            backdrop["top"] = 4;
            backdrop["bottom"] = 0;
            backdrop["insets"] = inserts;
            bgFrame.SetBackdrop(backdrop.ToNativeLuaTable());
            bgFrame.SetBackdropColor(LuaMath.random(100) / 100, LuaMath.random(100) / 100, LuaMath.random(100) / 100, 0.8);
            
        }
    }
}