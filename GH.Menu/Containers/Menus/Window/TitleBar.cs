﻿namespace GH.Menu.Containers.Menus.Window
{
    using System;

    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using GH.Menu.Theme;

    using Lua;

    public class TitleBar
    {
        public const double BarHeight = 26;
        public const double BorderSize = 4;
        private readonly DragableButton dragableButton;
        private readonly IFontString textFrame;
        private readonly ContentContainer attachedFrame;
        private readonly ITexture background;
        private readonly IButton closeButton;
        private readonly IFrame borderFrame;
        private readonly ITexture iconTexture;

        public TitleBar(ContentContainer attachedFrame)
        {
            this.attachedFrame = attachedFrame;
            this.dragableButton = CreateDragableButton(this.attachedFrame);
            this.textFrame = CreateText(this.dragableButton);
            this.background = CreateBackground(this.dragableButton);
            this.closeButton = CreateCloseButton(this.dragableButton, () => { this.attachedFrame.Hide(); });
            this.attachedFrame.AttachTo(this.dragableButton.Button);
            this.borderFrame = CreateBorder(this.dragableButton);
            this.iconTexture = CreateIconTexture(this.dragableButton);
        }

        public IFrame GetFrame()
        {
            return this.dragableButton.Button;
        }

        public void Show()
        {
            var yOff = this.attachedFrame.GetHeight() + BarHeight + (BorderSize*2);
            this.dragableButton.SetPosition(Global.Frames.UIParent.GetWidth() / 2, (Global.Frames.UIParent.GetHeight() + yOff)/ 2);
            this.dragableButton.Button.Show();
        }

        public void SetTitle(string title)
        {
            this.textFrame.SetText(title);
        }

        public void SetIcon(string iconPath)
        {
            this.iconTexture.SetTexture(iconPath);
        }

        public void ApplyTheme(IMenuTheme theme)
        {
            theme.TitleBarTextColor.Apply(this.textFrame.SetTextColor);
            theme.TitleBarBackgroundColor.Apply(this.background.SetTexture);
        }

        private static DragableButton CreateDragableButton(ContentContainer attachedFrame)
        {
            var button = new DragableButton(BarHeight, attachedFrame.GetName() + "TitleBar") {DragWithoutShift = true};
            button.Button.SetWidth(attachedFrame.GetWidth());
            return button;
        }

        private static ITexture CreateBackground(DragableButton button)
        {
            var texture = button.Button.CreateTexture(null, Layer.BACKGROUND);
            texture.SetTexture(0.2, 0.2, 0.2);
            texture.SetPoint(FramePoint.TOPLEFT, BorderSize, -BorderSize);
            texture.SetPoint(FramePoint.BOTTOMRIGHT, -BorderSize, BorderSize);
            return texture;
        }

        private static IFontString CreateText(DragableButton button)
        {
            var text = button.Button.CreateFontString(null, Layer.OVERLAY, "SystemFont_Med1");
            text.SetHeight(BarHeight);
            text.SetPoint(FramePoint.CENTER, 0, 0);
            text.SetJustifyH(JustifyH.CENTER);
            return text;
        }

        private static IButton CreateCloseButton(DragableButton button, Action closeAction)
        {
            var closeButton = (IButton)Global.FrameProvider.CreateFrame(FrameType.Button, button.Button.GetName() + "CloseButton", button.Button,
                "UIPanelCloseButton");
            closeButton.SetPoint(FramePoint.RIGHT, button.Button, FramePoint.RIGHT, 6 - BorderSize, 0);
            closeButton.SetHeight(BarHeight);
            closeButton.SetWidth(BarHeight);
            closeButton.SetScript(ButtonHandler.OnClick, (obj, arg1, arg2) => { closeAction(); });
            return closeButton;
        }

        private static IFrame CreateBorder(DragableButton button)
        {
            var frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, null, button.Button);
            frame.SetAllPoints(button.Button);
            SetBackdrop(frame, "");
            return frame;
        }

        private static ITexture CreateIconTexture(DragableButton button)
        {
            var texture = button.Button.CreateTexture(null, Layer.ARTWORK);
            texture.SetPoint(FramePoint.LEFT, button.Button, FramePoint.LEFT, BorderSize, 0);
            var dim = BarHeight - BorderSize*2; 
            texture.SetHeight(dim);
            texture.SetWidth(dim);
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
            backdrop["left"] = BorderSize;
            backdrop["right"] = BorderSize;
            backdrop["top"] = BorderSize;
            backdrop["bottom"] = BorderSize;
            backdrop["insets"] = inserts;
            frame.SetBackdrop(backdrop);
        }
    }
}