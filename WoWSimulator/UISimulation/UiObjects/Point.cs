namespace WoWSimulator.UISimulation.UiObjects
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class Point
    {
        public FramePoint _Point { get; set; }
        public IRegion RelativeFrame { get; set; }
        public FramePoint? RelativePoint { get; set; }
        public double? XOfs { get; set; }
        public double? YOfs { get; set; }
    }
}