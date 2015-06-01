
namespace GHD.Document.Containers
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using CsLua;
    using CsLua.Collection;
    using Elements;
    using Flags;

    public abstract class ContainerBase : LinkedElement<IContainer>, IContainer
    {
        protected ContainerBase(IContainer child)
        {
            this.FirstChild = child;
            this.LastChild = FirstChild;
        }

        public abstract IRegion Region { get; }

        protected IContainer FirstChild { get; set; }

        protected IContainer LastChild { get; set; }

        protected void AppendChild(IContainer child)
        {
            this.LastChild.Next = child;
            child.Prev = this.LastChild;
            this.LastChild = child;
        }

        protected ICursor Cursor { get; set; }
        protected IContainer CurrentCursorChild { get; set; }

        public void SetCursor(bool inEnd, ICursor cursor)
        {
            if (this.Cursor != null)
            {
                this.CurrentCursorChild.ClearCursor();
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
            this.CurrentCursorChild.SetCursor(inEnd, cursor);
        }

        public void ClearCursor()
        {
            if (this.Cursor == null)
            {
                throw new CursorException("Cursor have already been cleared or not been set");
            }

            this.CurrentCursorChild.ClearCursor();
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

            return this.CurrentCursorChild.NavigateCursor(type);
        }

        public int GetLength()
        {
            var obj = this.FirstChild;
            var len = 0;

            while (obj != null)
            {
                len += obj.GetLength();
                obj = obj.Next;
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
            if (this.CurrentCursorChild == null)
            {
                throw new CursorException("The container does not have the cursor");
            }
            return this.CurrentCursorChild.GetCurrentFlags();
        }

        public IElement GetCurrentElement()
        {
            throw new System.NotImplementedException();
        }

        protected abstract IDimensionConstraint GetConstraint(IDimensionConstraint originalConstraint, double consumed);

        protected virtual void SizeChanged()
        {
            
        }

        protected abstract double GetDimension(IContainer child);

        public void Insert(IDocumentBuffer documentBuffer, IDimensionConstraint dimensionConstraint)
        {
            if (this.CurrentCursorChild == null)
            {
                throw new CursorException("The container does not have the cursor");
            }

            double dimensionConsumed = 0;
            var c = this.FirstChild;
            while (c != this.CurrentCursorChild)
            {
                dimensionConsumed += this.GetDimension(c);
                c = c.Next;
            }

            var objectConstraint = GetConstraint(dimensionConstraint, dimensionConsumed);

            while (this.CurrentCursorChild != null)
            {
                this.CurrentCursorChild.Insert(documentBuffer, objectConstraint);

                if (documentBuffer.EndOfBuffer())
                {
                    this.SizeChanged();
                    return;
                }

                dimensionConsumed += this.GetDimension(this.CurrentCursorChild);
                objectConstraint = GetConstraint(dimensionConstraint, dimensionConsumed);

                if (this.CurrentCursorChild.Next != null)
                {
                    this.CurrentCursorChild.ClearCursor();
                    this.CurrentCursorChild = this.CurrentCursorChild.Next;
                    this.CurrentCursorChild.SetCursor(false, this.Cursor);
                }
                else
                {
                    break;
                }
            }

            var newElement = documentBuffer.Get(objectConstraint);

            while (newElement != null)
            {
                this.AppendChild(newElement);
                dimensionConsumed += this.GetDimension(newElement);
                objectConstraint = GetConstraint(dimensionConstraint, dimensionConsumed);

                if (documentBuffer.EndOfBuffer())
                {
                    break;
                }
                newElement = documentBuffer.Get(objectConstraint);
            }

            if (this.CurrentCursorChild != this.LastChild)
            {
                this.CurrentCursorChild.ClearCursor();
                this.CurrentCursorChild = this.LastChild;
                this.CurrentCursorChild.SetCursor(true, this.Cursor);
            }

            this.SizeChanged();
        }

        public abstract void Delete(IDocumentDeleter documentDeleter);

        public void UpdateLayout(int position, IDocumentBuffer documentBuffer)
        {
            throw new System.NotImplementedException();
        }

        protected static string GenerateFrameName(string prefix)
        {
            var i = 1;
            while (Global.Api.GetGlobal(prefix + i) != null)
            {
                i++;
            }
            return prefix + i;
        }
    }
}
