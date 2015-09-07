namespace WoWSimulator.UISimulation.UiObjects
{
    using BlizzardApi.WidgetInterfaces;

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
            throw new System.NotImplementedException();
        }

        public object GetHorizontalScrollRange()
        {
            throw new System.NotImplementedException();
        }

        public IRegion GetScrollChild()
        {
            throw new System.NotImplementedException();
        }

        public double GetVerticalScroll()
        {
            throw new System.NotImplementedException();
        }

        public object GetVerticalScrollRange()
        {
            throw new System.NotImplementedException();
        }

        public void SetHorizontalScroll(double offset)
        {
            throw new System.NotImplementedException();
        }

        public void SetScrollChild(IRegion child)
        {
            throw new System.NotImplementedException();
        }

        public void SetVerticalScroll(double offset)
        {
            throw new System.NotImplementedException();
        }

        public void UpdateScrollChildRect()
        {
            throw new System.NotImplementedException();
        }
    }
}