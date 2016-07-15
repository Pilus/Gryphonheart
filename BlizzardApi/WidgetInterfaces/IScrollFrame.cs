namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;

    [ProvideSelf]
    public interface IScrollFrame : IFrame
    {
        double GetHorizontalScroll();
        object GetHorizontalScrollRange();
        IRegion GetScrollChild();
        double GetVerticalScroll();
        object GetVerticalScrollRange();
        void SetHorizontalScroll(double offset);
        void SetScrollChild(IRegion child);
        void SetVerticalScroll(double offset);
        void UpdateScrollChildRect();
    }
}