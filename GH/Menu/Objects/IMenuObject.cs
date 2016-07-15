

namespace GH.Menu.Objects
{
    public interface IMenuObject : IMenuRegion
    {
        ObjectAlign GetAlignment();
        string GetId();
        double GetPreferredCenterX();
        double GetPreferredCenterY();
    }
}
