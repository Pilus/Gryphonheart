
namespace GHD.Document.Containers
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Data;
    using Elements;
    using GHD.Document.Flags;
    using Buffer;
    using BlizzardApi.Global;

    public class Page : ContainerBase, IContainer
    {
        private readonly IFrame frame;
        private readonly IPageProperties properties;
        private readonly IFlags flags;

        public Page(IFlags flags, IPageProperties properties)
            : base(new Line(flags))
        {
            this.flags = flags;
            this.properties = properties;
            this.frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, GenerateFrameName("GHD_DocumentPage"));
            this.frame.SetWidth(this.properties.Width);
            this.frame.SetHeight(this.properties.Height);

            var texture = this.frame.CreateTexture();
            texture.SetAllPoints(this.frame);
            texture.SetTexture(0.1, 0.1, 0.1);

            this.FirstChild.Region.SetPoint(FramePoint.TOPLEFT, this.frame, FramePoint.TOPLEFT, this.properties.EdgeLeft, -this.properties.EdgeTop);
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

        protected override double GetDimension(IContainer child)
        {
            return child.GetHeight();
        }

        public void OldInsert(IDocumentBuffer documentBuffer, IDimensionConstraint dimensionConstraint)
        {
            // TODO: Delete this when done!
            if (this.CurrentCursorChild == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            double heightUsed = 0;
            var c = this.FirstChild;
            while (c != this.CurrentCursorChild)
            {
                heightUsed += c.GetHeight();
                c = c.Next;
            }

            var objectConstraint = GetConstraint(null, heightUsed);

            while (this.CurrentCursorChild != null)
            {
                this.CurrentCursorChild.Insert(documentBuffer, objectConstraint);

                if (documentBuffer.EndOfBuffer())
                {
                    return;
                }

                heightUsed += this.CurrentCursorChild.GetWidth();
                objectConstraint = GetConstraint(null, heightUsed);

                this.CurrentCursorChild.ClearCursor();
                this.CurrentCursorChild = this.CurrentCursorChild.Next;
                if (this.CurrentCursorChild != null)
                {
                    this.CurrentCursorChild.SetCursor(false, this.Cursor);
                }
            }

            var newElement = documentBuffer.Peek(objectConstraint);

            while (newElement != null)
            {
                var newLine = new Line(this.flags);
                this.AppendChild(newLine);
                newLine.Insert(documentBuffer, objectConstraint);
                heightUsed += newLine.GetHeight();
                objectConstraint = GetConstraint(null, heightUsed);

                if (documentBuffer.EndOfBuffer())
                {
                    break;
                }
                newElement = documentBuffer.Peek(objectConstraint);
            }

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
            }

            throw new CsException("Unknown navigation event for page: " + type);
        }
    }
}
