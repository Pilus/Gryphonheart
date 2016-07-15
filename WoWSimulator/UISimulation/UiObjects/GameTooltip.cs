namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using FrameType = XMLHandler.FrameType;

    public class GameTooltip : Frame, IGameTooltip
    {
        private readonly UiInitUtil util;
        private IFrame owner;
        private TooltipAnchor anchor;
        private readonly List<string> lines = new List<string>();

        public GameTooltip(UiInitUtil util, string objectType, FrameType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
            this.util = util;
        }

        public void AddDoubleLine(string textL, string textR, double rL, double gL, double bL, double rR, double gR, double bR)
        {
            throw new NotImplementedException();
        }

        public void AddFontStrings(string leftstring, string rightstring)
        {
            throw new NotImplementedException();
        }

        public void AddLine(string text)
        {
            lines.Add(text);
        }

        public void AddLine(string text, double red, double green, double blue)
        {
            lines.Add(text);
        }

        public void AddLine(string text, double red, double green, double blue, bool wrapText)
        {
            lines.Add(text);
        }

        public void AddTexture(string texture)
        {
            throw new NotImplementedException();
        }

        public void AppendText(string text)
        {
            throw new NotImplementedException();
        }

        public void ClearLines()
        {
            lines.Clear();
        }

        public void FadeOut()
        {
            throw new NotImplementedException();
        }

        public TooltipAnchor GetAnchorType()
        {
            return this.anchor;
        }

        public IFrame GetOwner()
        {
            return this.owner;
        }

        public void SetOwner(IFrame owner, TooltipAnchor anchor)
        {
            this.owner = owner;
            this.anchor = anchor;
        }

        public void SetOwner(IFrame owner, TooltipAnchor anchor, double x, double y)
        {
            this.owner = owner;
            this.anchor = anchor;
        }
    }
}