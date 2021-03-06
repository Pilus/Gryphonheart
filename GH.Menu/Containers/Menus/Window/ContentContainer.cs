﻿namespace GH.Menu.Containers.Menus.Window
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using GH.Menu.Theme;

    using Lua;

    public class ContentContainer
    {
        private readonly IFrame content;
        private readonly IFrame borderFrame;
        private readonly ITexture background;
        private IFrame attachedTo;

        public ContentContainer(IFrame content)
        {
            this.content = content;
            this.borderFrame = CreateBorderFrame(this.content);
            this.background = CreateBackground(this.content);
        }

        public void Show()
        {
            this.content.Show();
        }

        public void Hide()
        {
            this.content.Hide();
        }

        public double GetWidth()
        {
            return this.content.GetWidth() + TitleBar.BorderSize*2;
        }

        public double GetHeight()
        {
            return this.content.GetHeight() + TitleBar.BorderSize;
        }

        public string GetName()
        {
            return this.content.GetName();
        }

        public void AttachTo(IFrame frame)
        {
            this.attachedTo = frame;
            this.content.SetParent(frame);
            this.content.SetPoint(FramePoint.TOP, frame, FramePoint.BOTTOM, 0, TitleBar.BorderSize/2);
        }

        public void ApplyTheme(IMenuTheme theme)
        {
            this.background.SetTexture(theme.BackgroundTexturePath);
            if (theme.BackgroundTextureInserts != null)
            {
                var inserts = theme.BackgroundTextureInserts;
                this.background.SetTexCoord(inserts.Left, inserts.Right, inserts.Top, inserts.Bottom);
            }
        }

        private static IFrame CreateBorderFrame(IFrame parent)
        {
            var frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, null, parent);
            frame.SetPoint(FramePoint.TOPLEFT, -TitleBar.BorderSize, TitleBar.BarHeight - TitleBar.BorderSize);
            frame.SetPoint(FramePoint.BOTTOMRIGHT, TitleBar.BorderSize, -TitleBar.BorderSize);
            SetBackdrop(frame, string.Empty);
            frame.SetFrameStrata(FrameStrata.LOW);
            return frame;
        }

        private static ITexture CreateBackground(IFrame parent)
        {
            var texture = parent.CreateTexture();
            texture.SetAllPoints(parent);
            return texture;
        }

        private static void SetBackdrop(IFrame frame, string texture)
        {
            var backdrop = new NativeLuaTable();
            backdrop["bgFile"] = texture;
            backdrop["edgeFile"] = "Interface/Tooltips/UI-Tooltip-Border";
            backdrop["tile"] = false;
            backdrop["tileSize"] = 16;
            backdrop["edgeSize"] = 16;
            var inserts = new NativeLuaTable();
            backdrop["left"] = TitleBar.BorderSize;
            backdrop["right"] = TitleBar.BorderSize;
            backdrop["top"] = TitleBar.BorderSize;
            backdrop["bottom"] = TitleBar.BorderSize;
            backdrop["insets"] = inserts;
            frame.SetBackdrop(backdrop);
        }

        
    }
}