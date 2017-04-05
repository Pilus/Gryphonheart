
namespace GHD.Document.Containers
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using Elements;
    using Flags;

    public abstract class ContainerBase<T> : IContainer where T : class, IElement
    {
        private IFlags defaultFlags;

        protected ContainerBase(IFlags flags)
        {
            this.defaultFlags = flags;
        }

        public abstract IRegion Region { get; }

        protected ILinkedObject<T> FirstChild { get; set; }

        protected ILinkedObject<T> LastChild { get; set; }

        protected void PrependChild(T child) // TODO: Exstract the chain logic to a separate class.
        {
            var linkedChild = new LinkedObject<T>(child);
            if (this.FirstChild != null)
            {
                linkedChild.Next = this.FirstChild;
                this.FirstChild.Prev = linkedChild;
            }

            this.FirstChild = linkedChild;

            if (this.LastChild == null)
            {
                this.LastChild = this.FirstChild;
            }
        }

        protected void AppendChild(T child)
        {
            var linkedChild = new LinkedObject<T>(child);
            if (this.LastChild != null)
            {
                linkedChild.Prev = this.LastChild;
                this.LastChild.Next = linkedChild;
            }

            this.LastChild = linkedChild;

            if (this.FirstChild == null)
            {
                this.FirstChild = this.LastChild;
            }
        }

        protected ICursor Cursor { get; set; }
        protected ILinkedObject<T> CurrentCursorChild { get; set; }

        public void SetCursor(bool inEnd, ICursor cursor)
        {
            if (this.Cursor != null)
            {
                this.CurrentCursorChild.Object.ClearCursor();
            }

            this.Cursor = cursor;
            if (inEnd)
            {
                this.CurrentCursorChild = this.LastChild;
            }
            else
            {
                this.CurrentCursorChild = this.FirstChild;
            }

            if (this.CurrentCursorChild == null)
            {
                // Todo: No children. Render the cursor
            }
            else
            {
                this.CurrentCursorChild.Object.SetCursor(inEnd, cursor);
            }
        }

        public void ClearCursor()
        {
            if (this.Cursor == null)
            {
                throw new CursorException("Cursor have already been cleared or not been set");
            }

            this.CurrentCursorChild.Object.ClearCursor();
            this.CurrentCursorChild = null;
            this.Cursor = null;
        }

        /// <summary>
        /// Navigates the cursor on the container.
        /// </summary>
        /// <param name="type">The type of navigation</param>
        /// <returns>Weather the navigation was successful</returns>
        public virtual bool NavigateCursor(NavigationType type)
        {
            if (this.Cursor == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            return this.CurrentCursorChild.Object.NavigateCursor(type);
        }

        public int GetLength()
        {
            var child = this.FirstChild;
            var len = 0;

            while (child != null)
            {
                len += child.Object.GetLength();
                child = child.Next;
            }

            return len;
        }

        public abstract double GetWidth();

        public abstract double GetHeight();
       

        public void SetHightLight(int hightLightStart, int highLightEnd)
        {
            throw new System.NotImplementedException();
        }

        public void ClearHightLight()
        {
            throw new System.NotImplementedException();
        }

        public IFlags GetCurrentFlags()
        {
            if (this.Cursor == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            if (this.CurrentCursorChild == null)
            {
                return this.defaultFlags;
            }

            return this.CurrentCursorChild.Object.GetCurrentFlags();
        }

        public IElement GetCurrentElement()
        {
            throw new System.NotImplementedException();
        }

        protected abstract IDimensionConstraint GetConstraint(IDimensionConstraint originalConstraint, double consumed);

        protected virtual void SizeChanged()
        {
            
        }

        protected abstract double GetDimension(T child);

        public void Insert(IDocumentBuffer documentBuffer, IDimensionConstraint dimensionConstraint)
        {
            double dimensionConsumed = 0;
            var child = this.FirstChild;
            while (this.CurrentCursorChild != null && child != this.CurrentCursorChild)
            {
                dimensionConsumed += this.GetDimension(child.Object);
                child = child.Next;
            }

            var objectConstraint = this.GetConstraint(dimensionConstraint, dimensionConsumed);

            while (child != null)
            {
                child.Object.Insert(documentBuffer, objectConstraint);

                if (documentBuffer.EndOfBuffer())
                {
                    this.SizeChanged();
                    return;
                }

                dimensionConsumed += this.GetDimension(child.Object);
                objectConstraint = this.GetConstraint(dimensionConstraint, dimensionConsumed);

                if (child.Next != null)
                {
                    child = child.Next;

                    if (this.CurrentCursorChild != null)
                    {
                        this.CurrentCursorChild.Object.ClearCursor();
                        this.CurrentCursorChild = child;
                        this.CurrentCursorChild.Object.SetCursor(false, this.Cursor);
                    }
                    
                }
                else
                {
                    break;
                }
            }

            var newElement = this.ProduceChild(documentBuffer, objectConstraint);

            while (newElement != null)
            {
                this.AppendChild(newElement);
                dimensionConsumed += this.GetDimension(newElement);
                objectConstraint = this.GetConstraint(dimensionConstraint, dimensionConsumed);

                if (documentBuffer.EndOfBuffer())
                {
                    break;
                }
                newElement = this.ProduceChild(documentBuffer, objectConstraint);
            }

            if (this.Cursor != null)
            {
                this.CurrentCursorChild?.Object.ClearCursor();
                this.CurrentCursorChild = this.LastChild;
                this.CurrentCursorChild.Object.SetCursor(true, this.Cursor);
            }

            this.SizeChanged();
        }

        protected abstract T ProduceChild(IDocumentBuffer documentBuffer, IDimensionConstraint childConstraint);

        public abstract void Delete(IDocumentDeleter documentDeleter);

        protected static string GenerateFrameName(string prefix)
        {
            var i = 1;
            while (Global.Api.GetGlobal(prefix + i) != null)
            {
                i++;
            }
            return prefix + i;
        }

        public abstract Position GetCursorPosition();

        public abstract void SetCursorPosition(ICursor cursor, Position position);
    }
}
