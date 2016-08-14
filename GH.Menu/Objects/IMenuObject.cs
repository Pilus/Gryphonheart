

namespace GH.Menu.Objects
{
    public interface IMenuObject : IMenuRegion
    {
        ObjectAlign GetAlignment();
        string GetId();
        double GetPreferredOffsetX();
        double GetPreferredOffsetY();
    }
}
