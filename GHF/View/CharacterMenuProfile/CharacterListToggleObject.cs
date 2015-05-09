

namespace GHF.View.CharacterMenuProfile
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class CharacterListToggleObject
    {
        public static double Height = 32;
        public static double Width = 120;
        

        public CharacterListToggleObject(IFrame parent, float xOff, float yOff, Action toggle)
        {
            var frame = FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "CharacterListToggleFrame", parent) as IFrame;
            frame.SetWidth(Width);
            frame.SetHeight(Height);
            frame.SetPoint(FramePoint.TOPLEFT, xOff, yOff);

            var button = FrameUtil.FrameProvider.CreateFrame(FrameType.Button, parent.GetName() + "CharacterListToggleButton", frame) as IButton;


            var label = frame.CreateFontString();


            // TODO: Label
        }

        
    }
}
