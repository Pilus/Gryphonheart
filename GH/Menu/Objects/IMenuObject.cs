

namespace GH.Menu.Objects
{
    using CsLua;

    public interface IMenuObject : IMenuRegion
    {
        ObjectAlign GetAlignment();
        string GetId();
        double GetPreferredCenterX();
        double GetPreferredCenterY();
    }
}
