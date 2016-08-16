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

            var leftPreferredWidth = this.centerBlock?.GetPreferredWidth();
            var centerPreferredWidth = this.centerBlock?.GetPreferredWidth();
            var rightPreferredWidth = this.centerBlock?.GetPreferredWidth();

            


            throw new NotImplementedException();
        }

        private double GetWidthAllocatedToLeftBlock(double width, double? leftPreferredWidth, double? centerPreferredWidth, double? rightPreferredWidth)
        {
            if (this.leftBlock == null)
            {
                return 0;
            }

            if (leftPreferredWidth != null)
            {
                return leftPreferredWidth.Value;
            }

            // The left block is flexible.

            if (this.centerBlock == null)
            {
                throw new NotImplementedException();
            }

            // There is a center block

            if (centerPreferredWidth != null)
            {
                // The center block is fixed.
                return (width - centerPreferredWidth.Value) - this.Layout.objectSpacing;
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
                // The left block would be able to grow to the size allowed by the right block
                // Due to that the left flexible block will be the same size as the right block.
                return rightPreferredWidth.Value;
            }

            // The right block is flexible
            return (width - (this.Layout.objectSpacing*2))
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