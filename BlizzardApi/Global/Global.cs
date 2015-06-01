[assembly:CsLua.Attributes.IsCsLuaLibrary]

namespace BlizzardApi.Global
{
    using CsLua.Wrapping;
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
                    api = Wrapper.WrapGlobalObject<IApi>("_G");
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
                    frames = Wrapper.WrapGlobalObject<IFrames>("_G");
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
                if (frames == null)
                {
                    frameProvider = Wrapper.WrapGlobalObject<IFrameProvider>("_G");
                }
                return frameProvider;
            }
            set
            {
                frameProvider = value;
            }
        }
    }
}