namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;

    [ProvideSelf]
    public interface IUIObject : IIndexer<object, object>
    {
        
        double GetAlpha();
        string GetName();
        string GetObjectType();
        bool IsForbidden();
        bool IsObjectType(string type);
        void SetAlpha(double alpha);
    }
}