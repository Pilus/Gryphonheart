namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using TestUtils;
    using XMLHandler;

    public class Region : UIObject, IRegion
    {
        private bool shown = true;
        private double width = 0;
        private double height = 0;
        private IRegion parent;
        private readonly UiInitUtil util;
        private readonly Dictionary<FramePoint, Point> points = new Dictionary<FramePoint, Point>();

        public Region(UiInitUtil util, string objectType, LayoutFrameType layout, IRegion parent)
            : base(util, objectType, layout, parent)
        {
            this.util = util;
            this.parent = parent;
            if (!string.IsNullOrEmpty(layout.inherits))
            {
                this.ApplyLayout(util.GetTemplate(layout.inherits) as LayoutFrameType, parent);
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
                if (item is LayoutFrameTypeSize)
                {
                    this.ApplySize(item as LayoutFrameTypeSize);
                }
                else if (item is LayoutFrameTypeAnchors)
                {
                    this.ApplyLayoutFrameTypeAnchors(item as LayoutFrameTypeAnchors);
                }
            }
        }

        private void ApplySize(LayoutFrameTypeSize size)
        {
            if (size.xSpecified)
            {
                this.width = size.x;
            }

            if (size.ySpecified)
            {
                this.height = size.y;
            }

            if (size.AbsDimension != null)
            {
                this.width = size.AbsDimension.x;
                this.height = size.AbsDimension.y;
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
            this.points.Clear();
        }

        public object CreateAnimationGroup()
        {
            throw new NotImplementedException();
        }

        public object CreateAnimationGroup(string name)
        {
            throw new NotImplementedException();
        }

        public object CreateAnimationGroup(string name, string inheritsFrom)
        {
            throw new NotImplementedException();
        }

        public object GetAnimationGroups()
        {
            throw new NotImplementedException();
        }

        public double GetBottom()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double> GetCenter()
        {
            throw new NotImplementedException();
        }

        public double GetHeight()
        {
            if (this.points.Count < 2)
            {
                return this.height;
            }
            // todo: Calculate when anchors are in effect.
            throw new NotImplementedException();
        }

        public double GetLeft()
        {
            throw new NotImplementedException();
        }

        public int GetNumPoints()
        {
            return this.points.Count;
        }

        public IMultipleValues<FramePoint, IRegion, FramePoint?, double?, double?> GetPoint(int pointNum)
        {
            var point = this.points[this.points.Keys.ToList()[pointNum]];
            return TestUtil.StructureMultipleValues(point._Point, point.RelativeFrame, point.RelativePoint, point.XOfs, point.YOfs);
        }

        public IMultipleValues<double, double, double, double> GetRect()
        {
            throw new NotImplementedException();
        }

        public double GetRight()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double> GetSize()
        {
            throw new NotImplementedException();
        }

        public double GetTop()
        {
            throw new NotImplementedException();
        }

        public double GetWidth()
        {
            if (this.points.Count < 2)
            {
                return this.width;
            }
            // todo: Calculate when anchors are in effect.
            throw new NotImplementedException();
        }

        public virtual void Hide()
        {
            this.shown = false;
        }

        public bool IsDragging()
        {
            throw new NotImplementedException();
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
            //throw new System.NotImplementedException();
        }

        public void SetAllPoints(string frameName)
        {
            //throw new System.NotImplementedException();
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
            
            if (parent is Frame)
            {
                (parent as Frame).Children.Add(this as IFrame);
            }
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

        private void AddPoint(Point point)
        {
            this.points[point._Point] = point;
        }

        public void SetPoint(FramePoint point)
        {
            this.AddPoint(new Point()
            {
                _Point = point,
            });
        }

        public void SetPoint(FramePoint point, double xOfs, double yOfs)
        {
            this.AddPoint(new Point()
            {
                _Point = point,
                XOfs = xOfs,
                YOfs = yOfs,
            });
        }

        public void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint)
        {
            this.AddPoint(new Point()
            {
                _Point = point,
                RelativeFrame = relativeFrame,
                RelativePoint = relativePoint,
            });
        }

        public void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint)
        {
            this.SetPoint(point, this.util.GetObjectByName(relativeFrameName) as IRegion, relativePoint);
        }

        public void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint, double xOfs, double yOfs)
        {
            this.AddPoint(new Point()
            {
                _Point = point,
                RelativeFrame = relativeFrame,
                RelativePoint = relativePoint,
                XOfs = xOfs,
                YOfs = yOfs,
            });
        }

        public void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint, double xOfs, double yOfs)
        {
            this.SetPoint(point, relativeFrameName != null ? this.util.GetObjectByName(relativeFrameName) as IRegion : this.parent, relativePoint, xOfs, yOfs);
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
            throw new NotImplementedException();
        }
    }
}