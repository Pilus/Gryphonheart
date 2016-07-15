namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using XMLHandler;

    public class ScrollFrame : Frame, IScrollFrame
    {
        private UiInitUtil util;
        private IUIObject scrollChild;

        public ScrollFrame(UiInitUtil util, string objectType, ScrollFrameType frameType, IRegion parent) : base(util, objectType, frameType, parent)
        {
            this.util = util;
            this.ApplyType(frameType);
        }

        private void ApplyType(ScrollFrameType type)
        {
            if (type.Item != null)
            {
                this.scrollChild = this.util.CreateObject(type.Item.Item, this);
            }
        }

        public double GetHorizontalScroll()
        {
            throw new NotImplementedException();
        }

        public object GetHorizontalScrollRange()
        {
            throw new NotImplementedException();
        }

        public IRegion GetScrollChild()
        {
            throw new NotImplementedException();
        }

        public double GetVerticalScroll()
        {
            throw new NotImplementedException();
        }

        public object GetVerticalScrollRange()
        {
            throw new NotImplementedException();
        }

        public void SetHorizontalScroll(double offset)
        {
            throw new NotImplementedException();
        }

        public void SetScrollChild(IRegion child)
        {
            throw new NotImplementedException();
        }

        public void SetVerticalScroll(double offset)
        {
            throw new NotImplementedException();
        }

        public void UpdateScrollChildRect()
        {
            throw new NotImplementedException();
        }
    }
}