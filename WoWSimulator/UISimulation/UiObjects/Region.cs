namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class Region : UIObject, IRegion
    {
        private bool shown = true;
        private double width = 0;
        private double height = 0;
        private IRegion parent;
        private readonly UiInitUtil util;

        public Region(UiInitUtil util, string objectType)
            : base(objectType)
        {
            this.util = util;
        }

        public Region(UiInitUtil util, string objectType, string name, IRegion parent)
            : base(objectType, name, parent)
        {
            this.util = util;
            this.parent = parent;
        }

        public Region(UiInitUtil util, string objectType, LayoutFrameType layout, IRegion parent)
            : base(util, objectType, layout, parent)
        {
            this.util = util;
            this.parent = parent;
            if (!string.IsNullOrEmpty(layout.inherits))
            {
                this.ApplyLayout(util.GetTemplate(layout.inherits), parent);
            }
            this.ApplyLayout(layout, parent);
        }

        private void ApplyLayout(LayoutFrameType layout, IRegion parent)
        {
            this.shown = !layout.hidden;
            if (!string.IsNullOrEmpty(layout.parentKey))
            {
                if (parent == null)
                {
                    throw new UiSimuationException("Attempted to set parent key on an object without parent.");
                }
                parent[layout.parentKey] = this;
            }

            if (layout.setAllPoints)
            {
                this.SetAllPoints(parent);
            }

            if (layout.Items == null) return;

            foreach (var item in layout.Items)
            {
                if (item is Dimension)
                {
                    this.ApplyDimension(item as Dimension);
                }
                else if (item is LayoutFrameTypeAnchors)
                {
                    this.ApplyLayoutFrameTypeAnchors(item as LayoutFrameTypeAnchors);
                }
            }
        }

        private void ApplyDimension(Dimension dim)
        {
            if (dim.Item is AbsDimension)
            {
                if (dim.xSpecified)
                {
                    this.width = ((AbsDimension)dim.Item).x;
                }

                if (dim.ySpecified)
                {
                    this.height = ((AbsDimension)dim.Item).y;
                }
            }
            else if (dim.Item is RelDimension)
            {
                throw new System.NotImplementedException();
            }
        }

        private void ApplyLayoutFrameTypeAnchors(LayoutFrameTypeAnchors anchors)
        {
            foreach (var anchor in anchors.Anchor)
            {
                var offsetSpecified = anchor.xSpecified || anchor.ySpecified;
                var point = this.util.ConvertEnum<FramePoint>(anchor.point);
                if (anchor.relativePointSpecified)
                {
                    var relativePoint = this.util.ConvertEnum<FramePoint>(anchor.relativePoint);
                    if (offsetSpecified)
                    {
                        this.SetPoint(point, anchor.relativeTo, relativePoint, anchor.x, anchor.y);
                    }
                    else
                    {
                        this.SetPoint(point, anchor.relativeTo, relativePoint);
                    }
                }
                else if (offsetSpecified)
                {
                    this.SetPoint(point, anchor.x, anchor.y);
                }
                else
                {
                    this.SetPoint(point);
                }
            }
        }

        public void ClearAllPoints()
        {
            throw new System.NotImplementedException();
        }

        public object CreateAnimationGroup()
        {
            throw new System.NotImplementedException();
        }

        public object CreateAnimationGroup(string name)
        {
            throw new System.NotImplementedException();
        }

        public object CreateAnimationGroup(string name, string inheritsFrom)
        {
            throw new System.NotImplementedException();
        }

        public object GetAnimationGroups()
        {
            throw new System.NotImplementedException();
        }

        public double GetBottom()
        {
            throw new System.NotImplementedException();
        }

        public double GetCenter()
        {
            throw new System.NotImplementedException();
        }

        public double GetHeight()
        {
            // todo: Calculate when anchors are in effect.
            throw new System.NotImplementedException();
        }

        public double GetLeft()
        {
            throw new System.NotImplementedException();
        }

        public int GetNumPoints()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<FramePoint, IRegion, FramePoint, double, double> GetPoint(int pointNum)
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double, double, double> GetRect()
        {
            throw new System.NotImplementedException();
        }

        public double GetRight()
        {
            throw new System.NotImplementedException();
        }

        public CsLua.Wrapping.IMultipleValues<double, double> GetSize()
        {
            throw new System.NotImplementedException();
        }

        public double GetTop()
        {
            throw new System.NotImplementedException();
        }

        public double GetWidth()
        {
            // todo: Calculate when anchors are in effect.
            return width;
        }

        public void Hide()
        {
            this.shown = false;
        }

        public bool IsDragging()
        {
            throw new System.NotImplementedException();
        }

        public bool IsProtected()
        {
            return false;
        }

        public bool IsShown()
        {
            return this.shown;
        }

        public bool IsVisible()
        {
            var parent = this.GetParent();
            return this.IsShown() && (parent == null || parent.IsShown());
        }

        public void SetAllPoints(IRegion frame)
        {
            throw new System.NotImplementedException();
        }

        public void SetAllPoints(string frameName)
        {
            throw new System.NotImplementedException();
        }

        public void SetHeight(double height)
        {
            this.height = height;
        }

        public IRegion GetParent()
        {
            return this.parent;
        }

        public void SetParent(IRegion parent)
        {
            this.parent = parent;
        }

        public void SetParent(string parentName)
        {
            var parent = this.util.GetObjectByName(parentName);
            if (parent == null)
            {
                throw new UiSimuationException(string.Format("Couldn't find region named '{0}'", parentName));
            }
            this.parent = (IRegion)parent;
        }

        public void SetPoint(FramePoint point)
        {
            throw new System.NotImplementedException();
        }

        public void SetPoint(FramePoint point, double xOfs, double yOfs)
        {
            throw new System.NotImplementedException();
        }

        public void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint)
        {
            throw new System.NotImplementedException();
        }

        public void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint)
        {
            throw new System.NotImplementedException();
        }

        public void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint, double xOfs, double yOfs)
        {
            throw new System.NotImplementedException();
        }

        public void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint, double xOfs, double yOfs)
        {
            throw new System.NotImplementedException();
        }

        public void SetSize(double width, double height)
        {
            this.width = width;
            this.height = height;
        }

        public void SetWidth(double width)
        {
            this.width = width;
        }

        public void Show()
        {
            this.shown = true;
        }

        public void StopAnimating()
        {
            throw new System.NotImplementedException();
        }
    }
}