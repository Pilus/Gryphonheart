
namespace BlizzardApi.Global
{
    using Lua;
    using WidgetEnums;
    using WidgetInterfaces;

    public interface IFrameProvider
    {
        IUIObject CreateFrame(FrameType frameType);

        IUIObject CreateFrame(FrameType frameType, string name);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent, string inherits);

        IUIObject GetMouseFocus();
         
        void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode, double autoHideDelay);
        void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode, double autoHideDelay);
        void EasyMenu(NativeLuaTable menuList, IFrame frame, IFrame anchor, double x, double y, string displayMode);
        void EasyMenu(NativeLuaTable menuList, IFrame frame, string anchor, double x, double y, string displayMode);

        /*
        CreateFont("name") - Dynamically create a font object 
        GetFramesRegisteredForEvent(event) - Returns a list of frames that are registered for the given event. (added 2.3) 
        GetNumFrames() - Get the current number of Frame (and derivative) objects 
        UI EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay) 
        EnumerateFrames(currentFrame) - Get the Frame which follows currentFrame 
        GetMouseFocus() - Returns the frame that currently has the mouse focus. 
        UI MouseIsOver - Determines whether or not the mouse is over the specified frame. 
        UI ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset) 
        UI UIFrameFadeIn(frame, fadeTime, startAlpha, endAlpha) 
        UI UIFrameFlash(...)  
         */
    }
}
