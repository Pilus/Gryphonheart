
namespace GHD.Document.Containers
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Data;
    using Elements;
    using GHD.Document.Flags;
    using Buffer;
    using BlizzardApi.Global;

    public class Page : ContainerBase<ILine>, IPage
    {
        private readonly IFrame frame;
        private readonly IPageProperties properties;
        private readonly IFlags flags;

        public Page(IFlags flags, IPageProperties properties, IElementFactory elementFactory)
            : base(new Line(flags, elementFactory))
        {
            this.flags = flags;
            this.properties = properties;
            this.frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, GenerateFrameName("GHD_DocumentPage"));
            this.frame.SetWidth(this.properties.Width);
            this.frame.SetHeight(this.properties.Height);

            var texture = this.frame.CreateTexture();
            texture.SetAllPoints(this.frame);
            texture.SetTexture(0.1, 0.1, 0.1);

            this.FirstChild.Object.Region.SetPoint(FramePoint.TOPLEFT, this.frame, FramePoint.TOPLEFT, this.properties.EdgeLeft, -this.properties.EdgeTop);
        }

        public override IRegion Region
        {
            get { return this.frame; }
        }

        public override double GetWidth()
        {
            return this.properties.Width;
        }

        public override double GetHeight()
        {
            return this.properties.Height;
        }

        protected override IDimensionConstraint GetConstraint(IDimensionConstraint oritiConstraint, double heightUsed)
        {
            return new DimensionConstraint()
            {
                MaxHeight = this.properties.Height - (this.properties.EdgeTop + this.properties.EdgeBottom + heightUsed),
                MaxWidth = this.properties.Width - (this.properties.EdgeLeft + this.properties.EdgeRight),
            };
        }

        protected override double GetDimension(ILine child)
        {
            return child.GetHeight();
        }

        protected override ILine ProduceChild(IElement element)
        {
            throw new NotImplementedException();
        }

        public override void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
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
                case NavigationType.Home:
                    if (this.CurrentCursorChild.Object.NavigateCursor(type))
                    {
                        return true;
                    }

                    if (this.CurrentCursorChild.Prev == null)
                    {
                        return false;
                    }

                    this.CurrentCursorChild.Object.ClearCursor();
                    this.CurrentCursorChild = this.CurrentCursorChild.Prev;
                    this.CurrentCursorChild.Object.SetCursor(true, this.Cursor);
                    return true;
                case NavigationType.Right:
                case NavigationType.End:
                    if (this.CurrentCursorChild.Object.NavigateCursor(type))
                    {
                        return true;
                    }

                    if (this.CurrentCursorChild.Next == null)
                    {
                        return false;
                    }

                    this.CurrentCursorChild.Object.ClearCursor();
                    this.CurrentCursorChild = this.CurrentCursorChild.Next;
                    this.CurrentCursorChild.Object.SetCursor(false, this.Cursor);
                    return true;
                case NavigationType.Up:
                    if (this.CurrentCursorChild == this.FirstChild)
                    {
                        return false;
                    }

                    var cursorPos = this.CurrentCursorChild.Object.GetCursorPosition();
                    this.CurrentCursorChild.Object.ClearCursor();

                    this.CurrentCursorChild = this.CurrentCursorChild.Prev;
                    this.CurrentCursorChild.Object.SetCursorPosition(this.Cursor, cursorPos);
                    return true;
                case NavigationType.Down:
                    throw new NotImplementedException("Vertical navigation not implemented.");
            }

            throw new Exception("Unknown navigation event for page: " + type);
        }

        public override Position GetCursorPosition()
        {
            var child = this.FirstChild;
            double y = 0;

            while (child != this.CurrentCursorChild)
            {
                y += child.Object.GetHeight();
            }

            var pos = this.CurrentCursorChild.Object.GetCursorPosition();
            pos.Y += y;
            return pos;
        }

        /// <summary>
        /// Sets the cursor as close to the given position within the element as possible.
        /// </summary>
        /// <param name="position"></param>
        public override void SetCursorPosition(ICursor cursor, Position position)
        {
            this.Cursor = cursor;
            throw new NotImplementedException();
        }
    }
}
