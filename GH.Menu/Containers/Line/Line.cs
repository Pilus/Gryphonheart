//-----------------------–-----------------------–--------------
// <copyright file="Line.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.Line
{
    using System.Collections.Generic;
    using System.Linq;

    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using GH.Menu.Containers;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Objects;
    using Lua;

    /// <summary>
    /// Container for aligned blocks on a line.
    /// </summary>
    public class Line : BaseContainer<IAlignedBlock, LineProfile>, ILine
    {
        /// <summary>
        /// The left block.
        /// </summary>
        private IAlignedBlock leftBlock;

        /// <summary>
        /// The center block.
        /// </summary>
        private IAlignedBlock centerBlock;

        /// <summary>
        /// The right block.
        /// </summary>
        private IAlignedBlock rightBlock;

        /// <summary>
        /// Initializes a new instance of the <see cref="Line"/> class.
        /// </summary>
        /// <param name="wrapper">Wrapper to use in object creation.</param>
        public Line(IWrapper wrapper) : base("Line", wrapper)
        {
        }

        /// <summary>
        /// Prepares the object with a given profile.
        /// </summary>
        /// <param name="profile">The profile to prepare with.</param>
        /// <param name="handler">The menu handler.</param>
        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(null, handler);
            var lineProfile = (LineProfile)profile;
            this.leftBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.l, handler);
            this.centerBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.c, handler);
            this.rightBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.r, handler);
            this.Content = new List<IAlignedBlock>() { this.leftBlock, this.centerBlock, this.rightBlock };
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

            var leftPreferredWidth = this.leftBlock?.GetPreferredWidth();
            var centerPreferredWidth = this.centerBlock?.GetPreferredWidth();
            var rightPreferredWidth = this.rightBlock?.GetPreferredWidth();

            var leftAllocatedWidth = this.GetWidthAllocatedToLeftBlock(width, leftPreferredWidth, centerPreferredWidth, rightPreferredWidth);
            this.leftBlock?.SetPosition(this.Frame, 0, 0, leftAllocatedWidth, this.leftBlock.GetPreferredHeight() ?? height);

            var centerAllocatedWidth = this.GetWidthAllocatedToCenterBlock(width, leftPreferredWidth, centerPreferredWidth, rightPreferredWidth);
            this.centerBlock?.SetPosition(this.Frame, (width - centerAllocatedWidth) / 2, 0, centerAllocatedWidth, this.centerBlock.GetPreferredHeight() ?? height);

            var rightAllocatedWidth = this.GetWidthAllocatedToRightBlock(width, leftPreferredWidth, centerPreferredWidth, rightPreferredWidth);
            this.rightBlock?.SetPosition(this.Frame, width - rightAllocatedWidth, 0, rightAllocatedWidth, this.rightBlock.GetPreferredHeight() ?? height);
        }

        /// <summary>
        /// Gets the preferred width of the object.
        /// </summary>
        /// <returns>The preferred width. Null if it is flexible.</returns>
        public double? GetPreferredWidth()
        {
            var widths = this.Content.Select(block => block.GetPreferredWidth()).ToArray();
            if (widths.Any(w => w == null))
            {
                return null;
            }

            return widths.Sum() + ((widths.Length - 1) * this.Layout.objectSpacing);
        }

        /// <summary>
        /// Gets the preferred height of the object.
        /// </summary>
        /// <returns>The preferred height. Null if it is flexible.</returns>
        public double? GetPreferredHeight()
        {
            var heights = this.Content.Select(block => block.GetPreferredHeight()).ToArray();
            if (heights.Any(w => w == null))
            {
                return null;
            }

            return heights.Max();
        }

        /// <summary>
        /// Generates and Prepares a <see cref="IAlignedBlock"/>.
        /// </summary>
        /// <param name="profile">The profile used to prepare the block.</param>
        /// <param name="align">The alignment of the block.</param>
        /// <param name="handler">The menu handler.</param>
        /// <returns>The generated block.</returns>
        private static IAlignedBlock GenerateAndPrepareBlock(LineProfile profile, ObjectAlign align, IMenuHandler handler)
        {
            var blockProfile = GenerateAlignedProfile(profile, align);
            if (blockProfile.Count == 0)
            {
                return null;
            }

            return (IAlignedBlock)handler.CreateRegion(blockProfile, false, typeof(AlignedBlock));
        }

        /// <summary>
        /// Generates a <see cref="LineProfile"/> with all elements fitting a given alignment.
        /// </summary>
        /// <param name="profile">The <see cref="LineProfile"/> with elements in it.</param>
        /// <param name="align">The alignment to fit.</param>
        /// <returns>The generated <see cref="LineProfile"/>.</returns>
        private static LineProfile GenerateAlignedProfile(LineProfile profile, ObjectAlign align)
        {
            var newProfile = new LineProfile();
            newProfile.AddRange(profile.Where(p => p.align == align));
            return newProfile;
        }

        /// <summary>
        /// Gets the width allocated to the left block.
        /// </summary>
        /// <param name="width">The total width available.</param>
        /// <param name="leftPreferredWidth">The width preferred by the left block.</param>
        /// <param name="centerPreferredWidth">The width preferred by the center block.</param>
        /// <param name="rightPreferredWidth">The width preferred by the right block.</param>
        /// <returns>The allocated width.</returns>
        private double GetWidthAllocatedToLeftBlock(double width, double? leftPreferredWidth, double? centerPreferredWidth, double? rightPreferredWidth)
        {
            if (this.leftBlock == null)
            {
                return 0;
            }

            // There is a left block.
            if (leftPreferredWidth != null)
            {
                return leftPreferredWidth.Value;
            }

            // The left block is flexible.
            if (this.centerBlock == null)
            {
                // There is no center block
                if (this.rightBlock == null)
                {
                    // There is no right block.
                    return width;
                }

                // There is a right block.
                if (rightPreferredWidth != null)
                {
                    // The right block is not flexible.
                    return width - (rightPreferredWidth.Value + this.Layout.objectSpacing);
                }

                // The right block is flexible
                return (width - this.Layout.objectSpacing) / 2;
            }

            // There is a center block
            if (centerPreferredWidth != null)
            {
                // The center block is fixed.
                return ((width - centerPreferredWidth.Value) / 2) - this.Layout.objectSpacing;
            }
            
            // The center block is flexible
            if (this.rightBlock == null)
            {
                // There is no right block.
                // The flexible left block must share the left side with half of the center block.
                return ((width / 2) - this.Layout.objectSpacing) / 1.5;
            }

            // There is a right block.
            if (rightPreferredWidth != null)
            {
                // The right block is not flexible.
                return LuaMath.max(rightPreferredWidth.Value, (((width / 2) - this.Layout.objectSpacing) / 3) * 2);
            }

            // The right block is flexible
            return (width - (this.Layout.objectSpacing * 2)) / 3;
        }

        /// <summary>
        /// Gets the width allocated to the center block.
        /// </summary>
        /// <param name="width">The total width available.</param>
        /// <param name="leftPreferredWidth">The width preferred by the left block.</param>
        /// <param name="centerPreferredWidth">The width preferred by the center block.</param>
        /// <param name="rightPreferredWidth">The width preferred by the right block.</param>
        /// <returns>The allocated width.</returns>
        private double GetWidthAllocatedToCenterBlock(double width, double? leftPreferredWidth, double? centerPreferredWidth, double? rightPreferredWidth)
        {
            if (this.centerBlock == null)
            {
                return 0;
            }

            // There is a center block.
            if (centerPreferredWidth != null)
            {
                return centerPreferredWidth.Value;
            }

            // The center block is flexible.
            if (this.leftBlock == null)
            {
                // There is no left block
                if (this.rightBlock == null)
                {
                    // There is no right block.
                    return width;
                }

                // There is a right block.
                if (rightPreferredWidth != null)
                {
                    // The right block is not flexible.
                    return ((width / 2) - (rightPreferredWidth.Value + this.Layout.objectSpacing)) * 2;
                }

                // The right block is flexible
                return (((width / 2) - this.Layout.objectSpacing) / 3) * 2;
            }

            // There is a left block
            var halfWidthMinusOneObjectSpacing = (width / 2) - this.Layout.objectSpacing;

            if (leftPreferredWidth != null)
            {
                // The left block is fixed.
                if (this.rightBlock != null && rightPreferredWidth != null)
                {
                    // There is a fixed right block.
                    return (((width / 2) - LuaMath.max(leftPreferredWidth.Value, rightPreferredWidth.Value)) - this.Layout.objectSpacing) * 2;
                }

                if (this.rightBlock != null)
                {
                    // There is a flexible right block.
                    return LuaMath.min((halfWidthMinusOneObjectSpacing / 3) * 2, (halfWidthMinusOneObjectSpacing - leftPreferredWidth.Value) * 2);
                }

                // There is no right block.
                return (halfWidthMinusOneObjectSpacing - leftPreferredWidth.Value) * 2;
            }

            // The left block is flexible
            if (this.rightBlock == null)
            {
                // There is no right block.
                // The flexible center block must share the center side with half of the left block.
                return (halfWidthMinusOneObjectSpacing / 3) * 2; 
            }

            // There is a right block.
            if (rightPreferredWidth != null)
            {
                // The right block is not flexible.
                return LuaMath.min((halfWidthMinusOneObjectSpacing / 3) * 2, (halfWidthMinusOneObjectSpacing - rightPreferredWidth.Value) * 2);
            }

            // The right block is flexible
            return (width - (this.Layout.objectSpacing * 2)) / 3;
        }

        /// <summary>
        /// Gets the width allocated to the right block.
        /// </summary>
        /// <param name="width">The total width available.</param>
        /// <param name="leftPreferredWidth">The width preferred by the left block.</param>
        /// <param name="centerPreferredWidth">The width preferred by the center block.</param>
        /// <param name="rightPreferredWidth">The width preferred by the right block.</param>
        /// <returns>The allocated width.</returns>
        private double GetWidthAllocatedToRightBlock(double width, double? leftPreferredWidth, double? centerPreferredWidth, double? rightPreferredWidth)
        {
            if (this.rightBlock == null)
            {
                return 0;
            }

            // There is a right block.
            if (rightPreferredWidth != null)
            {
                return rightPreferredWidth.Value;
            }

            // The right block is flexible.
            if (this.centerBlock == null)
            {
                // There is no center block
                if (this.leftBlock == null)
                {
                    // There is no left block.
                    return width;
                }

                // There is a left block.
                if (leftPreferredWidth != null)
                {
                    // The left block is not flexible.
                    return width - (leftPreferredWidth.Value + this.Layout.objectSpacing);
                }

                // The left block is flexible
                return (width - this.Layout.objectSpacing) / 2;
            }

            // There is a center block
            if (centerPreferredWidth != null)
            {
                // The center block is fixed.
                return ((width - centerPreferredWidth.Value) / 2) - this.Layout.objectSpacing;
            }

            // The center block is flexible
            if (this.leftBlock == null)
            {
                // There is no left block.
                // The flexible right block must share the right side with half of the center block.
                return ((width / 2) - this.Layout.objectSpacing) / 1.5;
            }

            // There is a left block.
            if (leftPreferredWidth != null)
            {
                // The left block is not flexible.
                return LuaMath.max(leftPreferredWidth.Value, (((width / 2) - this.Layout.objectSpacing) / 3) * 2);
            }

            // The left block is flexible
            return (width - (this.Layout.objectSpacing * 2)) / 3;
        }
    }
}