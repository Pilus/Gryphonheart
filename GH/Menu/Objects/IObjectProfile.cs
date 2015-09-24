
namespace GH.Menu.Objects
{
    public interface IObjectProfile : IMenuRegionProfile
    {
        string type { get; }
        string label { get; set; }
        ObjectAlign align { get; set; }

    }
}
