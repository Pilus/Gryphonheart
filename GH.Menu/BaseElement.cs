namespace GH.Menu
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Theme;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using CsLuaFramework.Wrapping;
    using Lua;

    public abstract class BaseElement : IElement
    {
        private readonly IWrapper wrapper;

        private IMenuHandler handler;

        private bool prepared;

        public IFrame Frame { get; }

        public NativeLuaTable NativeFrame { get; }

        public BaseElement(string typeName, IWrapper wrapper) : this(typeName, FrameType.Frame, null, wrapper)
        {
        }

        public BaseElement(string typeName, FrameType frameType, string inherits, IWrapper wrapper)
        {
            this.wrapper = wrapper;
            this.Frame = (IFrame)Global.FrameProvider.CreateFrame(frameType, UniqueName(typeName), null, inherits);
            this.NativeFrame = this.wrapper.Unwrap(this.Frame);
        }


        public abstract void ApplyTheme(IMenuTheme theme);

        public virtual void Prepare(IElementProfile profile, IMenuHandler handler)
        { 
            if (this.prepared)
            {
                throw new MenuException("Element is already prepared.");
            }

            this.prepared = true;
            this.handler = handler;
            this.Frame.Show();
        }

        public virtual void Recycle()
        {
            this.prepared = false;
            this.Frame.Hide();
            this.handler.RecyclePool.Store(this);
        }

        public abstract void Clear();

        private static string UniqueName(string type)
        {
            var c = 1;
            while (true)
            {
                var n = type + Strings.tostring(c);
                var obj = Global.Api.GetGlobal(n);
                if (obj == null)
                {
                    return n;
                }
                c++;
            }
        }
    }
}
