namespace BlizzardApi.WidgetInterfaces
{
    using System.Collections.Generic;

    public interface IUIObject : IIndexer<object, object>
    {
        
        double GetAlpha();
        string GetName();
        string GetObjectType();
        bool IsForbidden();
        bool IsObjectType(string type);
        void SetAlpha(double alpha);

        IUIObject self
        {
            get;
            set;
        }
    }
}