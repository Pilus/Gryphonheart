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

    using GH.Menu.Objects;

    /// <summary>
    /// Container handling menu objects with same alignment.
    /// </summary>
    public class AlignedBlock : BaseContainer<IMenuObject, IObjectProfile>, IAlignedBlock
    {
        public ObjectAlign Alignment { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="AlignedBlock"/> class.
        /// </summary>
        /// <param name="wrapper">Wrapper to use in object creation.</param>
        public AlignedBlock(IWrapper wrapper) : base("AlignedBlock", wrapper)
        {
        }

        /// <summary>
        /// Set the position and dimensions of the object relative to its given parent, anchoring top left to top left.
        /// </summary>
        /// <param name="parent">The parent of the object.</param>
        /// <param name="xOff">X offset.</param>
        /// <param name="yOff">Y offset, where positive is downwards.</param>
        /// <param name="width">The width of the object.</param>
        /// <param name="height">The height of the object.</param>
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
                : (width - (preferredWidths.OfType<double>().Sum() + (objectSpacing * (preferredWidths.Length - 1)))) / numFlexibleWidth;

            double widthUsed = 0;
            for (var index = 0; index < this.Content.Count; index++)
            {
                var menuObject = this.Content[index];
                var preferredWidth = preferredWidths[index] ?? flexWidthSizePrElement;
                menuObject.SetPosition(this.Frame, widthUsed + menuObject.GetPreferredOffsetX(), 0 + menuObject.GetPreferredOffsetY(), preferredWidth, menuObject.GetPreferredHeight() ?? height);
                widthUsed += preferredWidth + objectSpacing;
            }
        }

        /// <summary>
        /// Gets the preferred width of the object.
        /// </summary>
        /// <returns>The preferred width. Null if it is flexible.</returns>
        public double? GetPreferredWidth()
        {
            var objectSpacing = this.Layout.objectSpacing;
            var preferredWidths = this.Content.Select(o => o.GetPreferredWidth()).ToArray();

            if (preferredWidths.Any(w => w == null))
            {
                return null;
            }

            return preferredWidths.OfType<double>().Sum() + (objectSpacing * (preferredWidths.Length - 1));
        }

        /// <summary>
        /// Gets the preferred height of the object.
        /// </summary>
        /// <returns>The preferred height. Null if it is flexible.</returns>
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