namespace GH.UIModules.EasyMenu
{
    using System;
    using Lua;

    public class EasyDropDownMenuItem : IEasyDropDownMenuContent
    {
        private string text;
        private string icon;
        private Action action;

        public EasyDropDownMenuItem(string text) : this(text, null, null)
        {
            
        }

        public EasyDropDownMenuItem(string text, string icon, Action action)
        {
            this.text = text;
            this.icon = icon;
            this.action = action;
        }

        public EasyDropDownMenuList InnerList { get; set; }

        public NativeLuaTable GenerateMenuTable()
        {
            var entry = new NativeLuaTable();

            if (this.InnerList != null)
            {
                entry["hasArrow"] = true;
                entry["menuList"] = this.InnerList.GenerateMenuTable();
            }

            if (!string.IsNullOrEmpty(this.text))
            {
                entry["text"] = this.text;
            }

            if (!string.IsNullOrEmpty(this.icon))
            {
                entry["icon"] = this.icon;
            }

            if (this.action != null)
            {
                entry["func"] = this.action;
            }

            return entry;
        }
    }
}