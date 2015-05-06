

namespace GH.Menu.Objects
{
    using CsLua;

    public interface IMenuObject : IMenuRegion
    {
        ObjectAlign GetAlignment();

        string GetLabel();

        double GetPreferredCenterX();

        double GetPreferredCenterY();

        object GetValue();

        void Force(object value);

        void Clear();
    }
}
