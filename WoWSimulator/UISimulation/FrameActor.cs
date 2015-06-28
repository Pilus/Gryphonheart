namespace WoWSimulator.UISimulation
{
    using System;
    using System.Linq;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public class FrameActor
    {
        private readonly UiInitUtil util;
        private NativeLuaTable currentMenu;

        public FrameActor(UiInitUtil util)
        {
            this.util = util;
        }

        public void ShowEasyMenu(NativeLuaTable menu)
        {
            this.currentMenu = menu;
        }

        public void Click(string text)
        {
            var button = (IButton)this.util.GetVisibleFrames()
                .FirstOrDefault(b => b is IButton && (b as IButton).GetText().Equals(text));
            if (button != null)
            {
                button.Click();
                return;
            }

            if (this.currentMenu != null)
            {
                var found = false;
                Table.Foreach(this.currentMenu, (key, value) =>
                {
                    if (found) return;
                    if (!(value is NativeLuaTable)) return;

                    var t = (NativeLuaTable)value;
                    if (!t["text"].Equals(text)) return;

                    if (t["menuList"] is NativeLuaTable)
                    {
                        this.currentMenu = (t["menuList"] as NativeLuaTable);
                    }
                    else if (t["func"] is Action)
                    {
                        (t["func"] as Action)();
                    }
                    found = true;
                });
                if (found) return;
            }

            throw new UiSimuationException(string.Format("Could not find element matching text '{0}' to click on.", text));
        }

        public void VerifyVisible(string text, bool exact)
        {
            var analyzedText = string.Empty;
            Func<string, bool> validate = (str) =>
            {
                analyzedText += "'" + str + "' ";
                return (!exact && str.Contains(text)) || str.Equals(text);
            };

            var visibleFrames = this.util.GetVisibleFrames().ToList();
            if (visibleFrames.Any(f =>
                (f is IButton && validate((f as IButton).GetText())))) return;

            if (visibleFrames.SelectMany(f => f.GetRegions()).Any(r =>
                (r is IFontString && validate((r as IFontString).GetText())))) return;

            throw new UiSimuationException(string.Format("No ui elements found displaying the text '{0}'.\nFound texts: {1}.", text, analyzedText));
        }
    }
}