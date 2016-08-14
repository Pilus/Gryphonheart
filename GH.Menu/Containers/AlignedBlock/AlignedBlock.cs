//-----------------------–-----------------------–--------------
// <copyright file="AlignedBlock.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.AlignedBlock
{
    using System.Linq;

    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers.Line;
    using GH.Menu.Objects;

    public class AlignedBlock : BaseContainer<IMenuObject, IObjectProfile>, IAlignedBlock
    {
        public AlignedBlock(IWrapper wrapper) : base("AlignedBlock", wrapper)
        {
        }

        public void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetParent(parent);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);

            var objectSpacing = this.Layout.objectSpacing;

            var preferredWidths = this.Content.Select(o => o.GetPreferredWidth()).ToArray();
            var numFlexibleWidth = preferredWidths.Count(w => w == null);
            var flexWidthSizePrElement = numFlexibleWidth == 0
                ? 0
                : (width - preferredWidths.OfType<double>().Sum() - objectSpacing * (preferredWidths.Length - 1)) / numFlexibleWidth;

            double widthUsed = 0;
            for (int index = 0; index < this.Content.Count; index++)
            {
                var menuObject = this.Content[index];
                var preferredWidth = preferredWidths[index] ?? flexWidthSizePrElement;
                menuObject.SetPosition(this.Frame, widthUsed + menuObject.GetPreferredOffsetX(), 0 + menuObject.GetPreferredOffsetY(), preferredWidth, menuObject.GetPreferredHeight() ?? height);
                widthUsed += preferredWidth + objectSpacing;
            }
        }

        public double? GetPreferredWidth()
        {
            var objectSpacing = this.Layout.objectSpacing;
            var preferredWidths = this.Content.Select(o => o.GetPreferredWidth()).ToArray();

            if (preferredWidths.Any(w => w == null))
            {
                return null;
            }

            return preferredWidths.Sum() + objectSpacing * (preferredWidths.Length - 1);
        }

        public double? GetPreferredHeight()
        {
            var preferredHeight = this.Content.Select(o => o.GetPreferredHeight()).ToArray();

            if (preferredHeight.Any(w => w == null))
            {
                return null;
            }

            return preferredHeight.Max();
        }
    }
}