[assembly:CsLuaAttributes.CsLuaLibrary]

namespace BlizzardApi.Global
{
    using System;
    using CsLua.Wrapping;
    using Lua;
    using WidgetInterfaces;

    public static class Global
    {
        private static IApi api;
        private static IFrames frames;
        private static IFrameProvider frameProvider;

        public static IApi Api
        { 
            get
            {
                if (api == null)
                {
                    api = Wrapper.WrapGlobalObject<IApi>("_G", true);
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
                    frames = Wrapper.WrapGlobalObject<IFrames>("_G", true);
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
                    frameProvider = Wrapper.WrapGlobalObject<IFrameProvider>("_G", true, FrameTypeTranslator);
                }
                return frameProvider;
            }
            set
            {
                frameProvider = value;
            }
        }

        private static string FrameTypeTranslator(NativeLuaTable obj)
        {
            if (obj["GetObjectType"] != null)
            {
                return "BlizzardApi.WidgetInterfaces.I" + (obj["GetObjectType"] as Func<NativeLuaTable, string>)(obj);
            }

            return null;
        }
    }
}