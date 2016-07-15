namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using WidgetEnums;

    [ProvideSelf]
    public interface IRegion : IUIObject
    {
        void ClearAllPoints();
        object CreateAnimationGroup();
        object CreateAnimationGroup(string name);
        object CreateAnimationGroup(string name, string inheritsFrom);
        object GetAnimationGroups();
        double GetBottom();
        IMultipleValues<double, double> GetCenter();
        double GetHeight();
        double GetLeft();
        int GetNumPoints();
        IMultipleValues<FramePoint, IRegion, FramePoint?, double?, double?> GetPoint(int pointNum);
        IMultipleValues<double, double, double, double> GetRect();
        double GetRight();
        IMultipleValues<double, double> GetSize();
        double GetTop();
        double GetWidth();
        void Hide();
        bool IsDragging();
        bool IsProtected();
        bool IsShown();
        bool IsVisible();
        void SetAllPoints(IRegion frame);
        void SetAllPoints(string frameName);
        void SetHeight(double height);
        IRegion GetParent();
        void SetParent(IRegion parent);
        void SetParent(string parentName);
        void SetPoint(FramePoint point);
        void SetPoint(FramePoint point, double xOfs, double yOfs);
        void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint);
        void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint);
        void SetPoint(FramePoint point, IRegion relativeFrame, FramePoint relativePoint, double xOfs, double yOfs);
        void SetPoint(FramePoint point, string relativeFrameName, FramePoint relativePoint, double xOfs, double yOfs);
        void SetSize(double width, double height);
        void SetWidth(double width);
        void Show();
        void StopAnimating();
    }
}