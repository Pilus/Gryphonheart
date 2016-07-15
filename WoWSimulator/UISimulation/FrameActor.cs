namespace WoWSimulator.UISimulation
{
    using System;
    using System.Linq;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public class FrameActor : IFrameActor
    {
        private readonly UiInitUtil util;
        private NativeLuaTable currentMenu;
        private IUIObject mouseFocus;

        public FrameActor(UiInitUtil util)
        {
            this.util = util;
        }

        public void ShowEasyMenu(NativeLuaTable menu)
        {
            this.currentMenu = menu;
        }

        private bool ButtonMatchesText(IButton button, string text)
        {
            if (button.GetText().Equals(text))
            {
                return true;
            }

            var pushedTexture = button.GetNormalTexture();
            if (pushedTexture != null)
            {
                if (text.Equals(pushedTexture.GetTexture()))
                {
                    return true;
                }
            }

            return false;
        }

        public void Click(string text)
        {
            var visibleFrames = this.util.GetVisibleFrames().ToList();
            var button = (IButton)visibleFrames
                .FirstOrDefault(f => f is IButton && this.ButtonMatchesText(f as IButton, text));

            if (button != null)
            {
                this.Click(button);
                return;
            }

            var label = visibleFrames.Where(f => f is IButton).SelectMany(f => f.GetRegions()).FirstOrDefault(r =>
                (r is IFontString && text.Equals((r as IFontString).GetText())));
            if (label != null)
            {
                button = (IButton) label.GetParent();
                this.Click(button);
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
                    else if (t["func"] is Function)
                    {
                        (t["func"] as Function)();
                    }
                    found = true;
                });
                if (found) return;
            }

            throw new UiSimuationException(string.Format("Could not find element matching text '{0}' to click on.", text));
        }

        public void VerifyVisible(string text)
        {
            this.VerifyVisible(text, false);
        }

        public bool IsVisible(string text)
        {
            try
            {
                this.VerifyVisible(text, false);
                return true;
            }
            catch (UiSimuationException)
            {
                return false;
            }
        }

        public void VerifyVisible(string text, bool exact)
        {
            var analyzedText = string.Empty;
            Func<string, bool> validate = (str) =>
            {
                if (string.IsNullOrEmpty(str)) return false;
                analyzedText += "'" + str + "' ";
                return (!exact && str.Contains(text)) || str.Equals(text);
            };

            var visibleFrames = this.util.GetVisibleFrames().ToList();
            if (visibleFrames.Any(f =>
                (f is IButton && validate((f as IButton).GetText())))) return;

            if (visibleFrames.SelectMany(f => f.GetRegions()).Any(r =>
                (r is IFontString && validate((r as IFontString).GetText())))) return;

            if(visibleFrames.SelectMany(f => f.GetRegions()).Any(r =>
               (r is ITexture && validate((r as ITexture).GetTexture())))) return;

            throw new UiSimuationException(string.Format("No ui elements found displaying the text '{0}'.\nFound texts: {1}.", text, analyzedText));
        }

        public IUIObject GetMouseFocus()
        {
            return this.mouseFocus;
        }

        public void Click(IButton frame)
        {
            this.MouseOver(frame);
            frame.Click();
        }

        public void MouseOver(IFrame frame)
        {
            this.mouseFocus = frame;
            var script = frame.GetScript(FrameHandler.OnEnter);
            script?.Invoke(null, null, null, null, null);
        }
    }
}