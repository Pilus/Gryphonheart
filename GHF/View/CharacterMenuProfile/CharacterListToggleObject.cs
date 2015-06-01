

namespace GHF.View.CharacterMenuProfile
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GH.Debug;
    using BlizzardApi.Global;

    public class CharacterListToggleObject
    {
        public static double Height = 32;
        public static double Width = 120;
        

        public CharacterListToggleObject(IFrame parent, IFrame anchor, Action toggle)
        {
            var frame = Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "CharacterListToggleFrame", parent) as IFrame;
            frame.SetAllPoints(anchor);
            DebugTools.Msg("List toggle", anchor.GetName(), anchor.GetWidth());
            DebugTools.FrameBg(frame);

            var button = Global.FrameProvider.CreateFrame(FrameType.Button, parent.GetName() + "CharacterListToggleButton", frame) as IButton;


            var label = frame.CreateFontString();


            // TODO: Label
        }

        
    }
}
