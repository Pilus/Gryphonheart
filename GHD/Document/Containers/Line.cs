
namespace GHD.Document.Containers
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using Lua;

    public class Line : ContainerBase, ILine
    {
        private readonly IFrame frame;

        public override IRegion Region
        {
            get { return this.frame; }
        }

        public Line(IFlags flags, IElementFactory elementFactory) : base(elementFactory.Create(flags, true))
        {
            this.frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, GenerateFrameName("GHD_DocumentLine"));

            var firstText = (FormattedText)this.FirstChild;
            firstText.Region.SetParent(this.frame);
            firstText.Region.SetPoint(FramePoint.BOTTOMLEFT, this.frame, FramePoint.BOTTOMLEFT);
        }

        public override bool NavigateCursor(NavigationType type)
        {
            if (this.Cursor == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            switch (type)
            {
                case NavigationType.Left:
                    if (this.CurrentCursorChild.NavigateCursor(type))
                    {
                        return true;
                    }

                    if (this.CurrentCursorChild.Prev == null)
                    {
                        return false;
                    }

                    this.CurrentCursorChild.ClearCursor();
                    this.CurrentCursorChild = this.CurrentCursorChild.Prev;
                    this.CurrentCursorChild.SetCursor(true, this.Cursor);
                    return true;
                case NavigationType.Right:
                    if (this.CurrentCursorChild.NavigateCursor(type))
                    {
                        return true;
                    }

                    if (this.CurrentCursorChild.Next == null)
                    {
                        return false;
                    }

                    this.CurrentCursorChild.ClearCursor();
                    this.CurrentCursorChild = this.CurrentCursorChild.Next;
                    this.CurrentCursorChild.SetCursor(false, this.Cursor);
                    return true;
                case NavigationType.End:
                    if (this.CurrentCursorChild != this.LastChild)
                    {
                        this.CurrentCursorChild.ClearCursor();
                    }

                    this.LastChild.SetCursor(true, this.Cursor);

                    return true;
                case NavigationType.Home:
                    throw new NotImplementedException();
            }

            throw new Exception("Unknown navigation event for line: " + type);
        }

        public override double GetWidth()
        {
            return this.frame.GetWidth();
        }

        public override double GetHeight()
        {
            return this.frame.GetHeight();
        }

        protected override IDimensionConstraint GetConstraint(IDimensionConstraint originalConstraint, double widthUsed)
        {
            return new DimensionConstraint()
            {
                MaxHeight = originalConstraint.MaxHeight,
                MaxWidth = originalConstraint.MaxWidth - widthUsed,
            };
        }

        protected override double GetDimension(IContainer child)
        {
            return child.GetWidth();
        }

        protected override void SizeChanged()
        {
            var obj = this.FirstChild;
            double width = 0;
            double height = 0;

            while (obj != null)
            {
                width += obj.GetWidth();
                height = LuaMath.max(height, obj.GetHeight());
                obj = obj.Next;
            }

            this.frame.SetWidth(width);
            this.frame.SetHeight(height);
        }

        public override void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
        }
    }
}
