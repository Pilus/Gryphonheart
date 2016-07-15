namespace GH.UIModules.EasyMenu
{
    using System.Collections.Generic;
    using Lua;

    public class EasyDropDownMenuList : List<EasyDropDownMenuItem>, IEasyDropDownMenuContent
    {
        private readonly string title;

        public EasyDropDownMenuList()
        {
            
        }

        public EasyDropDownMenuList(string title)
        {
            this.title = title;
        }

        public NativeLuaTable GenerateMenuTable()
        {
            var entry = new NativeLuaTable();
            if (!string.IsNullOrEmpty(this.title))
            {
                var titleEntry = new NativeLuaTable();

                titleEntry["isTitle"] = true;
                titleEntry["text"] = this.title;

                Table.insert(entry, titleEntry);
            }

            this.ForEach(item =>
            {
                Table.insert(entry, item.GenerateMenuTable());
            });

            return entry;
        }
    }
}