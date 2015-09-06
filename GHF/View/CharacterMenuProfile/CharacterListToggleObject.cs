

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
            var frame = (IFrame) Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "CharacterListToggleFrame", parent);
            frame.SetAllPoints(anchor);
            
            var button = (IButton) Global.FrameProvider.CreateFrame(FrameType.Button, parent.GetName() + "CharacterListToggleButton", frame);
            button.SetHeight(Height);
            button.SetWidth(Height);

            var label = frame.CreateFontString();


            // TODO: Label
        }

        
    }
}
