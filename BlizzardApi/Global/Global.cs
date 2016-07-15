[assembly: CsLuaFramework.Attributes.CsLuaLibrary]

namespace BlizzardApi.Global
{
    using System;
    using CsLuaFramework.Wrapping;
    using Lua;
    using WidgetEnums;
    using WidgetInterfaces;

    public static class Global
    {
        private static IApi api;
        private static IFrames frames;
        private static IFrameProvider frameProvider;

        public static IWrapper Wrapper = new Wrapper();

        public static IApi Api
        { 
            get
            {
                if (api == null)
                {
                    api = Wrapper.Wrap<IApi>("_G");
                }
                return api;
            }
            set
            {
                api = value;
            }
        }
        public static IFrames Frames
        {
            get
            {
                if (frames == null)
                {
                    frames = Wrapper.Wrap<IFrames>("_G");
                }
                return frames;
            }
            set
            {
                frames = value;
            }
        }

        public static IFrameProvider FrameProvider
        {
            get
            {
                if (frameProvider == null)
                {
                    frameProvider = Wrapper.Wrap<IFrameProvider>("_G", FrameTypeTranslator);
                }
                return frameProvider;
            }
            set
            {
                frameProvider = value;
            }
        }

        private static Type FrameTypeTranslator(NativeLuaTable obj) 
        {
            if (obj["GetObjectType"] == null) return null;

            var type = (obj["GetObjectType"] as Func<NativeLuaTable, string>)(obj);
            var frameType = (FrameType)Enum.Parse(typeof (FrameType), type);

            switch (frameType)
            {
                case FrameType.Frame:
                    return typeof (IFrame);
                case FrameType.Button:
                    return typeof(IButton);
                case FrameType.CheckButton:
                    return typeof(ICheckButton);
                case FrameType.EditBox:
                    return typeof(IEditBox);
                case FrameType.GameTooltip:
                    return typeof(IGameTooltip);
                case FrameType.ScrollFrame:
                    return typeof(IScrollFrame);
                case FrameType.FontString:
                    return typeof(IFontString);
                case FrameType.FontInstance:
                    return typeof (IFontInstance);
                case FrameType.Slider:
                    return typeof (ISlider);
                case FrameType.StatusBar:
                    return typeof (IStatusBar);
                case FrameType.Texture:
                    return typeof (ITexture);
                default:
                    throw new Exception("Could not translate frame type " + type);
            }
        }
    }
}