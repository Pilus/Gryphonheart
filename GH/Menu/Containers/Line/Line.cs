namespace GH.Menu.Containers.Line
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Debug;
    using Lua;
    using BlizzardApi.Global;
    using Theme;
    using GH.Menu.Containers;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Line;

    public class Line : BaseContainer<IMenuObject, IObjectProfile>, ILine
    {
        private double objectSpacing;

        public Line() : base("Line")
        {

        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.objectSpacing = handler.Layout.objectSpacing;
        }

        public void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetParent(parent);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);

            var leftObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.l);
            var centerObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.c);
            var rightObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.r);

            var leftWidth = leftObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);
            var centerWidth = centerObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);
            var rightWidth = rightObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);

            if (leftObjects.Any() && !centerObjects.Any() && !rightObjects.Any())
            {
                leftWidth -= this.objectSpacing;
            }
            else if (centerObjects.Any())
            {
                centerWidth -= this.objectSpacing;
            }
            else if (rightObjects.Any())
            {
                rightWidth -= this.objectSpacing;
            }

            var centerObjectsWithFlixibleWidth = centerObjects.Where(obj => this.GetPreferredWidth() == null);
            if (centerObjects.Any() && !leftObjects.Any() && !rightObjects.Any() &&
                !centerObjectsWithFlixibleWidth.Any())
            {
                this.SetUpLineWithOnlyNonFlexibleCenterObjects(width, centerWidth, height, centerObjects);
            }
            else if (centerObjects.Any())
            {
                this.SetUpLineWithCenterObject(width, height, leftWidth, centerWidth, rightWidth, leftObjects, centerObjects, centerObjectsWithFlixibleWidth, rightObjects);
            }
            else
            {
                this.SetUpLineWithoutCenterObject(width, leftWidth, rightWidth, height, leftObjects, rightObjects);
            }
        }

        private void SetUpLineWithOnlyNonFlexibleCenterObjects(double width, double centerWidth, double height, CsLuaList<IMenuObject> centerObjects )
        {
            var heightAboveMedian = this.GetHeightAboveMedian();
            var gabWidth = (width - centerWidth) / (centerObjects.Count * 2);
            var x = gabWidth;
            centerObjects.Foreach(obj =>
            {
                var w = (double) obj.GetPreferredWidth();
                var h = obj.GetPreferredHeight();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian), w, h ?? height);
                x += w + gabWidth * 2;
            });
        }

        private void PositionCenterObjects(double xOff, double height, CsLuaList<IMenuObject> centerObjects, double heightAboveMedian, double centerFlexUnitSize)
        {
            var x = xOff;
            centerObjects.Foreach(obj =>
            {
                var w = obj.GetPreferredWidth();
                var h = obj.GetPreferredHeight();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian),  w ?? centerFlexUnitSize, h ?? height);
                x += (w ?? centerFlexUnitSize) + this.objectSpacing;
            });
        }

        private void PositionLeftSide(double allocatedWidth, double leftWidth, double height, CsLuaList<IMenuObject> leftObjects, CsLuaList<IMenuObject> leftObjectsWithFlixibleWidth, double heightAboveMedian)
        {
            var leftFlexUnitSize = (allocatedWidth - leftWidth) / leftObjectsWithFlixibleWidth.Count;
            double x = 0;
            leftObjects.Foreach(obj =>
            {
                var h = obj.GetPreferredHeight();
                var w = obj.GetPreferredWidth();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian),  w ?? leftFlexUnitSize, h ?? height);
                x += (w ?? leftFlexUnitSize) + this.objectSpacing;
            });
        }

        private void PositionRightSide(double allocatedWidth, double rightWidth, double width, double height, CsLuaList<IMenuObject> rightObjects, CsLuaList<IMenuObject> rightObjectsWithFlixibleWidth, double heightAboveMedian)
        {
            var rightFlexUnitSize = (allocatedWidth - rightWidth) / rightObjectsWithFlixibleWidth.Count;
            double rightFlexSize = 0;
            if (rightObjectsWithFlixibleWidth.Count > 0)
            {
                rightFlexSize = rightFlexUnitSize * rightObjectsWithFlixibleWidth.Count;
            }

            var x = width - rightWidth - rightFlexSize;
            rightObjects.Foreach(obj =>
            {
                var w = obj.GetPreferredWidth();
                var h = obj.GetPreferredHeight();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian),  w ?? rightFlexUnitSize, h ?? height);
                x += (w ?? rightFlexUnitSize) + this.objectSpacing;
            });
        }

        private void SetUpLineWithCenterObject(double width, double height, double leftWidth, double centerWidth, double rightWidth, CsLuaList<IMenuObject> leftObjects, CsLuaList<IMenuObject> centerObjects, CsLuaList<IMenuObject> centerObjectsWithFlexibleWidth, 
            CsLuaList<IMenuObject> rightObjects)
        {
            var leftObjectsWithFlixibleWidth = leftObjects.Where(obj => this.GetPreferredWidth() == null);
            var rightObjectsWithFlixibleWidth = rightObjects.Where(obj => this.GetPreferredWidth() == null);

            double centerFlexUnitSize = 0;
            if (centerObjectsWithFlexibleWidth.Any())
            {
                var widthAvailableLeft = (width / 2) - leftWidth - (centerWidth / 2);
                var widthAvailableRight = (width / 2) - rightWidth - (centerWidth / 2);
                var leftFlexUnitSize = widthAvailableLeft / (leftObjectsWithFlixibleWidth.Count + (centerObjectsWithFlexibleWidth.Count / 2));
                var rightFlexUnitSize = widthAvailableRight / (rightObjectsWithFlixibleWidth.Count + (centerObjectsWithFlexibleWidth.Count / 2));
                centerFlexUnitSize = LuaMath.min(leftFlexUnitSize, rightFlexUnitSize);

                centerWidth = centerWidth + centerFlexUnitSize * centerObjectsWithFlexibleWidth.Count;
            }

            var heightAboveMedian = this.GetHeightAboveMedian();

            this.PositionCenterObjects((width - centerWidth) / 2, height, centerObjects, heightAboveMedian, centerFlexUnitSize);
            this.PositionLeftSide((width - centerWidth) / 2, leftWidth, height, leftObjects, leftObjectsWithFlixibleWidth,
                heightAboveMedian);
            this.PositionRightSide((width - centerWidth) / 2, rightWidth, width, height, rightObjects, rightObjectsWithFlixibleWidth, heightAboveMedian);
        }

        private void SetUpLineWithoutCenterObject(double width, double leftWidth, double rightWidth, double height, 
            CsLuaList<IMenuObject> leftObjects, CsLuaList<IMenuObject> rightObjects)
        {
            var leftObjectsWithFlixibleWidth = leftObjects.Where(obj => obj.GetPreferredWidth() == null);
            var rightObjectsWithFlixibleWidth = rightObjects.Where(obj => obj.GetPreferredWidth() == null);

            // set up left side and right side
            double flexUnitSize = 0;
            if (leftObjectsWithFlixibleWidth.Any() || rightObjectsWithFlixibleWidth.Any())
            {
                flexUnitSize = (width - leftWidth - rightWidth) / (leftObjectsWithFlixibleWidth.Count + rightObjectsWithFlixibleWidth.Count);
            }

            var heightAboveMedian = this.GetHeightAboveMedian();

            double x = 0;
            leftObjects.Foreach(obj =>
            {
                var w = obj.GetPreferredWidth();
                var h = obj.GetPreferredHeight();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian), w ?? flexUnitSize, h ?? height);
                x += (w ?? flexUnitSize) + this.objectSpacing;
            });

            x = width - rightWidth - flexUnitSize * rightObjectsWithFlixibleWidth.Count;
            rightObjects.Foreach(obj =>
            {
                var w = obj.GetPreferredWidth();
                var h = obj.GetPreferredHeight();
                obj.SetPosition(this.Frame, x, GetYPosition(obj, heightAboveMedian), w ?? flexUnitSize, h ?? height);
                x += (w ?? flexUnitSize) + this.objectSpacing;
            });
        }

        private static double GetYPosition(IMenuObject obj, double heightAboveMedian)
        {
            var preferredHeight = obj.GetPreferredHeight();
            var preferredCenterOffset = obj.GetPreferredCenterY();
            return preferredHeight == null ? 0 : heightAboveMedian + preferredCenterOffset - ((double)preferredHeight/2);
        }

        public double? GetPreferredWidth()
        {
            double? width = null;

            var objectsWithFlexibleWidth = this.Content.Where(obj => obj.GetPreferredWidth() == null);
            if (!objectsWithFlexibleWidth.Any())
            {
                var leftObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.l);
                var centerObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.c);
                var rightObjects = this.Content.Where(obj => obj.GetAlignment() == ObjectAlign.r);

                var leftWidth = leftObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);
                var centerWidth = centerObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);
                var rightWidth = rightObjects.Sum(obj => (obj.GetPreferredWidth() ?? 0) + this.objectSpacing);

                if (leftObjects.Any() && !centerObjects.Any() && !rightObjects.Any())
                {
                    leftWidth -= this.objectSpacing;
                }
                else if (centerObjects.Any())
                {
                    centerWidth -= this.objectSpacing;
                }
                else if (rightObjects.Any())
                {
                    rightWidth -= this.objectSpacing;
                }

                width = leftWidth + centerWidth + rightWidth;
            }

            return width;
        }

        public double GetHeightAboveMedian()
        {
            double height = 0;
            this.Content.Foreach(obj =>
            {
                var preferredHeight = obj.GetPreferredHeight();
                var preferredOffset = obj.GetPreferredCenterY();
                if (preferredHeight != null)
                {
                    height = LuaMath.max(height, ((double)preferredHeight/2) - preferredOffset);
                }
            });
            return height;
        }

        public double GetHeightBelowMedian()
        {
            double height = 0;
            this.Content.Foreach(obj =>
            {
                var preferredHeight = obj.GetPreferredHeight();
                var preferredOffset = obj.GetPreferredCenterY();
                if (preferredHeight != null)
                {
                    height = LuaMath.max(height, ((double) preferredHeight/2) + preferredOffset);
                }
            });
            return height;
        }

        public double? GetPreferredHeight()
        {
            var objectsWithFlexibleHeight = this.Content.Where(obj => obj.GetPreferredHeight() == null);

            if (!objectsWithFlexibleHeight.Any())
            {
                return this.GetHeightAboveMedian() + this.GetHeightBelowMedian();
            }
            return null;
        }
    }
}