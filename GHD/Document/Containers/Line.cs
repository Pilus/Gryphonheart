
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

    public class Line : ContainerBase<IElement>, ILine
    {
        private readonly IFrame frame;

        public override IRegion Region
        {
            get { return this.frame; }
        }

        public Line(IFlags flags, IElementFactory elementFactory) : this(flags, elementFactory, elementFactory.Create(flags, true))
        {
            
        }
        public Line(IFlags flags, IElementFactory elementFactory, IElement firstChild) : base(firstChild)
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
                case NavigationType.End:
                    if (this.CurrentCursorChild != this.LastChild)
                    {
                        this.CurrentCursorChild.Object.ClearCursor();
                    }

                    this.LastChild.Object.SetCursor(true, this.Cursor);

                    return true;
                case NavigationType.Home:
                    if (this.CurrentCursorChild != this.FirstChild)
                    {
                        this.CurrentCursorChild.Object.ClearCursor();
                    }

                    this.FirstChild.Object.SetCursor(false, this.Cursor);

                    return true;
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

        protected override double GetDimension(IElement child)
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
                width += obj.Object.GetWidth();
                height = LuaMath.max(height, obj.Object.GetHeight());
                obj = obj.Next;
            }

            this.frame.SetWidth(width);
            this.frame.SetHeight(height);
        }

        protected override IElement ProduceChild(IElement element)
        {
            return element;
        }

        public override void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
        }

        public override Position GetCursorPosition()
        {
            var element = this.FirstChild;
            double x = 0;

            while (element != this.CurrentCursorChild)
            {
                x += element.Object.GetWidth();
                element = element.Next;
            }

            var pos = this.CurrentCursorChild.Object.GetCursorPosition();
            pos.X += x;
            return pos;
        }

        public override void SetCursorPosition(ICursor cursor, Position position)
        {
            this.Cursor = cursor;
            var element = this.FirstChild;
            double x = 0;

            while (element != null && x < position.X)
            {
                x += element.Object.GetWidth();
            }

            
            if (element == null)
            {
                element = this.LastChild;
                position.X = this.LastChild.Object.GetWidth();
            }
            else
            {
                position.X -= x - this.LastChild.Object.GetWidth();
            }

            element.Object.SetCursorPosition(cursor, position);
            this.CurrentCursorChild = element;
        }
    }
}
