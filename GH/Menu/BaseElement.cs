namespace GH.Menu
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Theme;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using Lua;

    public abstract class BaseElement : IElement
    {
        private IMenuHandler handler;

        public IFrame Frame { get; private set; }

        public BaseElement(string typeName) : this(typeName, FrameType.Frame, null)
        {
        }

        public BaseElement(string typeName, FrameType frameType, string inherits)
        {
            this.Frame = (IFrame)Global.FrameProvider.CreateFrame(frameType, UniqueName(typeName), null, inherits);
        }


        public abstract void ApplyTheme(IMenuTheme theme);

        public virtual void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            this.handler = handler;
            this.Frame.Show();
        }

        public virtual void Recycle()
        {
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
