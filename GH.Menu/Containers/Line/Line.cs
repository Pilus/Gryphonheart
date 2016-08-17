namespace GH.Menu.Containers.Line
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;
    using Lua;
    using GH.Menu.Containers;
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Objects;
    using GH.Menu.Theme;

    public class Line : BaseContainer<IAlignedBlock, LineProfile>, ILine
    {
        private IAlignedBlock leftBlock;
        private IAlignedBlock centerBlock;
        private IAlignedBlock rightBlock;

        public Line(IWrapper wrapper) : base("Line", wrapper)
        {

        }


        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(null, handler);
            var lineProfile = (LineProfile)profile;
            this.leftBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.l, handler);
            this.centerBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.c, handler);
            this.rightBlock = GenerateAndPrepareBlock(lineProfile, ObjectAlign.r, handler);
            this.Content = new List<IAlignedBlock>() {this.leftBlock, this.centerBlock, this.rightBlock};
        }

        private static IAlignedBlock GenerateAndPrepareBlock(LineProfile profile, ObjectAlign align,
            IMenuHandler handler)
        {
            var blockProfile = GenerateAlignedProfile(profile, align);
            if (blockProfile.Count == 0)
            {
                return null;
            }
            return (IAlignedBlock)handler.CreateRegion(blockProfile, false, typeof(AlignedBlock));
        }

        private static LineProfile GenerateAlignedProfile(LineProfile profile, ObjectAlign align)
        {
            var newProfile = new LineProfile();
            newProfile.AddRange(profile.Where(p => p.align == align));
            return newProfile;
        }

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
            this.leftBlock?.SetPosition(this.Frame, 0, 0, leftAllocatedWidth, this.leftBlock?.GetPreferredHeight() ?? height);

            var centerAllocatedWidth = this.GetWidthAllocatedToCenterBlock(width, leftPreferredWidth, centerPreferredWidth, rightPreferredWidth);
            this.centerBlock?.SetPosition(this.Frame, (width - centerAllocatedWidth) /2, 0, centerAllocatedWidth, this.centerBlock?.GetPreferredHeight() ?? height);

            var rightAllocatedWidth = this.GetWidthAllocatedToRightBlock(width, leftPreferredWidth, centerPreferredWidth, rightPreferredWidth);
            this.rightBlock?.SetPosition(this.Frame, width - rightAllocatedWidth, 0, rightAllocatedWidth, this.rightBlock?.GetPreferredHeight() ?? height);
        }

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
                return ((width - centerPreferredWidth.Value)/2) - this.Layout.objectSpacing;
            }
            
            // The center block is flexible

            if (this.rightBlock == null)
            {
                // There is no right block.
                // The flexible left block must share the left side with half of the center block.
                return ((width/2) - this.Layout.objectSpacing)/1.5;
            }

            // There is a right block.

            if (rightPreferredWidth != null)
            {

                // The right block is not flexible.
                return LuaMath.max(rightPreferredWidth.Value, (((width/2) - this.Layout.objectSpacing)/3)*2);
            }

            // The right block is flexible
            return (width - (this.Layout.objectSpacing * 2)) / 3;
        }

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
                    return ((width/2) - (rightPreferredWidth.Value + this.Layout.objectSpacing)) * 2;
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
                return ((width - centerPreferredWidth.Value)/2) - this.Layout.objectSpacing;
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

        public double? GetPreferredWidth()
        {
            var widths = this.Content.Select(block => block.GetPreferredWidth()).ToArray();
            if (widths.Any(w => w == null))
            {
                return null;
            }
            return widths.Sum() + ((widths.Length - 1) * this.Layout.objectSpacing);
        }

        public double? GetPreferredHeight()
        {
            var heights = this.Content.Select(block => block.GetPreferredHeight()).ToArray();
            if (heights.Any(w => w == null))
            {
                return null;
            }
            return heights.Max();
        }
    }
}