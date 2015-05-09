

namespace GH.Menu.Objects
{
    using CsLua;

    public interface IMenuObject : IMenuRegion
    {
        ObjectAlign GetAlignment();

        IMenuObject GetFrameById(string id);

        double GetPreferredCenterX();

        double GetPreferredCenterY();

        object GetValue();

        void SetValue(object value);

        void Clear();
    }
}
